cmake_minimum_required(VERSION 2.6)
project("outer project" C)

# Compile cmDIV.
try_compile(
  compiled_div                  # result variable
  ${CMAKE_BINARY_DIR}/div       # bindir
  ${CMAKE_SOURCE_DIR}/div       # srcDir
  div)                          # projectName
if(NOT compiled_div)
  message(FATAL_ERROR "Failed to compile cmDIV")
endif()

# Load cmDIV.
load_command(DIV ${CMAKE_BINARY_DIR}/div)
if(NOT CMAKE_LOADED_COMMAND_DIV)
  message(FATAL_ERROR "Failed to load cmDIV")
endif()

# Try div() command.
div(quot rem 2012 500)
message("
  2012 / 500 = ${quot}
  2012 % 500 = ${rem}
")
