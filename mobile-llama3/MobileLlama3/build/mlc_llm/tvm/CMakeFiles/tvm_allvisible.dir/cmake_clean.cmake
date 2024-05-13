file(REMOVE_RECURSE
  "libtvm_allvisible.pdb"
  "libtvm_allvisible.so"
)

# Per-language clean rules from dependency scanning.
foreach(lang CXX)
  include(CMakeFiles/tvm_allvisible.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
