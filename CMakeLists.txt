cmake_minimum_required(VERSION 3.28)
project(union-api VERSION 1.0.0 LANGUAGES CXX)

option(BUILD_UNION_API_STATIC "Build union-api as a static library"        ON)
option(BUILD_UNION_API_SHARED "Build union-api as a shared library"        ON)
option(BUILD_GOTHIC_API       "Build gothic-api as an interface target"    ON)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
set(UNION_API_SRC_DIR  "${CMAKE_CURRENT_SOURCE_DIR}/union-api"  CACHE STRING "The directory containing Union API source")
set(GOTHIC_API_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/gothic-api" CACHE STRING "The directory containing Gothic API source")

add_subdirectory(cmake)