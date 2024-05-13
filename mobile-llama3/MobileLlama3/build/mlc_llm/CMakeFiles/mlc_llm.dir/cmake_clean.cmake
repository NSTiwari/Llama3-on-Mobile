file(REMOVE_RECURSE
  "libmlc_llm.pdb"
  "libmlc_llm.so"
)

# Per-language clean rules from dependency scanning.
foreach(lang CXX)
  include(CMakeFiles/mlc_llm.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
