-- 23 Oct 2025
include Setting
signal off notready

say 'BASE64 ENCODE DATA'
say version
say
call Task1 'Many hands make light work.'
call Task1 'Man'
call Task1 'Ma'
call Task1 'M'
call Task1 'any carnal pleasure.'
call Task2
exit

Task1:
procedure
parse arg xx
say 'Original' xx
say 'Encoded ' Encode64(xx)
say
return

Task2:
procedure
in='favicon.ico'; out='favicon.dat'
-- Get icon from web (curl is pre-installed on Windows 10/11, Unix and MacOS)
'curl https://rosettacode.org/favicon.ico --output' in '--ssl-no-revoke --silent'
-- Encode
rr=Encode64(Charin(in,1,30000))
call Charout out,rr,1
-- Show head and tail
say 'Begin/end' in 'encoded'
do i=1 by 80 to 240
   say Substr(rr,i,80)
end
say '...'
lc=Length(rr)
do i=lc-239 by 80 to lc
   say Substr(rr,i,80)
end
return

Encode64:
procedure
parse arg xx
-- Alphabet
a='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
lx=Length(xx)
-- Convert character to bits and append some zeroes
xx=X2b(C2x(xx))00000; lb=Length(xx)-5; rr=''
-- Loop per 6 thru bits
do i=1 by 6 to lb
   b=Substr(xx,i,6)
-- Convert to decimal
   d=X2d(B2x(b))+1
-- Get encoded character
   e=Substr(a,d,1)
-- Append
   rr||=e
end
-- Append padding characters
return rr||Copies('=',2*(lx//3=1)+(lx//3=2))

include Abend
