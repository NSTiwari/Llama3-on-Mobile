file(REMOVE_RECURSE
  "libmlc_llm.a"
  "libmlc_llm.pdb"
)

# Per-language clean rules from dependency scanning.
foreach(lang CXX)
  include(CMakeFiles/mlc_llm_static.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
