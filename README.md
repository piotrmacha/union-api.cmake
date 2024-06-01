# union-api.cmake

This project provides CMake Targets and premade builds for [Union API](https://gitlab.com/union-framework/union-api) and
[Gothic API](https://gitlab.com/union-framework/gothic-api) libraries in all common build type configurations 
(Debug, Release, RelWithDebInfo, MinSizeRel) and with both static and shared library. 
Union API is a framework for creating native plugins for Gothic games based on ZenGin 
(Gothic 1, Gothic Sequel, Gothic 2, Gothic 2: Night of the Raven).

## Toolchains

Union API for Gothic works only as a x86 target built with MSVC, because the original game is a 32-bit MSVC artifact.
At this moment we suport toolsets:
* v142 (MSVC 14.20-14.29) - built with MSVC 14.29
* v143 (MSVC 14.30-14.49) - built with MSVC 14.39

Upgrades to an eventual next toolset will depend on the upstream Union API project, but it's not going to happen
soon as Microsoft decided to keep the toolset v143 for MSVC 14.40-14.49.

## Usage

The project is designed for CMake + Ninja compilation using standard build types (Debug, Release, RelWithDebInfo, MinSizeRel).
If you encounter any problems with compilation, make sure that you run CMake with "Ninja" as a generator and the
`CMAKE_BUILD_TYPE` variable is set to one of supported options. 

You can also copy [CMakePresets.json](https://github.com/piotrmacha/union-api.cmake/blob/main/CMakePresets.json) 
from this repository and place it in your project. The `x86-multi-config` (Ninja Multi-Config) profile is only for the compilation of
Union API and you should use the standard Ninja generator. 

### CMake (Source Compilation)

You can download the repository using `FetchContent` or Git submodules to compile Union API from sources.

```cmake
# Download the repository using FetchContent
include(FetchContent)
FetchContent_Declare(
        UnionAPI
        GIT_REPOSITORY https://github.com/piotrmacha/union-api.cmake.git
        # You can change main to the commit ref hash in order to pinpoint your build to specific version.
        # Using main is may break your build if some change breaks backwards compatibility. 
        GIT_TAG main 
)
FetchContent_MakeAvailable(UnionAPI)

# Static linking
target_link_libraries(my_project PRIVATE UnionAPIStatic GothicAPI)

# Dynamic linking 
target_link_libraries(my_project PRIVATE UnionAPI GothicAPI)
```

### CMake (Prebuild Libraries)

```cmake
include(FetchContent)
FetchContent_Declare(
        UnionAPI
        # Union API for MSVC toolset v143 (built using MSVC 14.39 on Visual Studio 2022)
        URL https://github.com/piotrmacha/union-api.cmake/releases/latest/download/UnionAPI-v143-windows-2022.zip
        # Union API for MSVC toolset v142 (built using MSVC 14.29 on Visual Studio 2022)
        #URL https://github.com/piotrmacha/union-api.cmake/releases/latest/download/UnionAPI-v142-windows-2022.zip
)
FetchContent_MakeAvailable(UnionAPI)
FetchContent_GetProperties(UnionAPI SOURCE_DIR UnionAPI_SOURCE_DIR)
set(CMAKE_FIND_PACKAGE_REDIRECTS_DIR ${UnionAPI_SOURCE_DIR})
set(UnionAPI_DIR ${UnionAPI_SOURCE_DIR}/lib/cmake/UnionAPI)
find_package(UnionAPI CONFIG REQUIRED)

# Static linking
target_link_libraries(my_project PRIVATE UnionAPI::UnionAPIStatic UnionAPI::GothicAPI)

# Dynamic linking
target_link_libraries(my_project PRIVATE UnionAPI::UnionAPI UnionAPI::GothicAPI)
```

### Dynamic linking: Copy DLL

If you are linking Union API dynamically, use following snippet to copy the DLLs to the install directory on CMake install. 

```cmake
# Copy all required DLL files to install directory
install(FILES $<TARGET_RUNTIME_DLLS:my_project> DESTINATION ${CMAKE_BINARY_DIR})
install(FILES $<TARGET_RUNTIME_DLLS:my_project> TYPE BIN)
install(TARGETS my_project
        EXPORT PluginTargets
        LIBRARY DESTINATION bin
        ARCHIVE DESTINATION bin
        RUNTIME DESTINATION bin)
install(EXPORT PluginTargets
        FILE PluginTargets.cmake
        DESTINATION lib/cmake/Plugin)
```

### Gothic API engines

Gothic API headers will provide the implementation for specific engine only if they have a compiler definition.
Add the definitions for all engines you'd like to support.

```
__G1        # Gothic 1
__G1A       # Gothic Sequel (never realesed, a.k.a Gothic 1 Addon)
__G2        # Gothic 2 (Classic)
__G2A       # Gothic 2: Night of the Raven (Gothic 2 Addon)
```

### UserAPI Directory

Gothic API has a mechanism to add additional methods to the engine classes by providing an include 
directory with *.inl files. You can use CMake to add the include directory BEFORE others. 
```
target_include_directories(my_project BEFORE PRIVATE My_Gothic_UserAPI)
```

Then just copy the files you need from `include/ZenGin/Gothic_UserAPI/`.

### Manual 

You can download the prebuild releases and link them in a project without CMake.
* MSVC v142 -  https://github.com/piotrmacha/union-api.cmake/releases/latest/download/UnionAPI-v142-windows-2022.zip
* MSVC v143 -  https://github.com/piotrmacha/union-api.cmake/releases/latest/download/UnionAPI-v143-windows-2022.zip

The prebuild releases have separate bin and lib directories for each build type and common include directory.
For every case you have to add `include` to your include directories.

#### Union API Static

Add `lib/{BUILD_TYPE}` to your link directories and link to `UnionAPIStatic.lib`.

Set compiler definitions:
```
# Release, RelWithDebInfo, MinSizeRel
WIN32 _CONSOLE UNION_API_LIB NDEBUG

# Debug
WIN32 _CONSOLE UNION_API_LIB _DEBUG
```

#### Union API Shared

Add `lib/{BUILD_TYPE}` to your link directories and link to `UnionAPI.lib`.

Copy `bin/{BUILD_TYPE}/UnionAPI.dll` to the working directory of your project.

Set compiler definitions:
```
# Release, RelWithDebInfo, MinSizeRel
WIN32 _CONSOLE UNION_API_DLL NDEBUG

# Debug
WIN32 _CONSOLE UNION_API_DLL _DEBUG
``

#### Gothic API 

Gothic API is a special case because it doesn't have a prebuilt library and consists mostly of header files and
a single C++ file to compile. 

To use it you have to add include directories:
```
include
include/ZenGin/Gothic_UserAPI
```

Add link directories:
```
include
```

Compile this single file in your project:
```
include/ZenGin/zGothicAPI.cpp
```

Add compiler definitions for the engines:
```
__G1 __G1A __G2 __G2A
```

Gothic API headers will load the libraries automatically.

## License

The CMake code is licensed under [GNU GPL3 Copyright (C) 2023  Piotr Macha, Union Framework](https://github.com/piotrmacha/union-api.cmake/blob/main/LICENSE)

Union API and Gothic API are licensed under:
* [Union API: GNU GPL3 Copyright (C) 2023  Union Framework](https://gitlab.com/union-framework/union-api/-/blob/main/LICENSE)
* [Gothic API: GNU GPL3 Copyright (C) 2023  Union Framework](https://gitlab.com/union-framework/gothic-api/-/blob/main/LICENSE)