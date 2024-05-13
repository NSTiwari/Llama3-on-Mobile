file(REMOVE_RECURSE
  "libmlc_llm_module.pdb"
  "libmlc_llm_module.so"
)

# Per-language clean rules from dependency scanning.
foreach(lang CXX)
  include(CMakeFiles/mlc_llm_module.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
