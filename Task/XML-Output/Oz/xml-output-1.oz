declare
  proc {Main}
     Names = ["April"
	      "Tam O'Shanter"
	      "Emily"]

     Remarks = ["Bubbly: I'm > Tam and <= Emily"
		"Burns: \"When chapman billies leave the street ...\""
		"Short & shrift"]

     Characters = {List.zip Names Remarks
		   fun {$ N R}
		      'Character'(name:N R)
		   end}

     DOM = {List.toTuple 'CharacterRemarks' Characters}
  in
     {System.showInfo {Serialize DOM}}
  end

  fun {Serialize DOM}
     "<?xml version=\"1.0\" ?>\n"#
     {SerializeElement DOM 0}
  end

  fun {SerializeElement El Indent}
     Name = {Label El}
     Attributes ChildElements Contents
     {DestructureElement El ?Attributes ?ChildElements ?Contents}
     EscContents = {Map Contents Escape}
     Spaces = {List.make Indent} for S in Spaces do S = &  end
  in
     Spaces#"<"#Name#
     {VSConcatMap Attributes SerializeAttribute}#">"#
     {VSConcat EscContents}#{When ChildElements\=nil "\n"}#
     {VSConcatMap ChildElements fun {$ E} {SerializeElement E Indent+4} end}#
     {When ChildElements\=nil Spaces}#"</"#Name#">\n"
  end

  proc {DestructureElement El ?Attrs ?ChildElements ?Contents}
     SubelementRec AttributeRec
     {Record.partitionInd El fun {$ I _} {Int.is I} end
      ?SubelementRec ?AttributeRec}
     Subelements = {Record.toList SubelementRec}
  in
     {List.partition Subelements VirtualString.is ?Contents ?ChildElements}
     Attrs = {Record.toListInd AttributeRec}
  end

  fun {SerializeAttribute Name#Value}
     " "#Name#"=\""#{EscapeAttribute Value}#"\""
  end

  fun {Escape VS}
     {Flatten {Map {VirtualString.toString VS} EscapeChar}}
  end

  fun {EscapeAttribute VS}
     {Flatten {Map {VirtualString.toString VS} EscapeAttributeChar}}
  end

  fun {EscapeChar X}
     case X of 60 then "&lt;"
     [] 62 then "&gt;"
     [] 38 then "&amp;"
     else X
     end
  end

  fun {EscapeAttributeChar X}
     case X of 34 then "&quot;"
     else {EscapeChar X}
     end
  end

  %% concatenates a list to a virtual string
  fun {VSConcat Xs}
     {List.toTuple '#' Xs}
  end

  fun {VSConcatMap Xs F}
     {VSConcat {Map Xs F}}
  end

  fun {When Cond X}
     if Cond then X else nil end
  end
in
  {Main}
