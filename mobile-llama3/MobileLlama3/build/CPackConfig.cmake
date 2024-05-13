# This file will be configured to contain variables for CPack. These variables
# should be set in the CMake list file of the project before CPack module is
# included. The list of available CPACK_xxx variables and their associated
# documentation may be obtained using
#  cpack --help-variable-list
#
# Some variables are common to all generators (e.g. CPACK_PACKAGE_NAME)
# and some are specific to a generator
# (e.g. CPACK_NSIS_EXTRA_INSTALL_COMMANDS). The generator specific variables
# usually begin with CPACK_<GENNAME>_xxxx.


set(CPACK_BUILD_SOURCE_DIRS "/home/tiwarinitin1999/mlc-llm/android/mlc4j;/home/tiwarinitin1999/mlc-llm/android/MLCChat/build")
set(CPACK_CMAKE_GENERATOR "Unix Makefiles")
set(CPACK_COMPONENTS_ALL "Unspecified;msgpack-cxx")
set(CPACK_COMPONENT_UNSPECIFIED_HIDDEN "TRUE")
set(CPACK_COMPONENT_UNSPECIFIED_REQUIRED "TRUE")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Taku Kudo")
set(CPACK_DEFAULT_PACKAGE_DESCRIPTION_FILE "/usr/share/cmake-3.25/Templates/CPack.GenericDescription.txt")
set(CPACK_DEFAULT_PACKAGE_DESCRIPTION_SUMMARY "mlc-chat built using CMake")
set(CPACK_DMG_SLA_USE_RESOURCE_FILE_LICENSE "ON")
set(CPACK_GENERATOR "7Z")
set(CPACK_INSTALL_CMAKE_PROJECTS "/home/tiwarinitin1999/mlc-llm/android/MLCChat/build;mlc-chat;ALL;/")
set(CPACK_INSTALL_PREFIX "/home/tiwarinitin1999/mlc-llm/android/MLCChat/build")
set(CPACK_MODULE_PATH "")
set(CPACK_NSIS_DISPLAY_NAME "mlc-chat 0.2.00")
set(CPACK_NSIS_INSTALLER_ICON_CODE "")
set(CPACK_NSIS_INSTALLER_MUI_ICON_CODE "")
set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES")
set(CPACK_NSIS_PACKAGE_NAME "mlc-chat 0.2.00")
set(CPACK_NSIS_UNINSTALL_NAME "Uninstall")
set(CPACK_OBJCOPY_EXECUTABLE "/home/tiwarinitin1999/Android/Sdk/ndk/27.0.11718014/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-objcopy")
set(CPACK_OBJDUMP_EXECUTABLE "/home/tiwarinitin1999/Android/Sdk/ndk/27.0.11718014/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-objdump")
set(CPACK_OUTPUT_CONFIG_FILE "/home/tiwarinitin1999/mlc-llm/android/MLCChat/build/CPackConfig.cmake")
set(CPACK_PACKAGE_CONTACT "taku@google.com")
set(CPACK_PACKAGE_DEFAULT_LOCATION "/")
set(CPACK_PACKAGE_DESCRIPTION_FILE "/usr/share/cmake-3.25/Templates/CPack.GenericDescription.txt")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "mlc-chat built using CMake")
set(CPACK_PACKAGE_FILE_NAME "mlc-chat-0.2.00-Android")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "mlc-chat 0.2.00")
set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "mlc-chat 0.2.00")
set(CPACK_PACKAGE_NAME "mlc-chat")
set(CPACK_PACKAGE_RELOCATABLE "true")
set(CPACK_PACKAGE_VENDOR "Humanity")
set(CPACK_PACKAGE_VERSION "0.2.00")
set(CPACK_PACKAGE_VERSION_MAJOR "0")
set(CPACK_PACKAGE_VERSION_MINOR "1")
set(CPACK_PACKAGE_VERSION_PATCH "1")
set(CPACK_READELF_EXECUTABLE "/home/tiwarinitin1999/Android/Sdk/ndk/27.0.11718014/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-readelf")
set(CPACK_RESOURCE_FILE_LICENSE "/home/tiwarinitin1999/mlc-llm/3rdparty/tokenizers-cpp/sentencepiece/LICENSE")
set(CPACK_RESOURCE_FILE_README "/home/tiwarinitin1999/mlc-llm/3rdparty/tokenizers-cpp/sentencepiece/README.md")
set(CPACK_RESOURCE_FILE_WELCOME "/usr/share/cmake-3.25/Templates/CPack.GenericWelcome.txt")
set(CPACK_SET_DESTDIR "OFF")
set(CPACK_SOURCE_GENERATOR "TXZ")
set(CPACK_SOURCE_IGNORE_FILES "/build/;/.git/;/dist/;/sdist/;~$;")
set(CPACK_SOURCE_OUTPUT_CONFIG_FILE "/home/tiwarinitin1999/mlc-llm/android/MLCChat/build/CPackSourceConfig.cmake")
set(CPACK_STRIP_FILES "TRUE")
set(CPACK_SYSTEM_NAME "Android")
set(CPACK_THREADS "1")
set(CPACK_TOPLEVEL_TAG "Android")
set(CPACK_WIX_SIZEOF_VOID_P "8")

if(NOT CPACK_PROPERTIES_FILE)
  set(CPACK_PROPERTIES_FILE "/home/tiwarinitin1999/mlc-llm/android/MLCChat/build/CPackProperties.cmake")
endif()

if(EXISTS ${CPACK_PROPERTIES_FILE})
  include(${CPACK_PROPERTIES_FILE})
endif()
