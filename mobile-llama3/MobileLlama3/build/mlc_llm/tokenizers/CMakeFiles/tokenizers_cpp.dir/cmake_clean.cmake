file(REMOVE_RECURSE
  "libtokenizers_cpp.a"
  "libtokenizers_cpp.pdb"
)

# Per-language clean rules from dependency scanning.
foreach(lang CXX)
  include(CMakeFiles/tokenizers_cpp.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
