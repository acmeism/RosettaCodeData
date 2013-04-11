$$ MODE TUSCRIPT
dest="fracaltree.svg"
ERROR/STOP CREATE (dest,fdf-o,-std-)
ACCESS d: WRITE/ERASE/RECORDS/UTF8 $dest s,text
MODE DATA
$$ header=*
<?xml version="1.0" standalone="yes"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 20010904//EN"
 "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd">
<svg xmlns="http://www.w3.org/2000/svg"
 xmlns:xlink="http://www.w3.org/1999/xlink"
 width="400" height="320">
  <style type="text/css"><![CDATA[
  line { stroke: brown; stroke-width: .05; }
  ]]></style>
$$ WRITE/NEXT d header
$$ defsbeg=*
<defs>
  <g id="stem"> <line x1="0" y1="0" x2="0" y2="-1"/> </g>
  <g id="l"><use xlink:href="#stem"/></g>
$$ WRITE/NEXT d defsbeg
$$ LOOP n=10,21
$$ id=n+1,lastnr=VALUE(n)
$$ g=*
  <g id="{id}"> <use xlink:href="#{n}" transform="translate(0, -1) rotate(-35) scale(.7)"/>
  <use xlink:href="#{n}" transform="translate(0, -1) rotate(+35) scale(.7)"/> <use xlink:href="#stem"/></g>
$$ WRITE/NEXT d g
$$ ENDLOOP
$$ defsend = *
</defs>
<g transform="translate(200, 320) scale(100)">
  <use xlink:href="#{lastnr}"/>
</g>
$$ MODE TUSCRIPT
WRITE/NEXT d defsend
WRITE/NEXT d "</svg>"
ENDACCESS d
