# This program outputs a greeting
BEGIN {
  sayhello()    # Call the function defined below
  exit
}

function sayhello {
   print "Hello World!"    # Outputs a message to the terminal
}
