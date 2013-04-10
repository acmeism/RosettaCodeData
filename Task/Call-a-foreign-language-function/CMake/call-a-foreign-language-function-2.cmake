cmake_minimum_required(VERSION 2.6)
project(div C)

# Find cmCPluginAPI.h
include_directories(${CMAKE_ROOT}/include)

# Compile cmDIV from div-command.c
add_library(cmDIV MODULE div-command.c)
