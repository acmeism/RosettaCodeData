$$ MODE TUSCRIPT
tmpfile="test.txt"
ERROR/STOP CREATE (tmpfile,seq-E,-std-)
text="hello world"
FILE $tmpfile = text
- tmpfile "test.txt" can only be accessed by one user an will be deleted upon programm termination
