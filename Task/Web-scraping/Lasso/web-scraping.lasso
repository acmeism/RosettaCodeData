/* have to be used
local(raw_htmlstring = '<TITLE>What time is it?</TITLE>
<H2> US Naval Observatory Master Clock Time</H2> <H3><PRE>
<BR>Jul. 27, 22:57:22 UTC   Universal Time
<BR>Jul. 27, 06:57:22 PM EDT  Eastern Time
<BR>Jul. 27, 05:57:22 PM CDT  Central Time
<BR>Jul. 27, 04:57:22 PM MDT  Mountain Time
<BR>Jul. 27, 03:57:22 PM PDT  Pacific Time
<BR>Jul. 27, 02:57:22 PM AKDT Alaska Time
<BR>Jul. 27, 12:57:22 PM HAST Hawaii-Aleutian Time
</PRE></H3>
')
*/

// should be used
local(raw_htmlstring = string(include_url('http://tycho.usno.navy.mil/cgi-bin/timer.pl')))

local(
  reg_exp = regexp(-find = `<br>(.*?) UTC`, -input = #raw_htmlstring, -ignorecase),
  datepart_txt =  #reg_exp -> find ? #reg_exp -> matchstring(1) | string
)

#datepart_txt
'<br />'
// added bonus showing how parsed string can be converted to date object
local(mydate = date(#datepart_txt, -format = `MMM'.' dd',' HH:mm:ss`))
#mydate -> format(`YYYY-MM-dd HH:mm:ss`)
