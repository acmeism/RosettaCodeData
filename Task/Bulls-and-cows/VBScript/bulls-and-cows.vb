randomize timer
fail=array("Wrong number of chars","Only figures 0 to 9 allowed","Two or more figures are the same")
p=dopuzzle()
wscript.echo "Bulls and Cows. Guess my 4 figure number!"
do
 do
  wscript.stdout.write vbcrlf & "your move ": s=trim(wscript.stdin.readline)
  c=checkinput(s)
  if not isarray (c) then wscript.stdout.write fail(c) :exit do
  bu=c(0)
  wscript.stdout.write "bulls: " & c(0) & " | cows: " & c(1)
 loop while 0
loop until bu=4
wscript.stdout.write vbcrlf & "You won! "


function dopuzzle()
  dim b(10)
  for i=1 to 4
    do
      r=fix(rnd*10)
    loop until b(r)=0
    b(r)=1:dopuzzle=dopuzzle+chr(r+48)
  next
end function

function checkinput(s)
  dim c(10)
  bu=0:co=0
  if len(s)<>4 then checkinput=0:exit function
  for i=1 to 4
    b=mid(s,i,1)
    if instr("0123456789",b)=0 then checkinput=1 :exit function
		if c(asc(b)-48)<>0 then checkinput=2 :exit function
    c(asc(b)-48)=1
    for j=1 to 4
      if asc(b)=asc(mid(p,j,1)) then
        if i=j then bu=bu+1 else co=co+1
      end if
    next
  next
  checkinput=array(bu,co)
end function
