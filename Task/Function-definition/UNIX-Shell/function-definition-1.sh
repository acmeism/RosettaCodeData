multiply() {
  # There is never anything between the parentheses after the function name
  # Arguments are obtained using the positional parameters $1, and $2
  # The return is given as a parameter to the return command
  return `expr "$1" \* "$2"`    # The backslash is required to suppress interpolation
}

# Call the function
multiply 3 4    # The function is invoked in statement context
echo $?        # The dollarhook special variable gives the return value
