$$ MODE TUSCRIPT,{}
MODE DATA
$$ XML=*
<inventory title="OmniCorp Store #45x10³">
  <section name="health">
    <item upc="123456789" stock="12">
      <name>Invisibility Cream</name>
      <price>14.50</price>
      <description>Makes you invisible</description>
    </item>
    <item upc="445322344" stock="18">
      <name>Levitation Salve</name>
      <price>23.99</price>
      <description>Levitate yourself for up to 3 hours per application</description>
    </item>
  </section>
  <section name="food">
    <item upc="485672034" stock="653">
      <name>Blork and Freen Instameal</name>
      <price>4.95</price>
      <description>A tasty meal in a tablet; just add water</description>
    </item>
    <item upc="132957764" stock="44">
      <name>Grob winglets</name>
      <price>3.56</price>
      <description>Tender winglets of Grob. Just add water</description>
    </item>
  </section>
</inventory>
$$ MODE TUSCRIPT

FILE = "test.xml"
ERROR/STOP CREATE (file,fdf-o,-std-)
FILE/ERASE/UTF8 $FILE = xml

BUILD S_TABLE beg=":<item*>:<name>:<price>:"
BUILD S_TABLE end=":</item>:</name>:</price>:"
BUILD S_TABLE modifiedbeg=":<name>:<price>:"
BUILD S_TABLE modifiedend=":</name>:</price>:"
firstitem=names="",countitem=0
ACCESS q: READ/STREAM/UTF8 $FILE s,a/beg+t+e/end
LOOP
READ/EXIT q
IF (a=="<name>")  names=APPEND(names,t)
IF (a=="<price>") PRINT t
IF (a.sw."<item") countitem=1
IF (countitem==1) THEN
firstitem=CONCAT(firstitem,a)
firstitem=CONCAT(firstitem,t)
firstitem=CONCAT(firstitem,e)
 IF (e=="</item>") THEN
 COUNTITEM=0
 MODIFY ACCESS q s_TABLE modifiedbeg,-,modifiedend
 ENDIF
ENDIF
ENDLOOP
ENDACCESS q
ERROR/STOP CLOSE (file)
firstitem=EXCHANGE (firstitem,":{2-00} ::")
firstitem=INDENT_TAGS (firstitem,-," ")
names=SPLIT(names)
TRACE *firstitem,names
