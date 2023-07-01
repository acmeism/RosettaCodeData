$$ MODE TUSCRIPT
STRUCTURE xmloutput
DATA '<CharacterRemarks>'
DATA * '  <Character name="' names +'">' remarks +'</Character>'
DATA = '</CharacterRemarks>'
ENDSTRUCTURE
BUILD X_TABLE entitysubst=" >> &gt; << &lt; & &amp; "
ERROR/STOP CREATE ("dest",seq-o,-std-)
ACCESS d: WRITE/ERASE/STRUCTURE  "dest" num,str
str="xmloutput"
  names=*
  DATA April
  DATA Tam O'Shanter
  DATA Emily
  remarks=*
  DATA Bubbly: I'm > Tam and <= Emily
  DATA Burns: "When chapman billies leave the street ..."
  DATA Short & shrift
  remarks=EXCHANGE(remarks,entitysubst)
WRITE/NEXT d
ENDACCESS d
