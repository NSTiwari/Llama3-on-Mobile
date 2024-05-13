file(REMOVE_RECURSE
  "libtvm_runtime.a"
  "libtvm_runtime.pdb"
)

# Per-language clean rules from dependency scanning.
foreach(lang CXX)
  include(CMakeFiles/tvm_runtime.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
