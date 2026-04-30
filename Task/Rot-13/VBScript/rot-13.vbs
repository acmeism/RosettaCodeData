option explicit

function rot13(a)
  dim b,n1,n,i
  b=""
  for i=1 to len(a)
    n=asc(mid(a,i,1))
    if n>=65 and n<= 91 then
       n1=(((n-65)+13)mod 26)+65
    elseif n>=97 and n<= 123 then
       n1=(((n-97)+13)mod 26)+97
    else
        n1=n
    end if
    b=b & chr(n1)
  next
  rot13=b
end function

const a="The quick brown fox jumps over the lazy dog."
dim b,c
wscript.echo a
b=rot13(a)
wscript.echo b
c=rot13(b)
wscript.echo c
