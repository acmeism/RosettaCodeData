dim crctbl(255)
const crcc =&hEDB88320

sub gencrctable
for i= 0 to 255
   k=i
   for j=1 to 8
    if k and 1 then
      k=(k and &h7fffffff)\2 or (&h40000000 and ((k and &h80000000)<>0))
      k=k xor crcc
    else
      k=(k and &h7fffffff)\2 or (&h40000000 and ((k and &h80000000)<>0))
   end if
   next ' j
   crctbl(i)=k
 next
end sub

 function crc32 (buf)
  dim r,r1,i
  r=&hffffffff
  for i=1 to len(buf)
      r1=(r and &h7fffffff)\&h100 or (&h800000 and (r and &h80000000)<>0)
    r=r1 xor crctbl((asc(mid(buf,i,1))xor r) and 255)
  next
  crc32=r xor &hffffffff
end function


'414FA339
gencrctable
wscript.stdout.writeline hex(crc32("The quick brown fox jumps over the lazy dog"))
