option explicit
const maxk=94
dim key(94)

a="I'm working on modernizing Rosetta Code's infrastructure. Starting with communications."&_
" Please accept this time-limited open invite to RC's Slack.. --Michael Mol (talk) 20:59, 30 May 2020 (UTC)"

sub gen     'swaps items not previusly affected by a swap
  dim i,m,t
  for i=0 to ubound(key)
    key(i)=i+32
  next
  for i=0 to ubound(key)-1
    if key(i)=i+32 then
      m=i+int(rnd*(maxk-i))
     if key(m)=m+32 then
       t=key(m):key(m)=key(i):key(i)=t
     end if
   end if
  next
end sub

function viewkey
dim i,b
b=""
for i=1 to ubound(key)
   b=b&chr(key(i))
next
viewkey=b
end function

function iif(a,b,c) if a then iif=b else iif =c end if: end function

function docode(a)
  dim b,i,ch,n
  n=maxk+32
  b=""
  for i=1 to len(a)
   ch=asc(mid(a,i,1))
   'wscript.echo ch
   b=b&chr(key(iif (ch>n or ch<32,0,ch-32)))
  next
  docode=b
end function

randomize timer
dim a,b,c
gen
wscript.echo "Key:   " & viewkey & vbcrlf
wscript.echo "Original: " & a & Vbcrlf
b=docode(a)
wscript.echo "Encoded: "&  b & Vbcrlf
c=docode(b)
wscript.echo "Decoded: " & c & Vbcrlf
wscript.quit(0)
