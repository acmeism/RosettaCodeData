cmake_minimum_required(VERSION 3.1)
project(abelian_sandpile)

find_package(xtl REQUIRED)
find_package(xtensor REQUIRED)
# if xtensor was built with xsimd support:
# find_package(xsimd REQUIRED)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fopenmp")
include_directories(/usr/include/OpenImageIO)
find_library(OIIO "OpenImageIO")

add_executable(abelian_sandpile src/abelian_sandpile.cpp)

target_compile_options(abelian_sandpile PRIVATE -march=native -std=c++14)
target_link_libraries(abelian_sandpile xtensor ${OIIO})
