const ESC = "\u001B" # escape code
print("$ESC[?25l")                       # hide the cursor
print("Enter anything, press RETURN: ")  # prompt shown
input = readline()                       # but no cursor
print("$ESC[0H$ESC[0J$ESC[?25h")         # reset, visible again
sleep(3)
println()
