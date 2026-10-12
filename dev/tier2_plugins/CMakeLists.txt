cmake_minimum_required(VERSION 3.20)
project(GTASAPlugin VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include_directories(include)

# Build standalone Linux harness for development and testing
add_executable(plugin_test src/gpu_stats_plugin.cpp)

# When cross-compiling for Windows ASI/DLL with MinGW or Clang target
if(WIN32 OR MINGW)
    add_library(GTAPerformancePlugin SHARED src/gpu_stats_plugin.cpp)
    set_target_properties(GTAPerformancePlugin PROPERTIES SUFFIX ".asi")
endif()
