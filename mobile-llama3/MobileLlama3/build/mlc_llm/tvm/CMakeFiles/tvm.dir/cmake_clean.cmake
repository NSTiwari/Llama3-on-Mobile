file(REMOVE_RECURSE
  "libtvm.pdb"
  "libtvm.so"
)

# Per-language clean rules from dependency scanning.
foreach(lang CXX)
  include(CMakeFiles/tvm.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
