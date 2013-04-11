USING: sequences xml.syntax xml.writer ;

: print-character-remarks ( names remarks -- )
    [ [XML <Character name=<-> ><-></Character> XML] ] 2map
    [XML <CharacterRemarks><-></CharacterRemarks> XML] pprint-xml ;
