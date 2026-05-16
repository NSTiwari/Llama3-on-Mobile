# MobileLlama3: Llama 3 on Mobile

Run Llama-3-8B-Instruct fully on-device on an Android phone. This project covers the full pipeline: downloading the original Hugging Face weights, quantizing and compiling them with MLC-LLM for Android, and deploying through a native Jetpack Compose app that handles model download, loading, and chat inference directly on the phone.

<img src="https://github.com/NSTiwari/Llama3-on-Mobile/blob/main/llama3_icon.png" width="250" height="250"/>

## Pipeline

<img src="https://github.com/NSTiwari/Llama3-on-Mobile/blob/main/mobile-llama3-pipeline.png"/>

## Demo

<img src="https://github.com/NSTiwari/Llama3-on-Mobile/blob/main/mobilellama3.gif"/>

## How it works

**Step 1: Quantize and compile (Python)**

The `quantize_and_convert.py` script takes the original Llama-3-8B-Instruct weights and runs them through MLC-LLM's two-step conversion:

1. `convert_weight` applies q4f16_1 quantization, which stores weights in 4-bit integers but uses 16-bit floats for activations. This brings the model from ~16GB down to roughly 4.5GB.
2. `gen_config` produces the `mlc-chat-config.json` that the Android runtime reads to know the conversation template, context window size, and prefill chunk size.
3. `compile` takes that config and cross-compiles a `.tar` of device-specific kernels targeting the Android ABI. This is the step that bakes in the operator fusion and memory layout optimizations for mobile hardware.

The compiled artifacts are then pushed to Hugging Face Hub so the Android app can download them at first launch.

**Step 2: Android app (Kotlin + Jetpack Compose)**

The app is a standard Jetpack Compose project structured into a few view files and a ViewModel:

- `StartView.kt` handles the model selection screen. It reads `mlc-app-config.json` to get the list of available models and their download URLs, then manages the download progress using coroutines and a file channel to stream bytes from Hugging Face.
- `AppViewModel.kt` owns all the state. It drives model initialization through the `ChatModule` JNI bridge, tracks download progress, handles errors, and exposes observable state to the Compose UI.
- `ChatView.kt` is the conversation screen with a scrollable message list, a text input, and a send button. Messages stream in token by token as the model generates them.
- `ChatModule.java` is the JNI glue layer. It wraps the MLC-LLM C++ runtime and exposes methods like `prefill()`, `decode()`, and `reset()` to Kotlin.

The model runs entirely in RAM with no internet connection needed after the initial download.

## Project structure

```
Llama3-on-Mobile/
├── quantize_and_convert.py    # Full pipeline: download, quantize, compile, upload
├── requirements.txt
├── mobile-llama3/
│   ├── mlc4j/                 # MLC-LLM Java/JNI bridge
│   │   ├── src/main/java/.../ChatModule.java
│   │   └── CMakeLists.txt
│   └── MobileLlama3/          # Android app (Jetpack Compose)
│       └── app/src/main/java/.../
│           ├── AppViewModel.kt
│           ├── ChatView.kt
│           ├── StartView.kt
│           ├── NavView.kt
│           └── MainActivity.kt
├── mobilellama3.apk           # Pre-built APK for direct install
└── README.md
```

## Requirements

- A machine with an NVIDIA GPU (T4 or better) and CUDA 12.2 for the compilation step
- Python 3.10+
- A Hugging Face account with access to `meta-llama/Meta-Llama-3-8B-Instruct`
- Android Studio (Hedgehog or newer) to build the app, or just install the APK directly

## Steps to run

### 1. Quantize and compile the model

```bash
pip install -r requirements.txt

python quantize_and_convert.py \
    --hf-token YOUR_HF_TOKEN \
    --model-id meta-llama/Meta-Llama-3-8B-Instruct \
    --quantization q4f16_1 \
    --hub-repo Llama-3-8B-q4f16_1-android
```

This downloads the weights, quantizes them, compiles for Android, and uploads everything to your Hugging Face Hub. On a T4 GPU the compilation step takes roughly 20 to 30 minutes.

To skip the upload and only produce local artifacts:

```bash
python quantize_and_convert.py --hf-token YOUR_HF_TOKEN --skip-upload
```

### 2. Install the Android app

**Option A: Direct APK install**

Download and install `mobilellama3.apk` on your Android phone (enable "Install from unknown sources" in settings).

**Option B: Build from source**

Open the `mobile-llama3/MobileLlama3` directory in Android Studio and build the project. Connect a physical Android device (emulators won't have enough RAM).

### 3. Load the model on the phone

On first launch the app reads `mlc-app-config.json` to get the list of models and downloads the compiled weights from Hugging Face. Once downloaded, the model loads into RAM and you can start chatting. No internet is needed after this point.

## Pre-converted weights

The compiled weights for Llama-3-8B-Instruct (q4f16_1) are already available on HuggingFace so you can skip the compilation step entirely:

[NSTiwari/Llama-3-8B-q4f16_1-android](https://huggingface.co/NSTiwari/Llama-3-8B-q4f16_1-android)

## References

- [Medium blog: step-by-step implementation](https://tiwarinitin1999.medium.com/ml-story-mobilellama3-run-llama3-locally-on-mobile-36182fed3889)
- [Medium blog: setting up the environment on GCP](https://tiwarinitin1999.medium.com/set-up-android-studio-on-gcp-vm-instance-81081febb071)

## Citation

```bibtex
@software{mlc-llm,
    author = {MLC team},
    title = {{MLC-LLM}},
    url = {https://github.com/mlc-ai/mlc-llm},
    year = {2023}
}
```
