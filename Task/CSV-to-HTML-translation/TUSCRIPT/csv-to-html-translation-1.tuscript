$$ MODE TUSCRIPT
MODE DATA
$$ csv=*
Character,Speech
The multitude,The messiah! Show us the messiah!
Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
The multitude,Who are you?
Brians mother,I'm his mother; that's who!
The multitude,Behold his mother! Behold his mother!
$$ htmlhead=*
<!DOCTYPE html system>
<html>
<head>
<title>Life of Brian</title>
<style type="text/css">
th {background-color:orange}
td {background-color:yellow}
</style></head><body><table>
$$ BUILD X_TABLE txt2html=*
 << &lt;
 >> &gt;
$$ MODE TUSCRIPT
file="brian.html"
ERROR/STOP CREATE (file,FDF-o,-std-)
csv=EXCHANGE (csv,txt2html)
x=SPLIT (csv,":,:",row1,row2)
ACCESS html: WRITE/ERASE/RECORDS/UTF8 $file s,html
WRITE html htmlhead
LOOP n,td1=row1,td2=row2
IF (n==1) THEN
row=CONCAT ("<tr><th>",td1,"</th><th>",td2,"</th></tr>")
ELSE
row=CONCAT ("<tr><td>",td1,"</td><td>",td2,"</td></tr>")
ENDIF
WRITE html row
ENDLOOP
WRITE html "</table></body></html>"
ENDACCESS/PRINT html
