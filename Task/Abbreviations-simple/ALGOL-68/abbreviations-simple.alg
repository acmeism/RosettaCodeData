# "Simple" abbreviations                                               #

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
# returns text converted to an INT or -1 if text is not a number         #
OP   TOINT    = ( STRING text )INT:
     BEGIN
        INT  result     := 0;
        BOOL is numeric := TRUE;
        FOR ch pos FROM UPB text BY -1 TO LWB text WHILE is numeric DO
            CHAR c = text[ ch pos ];
            is numeric := ( c >= "0" AND c <= "9" );
            IF is numeric THEN ( result *:= 10 ) +:= ABS c - ABS "0" FI
        OD;
        IF is numeric THEN result ELSE -1 FI
     END # TOINT # ;
# returns the length of word                                             #
OP LENGTH = ( STRING word )INT: 1 + ( UPB word - LWB word );
# counts the number of commands in commands                              #
PROC count commands = ( STRING commands )INT:
     BEGIN
        INT    result         := 0;
        INT    pos            := LWB commands;
        WHILE  STRING command := pos NEXTWORD commands; command /= "" DO
            IF TOINT command < 0 THEN
                # not an abbreviation length                             #
                result +:= 1
            FI
        OD;
        result
     END # count commands # ;

# list of "commands" -  the words are optionally followed by the minimum #
#                       length of abbreviation - if there isn't a number #
#                       the command can only appear in full              #
STRING commands
   = "add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3 "
   + "compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate "
   + "3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2 "
   + "forward 2  get  help 1 hexType 4  input 1 powerInput 3  join 1 split 2 spltJOIN load "
   + "locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2 "
   + "msg  next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit  read recover 3 "
   + "refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left "
   + "2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1 "
   ;
# build the tables of the commands and their minimum lengths             #
PROC load commands = ( STRING commands )VOID:
     BEGIN
        INT    cmd pos        := 0;
        INT    pos            := LWB command table;
        WHILE  STRING command := pos NEXTWORD commands; command /= "" DO
            INT len := TOINT command;
            IF len >= 0 THEN
                # have an abbreviation length                            #
                IF cmd pos > 0 THEN min abbreviation[ cmd pos ] := len FI
            ELSE
                # new command                                            #
                cmd pos +:= 1;
                command table[    cmd pos ] := TOUPPER command;
                min abbreviation[ cmd pos ] := LENGTH  command
            FI
        OD
     END # load commands # ;
# searches for word in command table and returns the full command      #
# matching the possible abbreviation or *error* if there is no match   #
OP   EXPAND  = ( STRING word )STRING:
     IF word = ""
     THEN # empty word #
        ""
     ELSE # non-empty word #
        INT    word len    = LENGTH word;
        STRING upper word := TOUPPER word;
        STRING result     := "*error*";
        FOR cmd pos FROM LWB command table TO UPB command table
        WHILE  STRING command := command table[ cmd pos ];
               IF word len < min abbreviation[ cmd pos ] OR word len > LENGTH command
               THEN # word is too short or too long - try the next command #
                   TRUE
               ELIF upper word = command[ LWB command : ( LWB command - 1 ) + word len ]
               THEN # found the command #
                   result := command;
                   FALSE
               ELSE # word doexn't match - try the next command #
                   TRUE
               FI
        DO SKIP OD;
        result
     FI # EXPAND # ;

# tests the EXPAND operator                                            #
PROC test expand = ( STRING words )VOID:
     BEGIN
        STRING results := "", separator := "";
        INT    pos   := LWB words;
        WHILE STRING word = pos NEXTWORD words; word /= "" DO
            results +:= separator + EXPAND word;
            separator := " "
        OD;
        print( ( "Input:  ", words, newline ) );
        print( ( "Output: ", results, newline ) )
     END # test expand # ;

# build the command table                                              #
[ 1 : count commands( commands ) ]STRING command table;
[ 1 : UPB command table          ]INT    min abbreviation;
load commands( commands );

# task test cases                                                      #
test expand( "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin" )
