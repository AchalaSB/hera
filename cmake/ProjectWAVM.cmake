if(ProjectWAVMIncluded)
    return()
endif()
set(ProjectWAVMIncluded TRUE)

include(ExternalProject)
include(GNUInstallDirs)



set(prefix ${CMAKE_BINARY_DIR}/deps)
set(source_dir ${prefix}/src/wavm)
set(binary_dir ${prefix}/src/wavm-build)
set(include_dir ${source_dir}/Include)

set(runtime_library ${binary_dir}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}Runtime${CMAKE_STATIC_LIBRARY_SUFFIX})

set(patch_command "sed -E 's/ SHARED / /' CMakeLists.txt")

ExternalProject_Add(wavm
    PREFIX ${prefix}
    DOWNLOAD_NAME wavm-1cb9b413d4ee73c6d58513839343a0a409254558.tar.gz
    DOWNLOAD_DIR ${prefix}/downloads
    SOURCE_DIR ${source_dir}
    BINARY_DIR ${binary_dir}
    URL https://github.com/AndrewScheidecker/WAVM/archive/1cb9b413d4ee73c6d58513839343a0a409254558.tar.gz
    URL_HASH SHA256=56d2054ad4350ab61882c0d5a988d7f067027824dd30667b097fc5b26c525b15
    PATCH_COMMAND sh ${CMAKE_CURRENT_LIST_DIR}/patch_wavm.sh
    CMAKE_ARGS
    -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
    -DCMAKE_BUILD_TYPE=Release
    INSTALL_COMMAND ""
    BUILD_BYPRODUCTS ${runtime_library}
)

file(MAKE_DIRECTORY ${include_dir})  # Must exist.


add_library(wavm::runtime STATIC IMPORTED)
set_target_properties(
    wavm::runtime
    PROPERTIES
    IMPORTED_CONFIGURATIONS Release
    IMPORTED_LOCATION_RELEASE ${runtime_library}
    INTERFACE_INCLUDE_DIRECTORIES ${include_dir}
)

add_dependencies(wavm::runtime wavm)
