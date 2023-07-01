# returns a translation of str suitable for attribute values and content in an XML document #
OP  TOXMLSTRING = ( STRING str )STRING:
    BEGIN
        STRING result := "";
        FOR pos FROM LWB str TO UPB str DO
            CHAR c = str[ pos ];
            result +:= IF   c = "<"   THEN "&lt;"
                       ELIF c = ">"   THEN "&gt;"
                       ELIF c = "&"   THEN "&amp;"
                       ELIF c = "'"   THEN "&apos;"
                       ELIF c = """"  THEN "&quot;"
                       ELSE c
                       FI
        OD;
        result
    END; # TOXMLSTRING #

# generate a CharacterRemarks XML document from the characters and remarks #
# the number of elements in characters and remrks must be equal - this is not checked #
# the <?xml?> element is not generated #
PROC generate character remarks document = ( []STRING characters, remarks )STRING:
     BEGIN
         STRING result     := "<CharacterRemarks>";
         INT    remark pos := LWB remarks;
         FOR char pos FROM LWB characters TO UPB characters DO
             result +:= "<Character name=""" + TOXMLSTRING characters[ char pos ] + """>"
                      + TOXMLSTRING remarks[ remark pos ]
                      + "</Character>"
                      + REPR 10
                      ;
             remark pos +:= 1
         OD;
         result +:= "</CharacterRemarks>";
         result
     END; # generate character remarks document #

# test the generation #
print( ( generate character remarks document( ( "April", "Tam O'Shanter", "Emily" )
                                            , ( "Bubbly: I'm > Tam and <= Emily"
                                              , "Burns: ""When chapman billies leave the street ..."
                                              , "Short & shrift"
                                              )
                                            )
        , newline
        )
      )
