# "Easy" abbreviations                                                 #

# returns the next word from text, updating pos                        #
PRIO NEXTWORD = 1;
OP   NEXTWORD = ( REF INT pos, STRING text )STRING:
     BEGIN
        # skip spaces #
        WHILE IF pos > UPB text THEN FALSE ELSE text[ pos ] = " " FI DO pos +:= 1 OD;
        # get the word #
        STRING word := "";
        WHILE IF pos > UPB text THEN FALSE ELSE text[ pos ] /= " " FI DO
            word +:= text[ pos ];
            pos +:= 1
        OD;
        word
     END # NEXTWORD # ;
# returns text converted to upper case                                 #
OP   TOUPPER  = ( STRING text )STRING:
     BEGIN
        STRING result := text;
        FOR ch pos FROM LWB result TO UPB result DO
            IF is lower( result[ ch pos ] ) THEN result[ ch pos ] := to upper( result[ ch pos ] ) FI
        OD;
        result
     END # TOUPPER # ;
# returns the minimum abbreviation length of command                   #
OP   MINABLENGTH = ( STRING command )INT:
     BEGIN
        INT ab min := LWB command;
        WHILE IF ab min > UPB command THEN FALSE ELSE is upper( command[ ab min ] ) FI DO ab min +:= 1 OD;
        ab min - LWB command
     END # MINABLENGTH # ;
# searches for word in command table and returns the full command      #
# matching the possible abbreviation or *error* if there is no match   #
PRIO EXPAND  = 1;
OP   EXPAND  = ( STRING command table, word )STRING:
     IF word = ""
     THEN # empty word #
        ""
     ELSE # non-empty word #
        INT    word len    = ( UPB word + 1 ) - LWB word;
        STRING upper word := TOUPPER word;
        STRING result     := "*error*";
        INT    pos        := LWB command table;
        WHILE  STRING command := pos NEXTWORD command table;
               IF command = ""
               THEN # end of command table #
                   FALSE
               ELIF word len < MINABLENGTH command OR word len > ( ( UPB command + 1 ) - LWB command )
               THEN # word is too short or too long - try the next command #
                   TRUE
               ELIF upper word = TOUPPER command[ LWB command : ( LWB command - 1 ) + word len ]
               THEN # found the command #
                   result := TOUPPER command;
                   FALSE
               ELSE # word doexn't match - try the next command #
                   TRUE
               FI
        DO SKIP OD;
        result
     FI # EXPAND # ;
# tests the EXPAND operator                                            #
PROC test expand = ( STRING words, command table )VOID:
     BEGIN
        STRING results := "", separator := "";
        INT    pos   := LWB words;
        WHILE STRING word = pos NEXTWORD words; word /= "" DO
            results +:= separator + ( command table EXPAND word );
            separator := " "
        OD;
        print( ( "Input:  ", words, newline ) );
        print( ( "Output: ", results, newline ) )
     END # test expand # ;

BEGIN # task test cases                                                #
    # table of "commands"                                              #
    #     - upper-case indicates the mminimum abbreviation             #
    STRING command table
         = "Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy "
         + "COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find "
         + "NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput "
         + "Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO "
         + "MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT "
         + "READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT "
         + "RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up"
         ;
    test expand( "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin", command table );
    test expand( "",                                                                      command table )
END
