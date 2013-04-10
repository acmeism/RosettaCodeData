# Calculate pi to 40 digits after the decimal point.
execute_process(
  COMMAND printf "scale = 45; 4 * a(1) + 5 / 10 ^ 41\\n"
  COMMAND bc -l
  COMMAND sed -e "s/.\\{5\\}$//"
  OUTPUT_VARIABLE pi OUTPUT_STRIP_TRAILING_WHITESPACE)
message(STATUS "pi is ${pi}")
