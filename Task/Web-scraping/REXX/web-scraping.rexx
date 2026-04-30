-- 23 Oct 2025
include Setting
signal off notready

say 'WEB SCRAPING'
say version
say
call Task
exit

Task:
procedure
-- Get page from web (curl is pre-installed on Windows 10/11, Unix and MacOS)
out='Web.html'
'curl https://rosettacode.org/wiki/Talk:Web_scraping --ssl-no-revoke --silent --output' out
-- Read file
file=Charin(out,1,100000)
-- Extract all time stamps
p=Pos('(UTC)',file)
do while p>0
   p2=p-2
   do p1=p2 by -1 until Substr(file,p1,1)=':'
   end
   p1-=2
   say Substr(file,p1,p2-p1+1)
   p=Pos('(UTC)',file,p+1)
end
return

include Abend
