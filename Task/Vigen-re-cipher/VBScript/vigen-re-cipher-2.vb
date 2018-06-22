'vigenere cypher
option explicit
const asca =65  'ascii(a)

function filter(s)
    with new regexp
      .pattern="[^A-Z]"
      .global=1
      filter=.replace(ucase(s),"")
     end with
end function

function vigenere (s,k,sign)
dim s1,i,a,b
  for i=0 to len(s)-1
    a=asc(mid(s,i+1,1))-asca
    b=sign * (asc(mid(k,(i mod len(k))+1,1))-asca)
    s1=s1 & chr(((a+b+26) mod 26) +asca)
  next
  vigenere=s1
end function

function encrypt(s,k): encrypt=vigenere(s,k,1) :end function
function decrypt(s,k): decrypt=vigenere(s,k,-1) :end function

'test--------------------------
dim plaintext,filtered,key,encoded
key="VIGENERECYPHER"
plaintext = "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!"
filtered= filter(plaintext)
wscript.echo filtered
encoded=encrypt(filtered,key)
wscript.echo encoded
wscript.echo decrypt(encoded,key)
