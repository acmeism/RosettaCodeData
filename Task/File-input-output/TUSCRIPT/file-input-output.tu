$$ MODE TUSCRIPT
ERROR/STOP CREATE ("input.txt", seq-o,-std-)
ERROR/STOP CREATE ("output.txt",seq-o,-std-)

FILE/ERASE "input.txt" = "Some irrelevant content"
path2input =FULLNAME(TUSTEP,"input.txt", -std-)
status=READ (path2input,contentinput)

path2output=FULLNAME(TUSTEP,"output.txt",-std-)
status=WRITE(path2output,contentinput)
