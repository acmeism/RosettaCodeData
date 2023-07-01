/* load the RexxcURL library */
Call RxFuncAdd 'CurlLoadFuncs', 'rexxcurl', 'CurlLoadFuncs'
Call CurlLoadFuncs

url = "http://tycho.usno.navy.mil/cgi-bin/timer.pl"

/* get a curl session */
curl = CurlInit()
if curl \= ''
then do
   call CurlSetopt curl, 'URL', Url
   if curlerror.intcode \= 0 then exit
   call curlSetopt curl, 'OUTSTEM', 'stem.'
   if curlerror.intcode \= 0 then exit
   call CurlPerform curl

   /* content is in a stem - lets get it all in a string */
   content = stem.~allItems~makestring('l')
   /* now parse out utc time */
   parse var content content 'Universal Time' .
   utcTime = content~substr(content~lastpos('<BR>') + 4)
   say utcTime
end
