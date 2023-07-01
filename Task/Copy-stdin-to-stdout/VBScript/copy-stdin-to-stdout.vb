do
  s=wscript.stdin.readline
  wscript.stdout.writeline s
loop until asc(left(s,1))=26
