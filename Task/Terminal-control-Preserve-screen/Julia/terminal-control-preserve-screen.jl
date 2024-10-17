const ESC = "\u001B" # escape code

print("$ESC[?1049h$ESC[H")
print("\n\nNow using an alternate screen buffer. Returning after count of: ")
foreach(x -> (sleep(1); print("  $x")), 5:-1:0)
print("$ESC[?1049l\n\n\n")
