"""
Quantizes and compiles the Llama-3-8B-Instruct model for Android using MLC-LLM,
then uploads the converted weights to Hugging Face Hub.

Run this script on a machine with an NVIDIA GPU (T4 or better recommended).
MLC-LLM nightly builds require CUDA 12.2.
"""

import argparse
import subprocess
import sys
import os
import torch
from pathlib import Path
from huggingface_hub import snapshot_download, whoami, upload_folder, create_repo, login


def check_gpu():
    if not torch.cuda.is_available():
        print("Warning: No CUDA GPU detected. Compilation will be very slow on CPU.")
        return "cpu"
    device_name = torch.cuda.get_device_name(0)
    print(f"GPU found: {device_name}")
    return "cuda:0"


def download_model(model_id: str, local_dir: str):
    print(f"Downloading {model_id} to {local_dir} ...")
    snapshot_download(repo_id=model_id, local_dir=local_dir)
    print("Download complete.")


def convert_weights(model_dir: str, quantization: str, output_dir: str):
    # Weight conversion applies the chosen quantization scheme and rewrites
    # the tensors into a format MLC-LLM can load at runtime on Android.
    cmd = [
        sys.executable, "-m", "mlc_llm", "convert_weight",
        model_dir,
        "--quantization", quantization,
        "-o", output_dir,
    ]
    print(f"Converting weights with quantization={quantization} ...")
    subprocess.run(cmd, check=True)
    print("Weight conversion done.")


def generate_config(model_dir: str, quantization: str, output_dir: str,
                    conv_template: str, context_window: int, prefill_chunk: int):
    # gen_config writes mlc-chat-config.json which tells the Android runtime
    # how to tokenize, what conversation template to use, and memory limits.
    cmd = [
        sys.executable, "-m", "mlc_llm", "gen_config",
        model_dir,
        "--quantization", quantization,
        "--conv-template", conv_template,
        "--context-window-size", str(context_window),
        "--prefill-chunk-size", str(prefill_chunk),
        "-o", output_dir,
    ]
    print("Generating MLC chat config ...")
    subprocess.run(cmd, check=True)
    print("Config generation done.")


def compile_for_android(config_path: str, output_dir: str, model_name: str, quantization: str):
    output_tar = os.path.join(output_dir, f"{model_name}-{quantization}-android.tar")
    cmd = [
        sys.executable, "-m", "mlc_llm", "compile",
        config_path,
        "--device", "android",
        "-o", output_tar,
    ]
    print("Compiling model for Android target ...")
    subprocess.run(cmd, check=True)
    print(f"Compilation done. Output: {output_tar}")
    return output_tar


def upload_to_hub(output_dir: str, repo_name: str, hf_token: str):
    login(token=hf_token)
    user_info = whoami()
    username = user_info["name"]
    repo_id = f"{username}/{repo_name}"

    print(f"Creating or reusing HF repo: {repo_id}")
    repo_id = create_repo(repo_id, exist_ok=True).repo_id

    print(f"Uploading from {output_dir} to {repo_id} ...")
    upload_folder(
        repo_id=repo_id,
        folder_path=output_dir,
        commit_message="Quantized Llama-3-8B-Instruct model for Android.",
        ignore_patterns=["step_*", "epoch_*"],
    )
    print(f"Upload complete. Model available at: https://huggingface.co/{repo_id}")


def parse_args():
    parser = argparse.ArgumentParser(
        description="Quantize and compile Llama-3-8B-Instruct for Android with MLC-LLM."
    )
    parser.add_argument(
        "--model-id",
        default="meta-llama/Meta-Llama-3-8B-Instruct",
        help="Hugging Face model ID to download (default: meta-llama/Meta-Llama-3-8B-Instruct).",
    )
    parser.add_argument(
        "--local-dir",
        default="./Llama-3-8B-Instruct",
        help="Local directory where the raw model weights are saved.",
    )
    parser.add_argument(
        "--quantization",
        default="q4f16_1",
        choices=["q4f16_1", "q4f32_1", "q8f16_1"],
        help="MLC quantization scheme to apply (default: q4f16_1).",
    )
    parser.add_argument(
        "--output-dir",
        default=None,
        help="Directory for converted weights and compiled artifacts. Defaults to <model-name>-<quant>-android/.",
    )
    parser.add_argument(
        "--conv-template",
        default="llama-3",
        help="Conversation template name recognized by MLC-LLM (default: llama-3).",
    )
    parser.add_argument(
        "--context-window",
        type=int,
        default=8192,
        help="Max context window size in tokens (default: 8192).",
    )
    parser.add_argument(
        "--prefill-chunk",
        type=int,
        default=1024,
        help="Prefill chunk size for the Android runtime (default: 1024).",
    )
    parser.add_argument(
        "--hf-token",
        required=True,
        help="Hugging Face access token (needs read access for gated models, write access for upload).",
    )
    parser.add_argument(
        "--hub-repo",
        default="Llama-3-8B-q4f16_1-android",
        help="Name of the HF repository to push the compiled artifacts to.",
    )
    parser.add_argument(
        "--skip-download",
        action="store_true",
        help="Skip the model download step if weights are already present in --local-dir.",
    )
    parser.add_argument(
        "--skip-upload",
        action="store_true",
        help="Skip the HF Hub upload step (useful for local-only testing).",
    )
    return parser.parse_args()


def main():
    args = parse_args()

    model_name = args.local_dir.rstrip("/").split("/")[-1]
    output_dir = args.output_dir or f"./{model_name}-{args.quantization}-android"
    os.makedirs(output_dir, exist_ok=True)

    check_gpu()

    if not args.skip_download:
        download_model(args.model_id, args.local_dir)
    else:
        print(f"Skipping download. Using existing weights in {args.local_dir}")

    convert_weights(args.local_dir, args.quantization, output_dir)

    generate_config(
        args.local_dir,
        args.quantization,
        output_dir,
        args.conv_template,
        args.context_window,
        args.prefill_chunk,
    )

    config_path = os.path.join(output_dir, "mlc-chat-config.json")
    compile_for_android(config_path, output_dir, model_name, args.quantization)

    if not args.skip_upload:
        upload_to_hub(output_dir, args.hub_repo, args.hf_token)
    else:
        print("Skipping upload. Artifacts are in:", output_dir)

    print("\nAll done.")


if __name__ == "__main__":
    main()
