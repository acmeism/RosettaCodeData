set theXMLdata to "<inventory title=\"OmniCorp Store #45x10^3\">
  <section name=\"health\">
    <item upc=\"123456789\" stock=\"12\">
      <name>Invisibility Cream</name>
      <price>14.50</price>
      <description>Makes you invisible</description>
    </item>
    <item upc=\"445322344\" stock=\"18\">
      <name>Levitation Salve</name>
      <price>23.99</price>
      <description>Levitate yourself for up to 3 hours per application</description>
    </item>
  </section>
  <section name=\"food\">
    <item upc=\"485672034\" stock=\"653\">
      <name>Blork and Freen Instameal</name>
      <price>4.95</price>
      <description>A tasty meal in a tablet; just add water</description>
    </item>
    <item upc=\"132957764\" stock=\"44\">
      <name>Grob winglets</name>
      <price>3.56</price>
      <description>Tender winglets of Grob. Just add water</description>
    </item>
  </section>
</inventory>"

on getElementValuesByName(theXML, theNameToFind)
	set R to {}
	tell application "System Events"
		repeat with i in theXML
			set {theName, theElements} to {i's name, i's XML elements}
			if (count of theElements) > 0 then set R to R & my getElementValuesByName(theElements, theNameToFind)
			if theName = theNameToFind then set R to R & i's value
		end repeat
	end tell
	return R
end getElementValuesByName

on getBlock(theXML, theItem, theInstance)
	set text item delimiters to ""
	repeat with i from 1 to theInstance
		set {R, blockStart, blockEnd} to {{}, "<" & theItem & space, "</" & theItem & ">"}
		set x to offset of blockStart in theXML
		if x = 0 then exit repeat
		set y to offset of blockEnd in (characters x thru -1 of theXML as string)
		if y = 0 then exit repeat
		set R to characters x thru (x + y + (length of blockEnd) - 2) of theXML as string
		set theXML to characters (y + (length of blockEnd)) thru -1 of theXML as string
	end repeat
	return R
end getBlock

tell application "System Events"
	set xmlData to make new XML data with properties {name:"xmldata", text:theXMLdata}
	
	return my getBlock(xmlData's text, "item", 1) -- Solution to part 1 of problem.
	return my getElementValuesByName(xmlData's contents, "name") -- Solution to part 2 of problem.
	return my getElementValuesByName(xmlData's contents, "price") -- Solution to part 3 of problem.
	
end tell
