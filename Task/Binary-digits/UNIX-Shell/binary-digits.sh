# Define a function to output binary digits
tobinary() {
  # We use the bench calculator for our conversion
  echo "obase=2;$1"|bc
}

# Call the function with each of our values
tobinary 5
tobinary 50
