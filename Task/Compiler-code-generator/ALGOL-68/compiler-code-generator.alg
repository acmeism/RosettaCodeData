# RC Compiler code generator #
COMMENT
    this writes a .NET IL assembler source to standard output.
    If the output is stored in a file called "rcsample.il",
    it could be compiled the command:
        ilasm /opt /out:rcsample.exe rcsample.il
    (Note ilasm may not be in the PATH by default(

    Note: The generated IL is *very* naiive
COMMENT

# parse tree nodes #
MODE NODE = STRUCT( INT type, REF NODE left, right, INT value );
INT nidentifier =  1, nstring       =  2, ninteger  =  3, nsequence  =  4, nif =  5, nprtc =  6, nprts  =  7
  , nprti       =  8, nwhile        =  9, nassign   = 10, nnot       = 12
  , nlessequal  = 19, ngreaterequal = 21, nnotequal = 23
    # unused nnegate = 11, , nmultiply = 13, ndivide = 14, nmod = 15, nadd = 16, nsubtract = 17 #
    # unused nless   = 18, , ngreater  = 20, nequal  = 22, nand = 24, nor  = 25 #
  ;
# op codes #
INT ofetch   =  1, ostore =  2, opush =  3, oadd =  4,  osub =  5, omul  =  6, odiv  =  7, omod =  8
  , olt      =  9, ogt    = 10, oeq   = 13, oand  = 15, oor  = 16, oneg  = 17, ojmp  = 19, ojz  = 20
  , opushstr = 24
    # unused: oge = 12, one = 14, onot = 18, oprtc = 21, oprts = 22, oprti = 23, #
  ;
[]INT    ndop
= ( -1   , -1             , -1            , -1             , -1             , -1            , -1
  , -1   , -1             , -1            , oneg           , -1             , omul          , odiv
  , omod , oadd           , osub          , olt            , -1             , ogt
  , -1   , oeq            , -1            , oand           , oor
  ) ;
[]STRING ndname
= ( "Identifier"  , "String", "Integer"     , "Sequence", "If"       , "Prtc"    , "Prts"
  , "Prti"        , "While" , "Assign"      , "Negate"  , "Not"      , "Multiply", "Divide"
  , "Mod"         , "Add"   , "Subtract"    , "Less"    , "LessEqual", "Greater"
  , "GreaterEqual", "Equal" , "NotEqual"    , "And"     , "Or"
  ) ;
[]STRING opname
= ( "ldloc  ",  "stloc  ",   "ldc.i4 ",  "add    ",  "sub    ", "mul    ",  "div    ",  "rem    "
  , "clt    ",  "cgt    ",   "?le    ",  "?ge    ",  "ceq    ", "?ne    ",  "and    ",  "or     "
  , "neg    ",  "?not   ",   "br     ",  "brfalse",  "?prtc  ", "?prts  ",  "?prti  ",  "ldstr  "
  ) ;
# string and identifier arrays - a hash table might be better... #
INT max string number = 1024;
[ 0 : max string number ]STRING identifiers, strings;
FOR s pos FROM 0 TO max string number DO
    identifiers[ s pos ] := "";
    strings    [ s pos ] := ""
OD;
# label number for label generation #
INT next label number := 0;
# returns the next free label number #
PROC new label = INT: next label number +:= 1;

# returns a new node with left and right branches #
PROC op node      = ( INT op type, REF NODE left, right )REF NODE:
     HEAP NODE := NODE( op type, left, right, 0 );
# returns a new operand node #
PROC operand node = ( INT op type, value )REF NODE: HEAP NODE := NODE( op type, NIL, NIL, value );

# reports an error and stops #
PROC gen error = ( STRING message )VOID:
     BEGIN
        print( ( message, newline ) );
        stop
     END # gen error # ;

# reads a node from standard input #
PROC read node = REF NODE:
     BEGIN
        REF NODE result := NIL;

        # parses a string from line and stores it in a string in the text array #
        # - if it is not already present in the specified textElement list.     #
        # returns the position of the string in the text array                  #
        PROC read text = ( REF[]STRING text list, CHAR terminator )INT:
             BEGIN
                # get the text of the string #
                STRING str := line[ l pos ];
                l pos +:= 1;
                WHILE IF l pos <= UPB line THEN line[ l pos ] /= terminator ELSE FALSE FI DO
                    str   +:= line[ l pos ];
                    l pos +:= 1
                OD;
                IF l pos > UPB line THEN gen error( "Unterminated String in node file: (" + line + ")." ) FI;
                # attempt to find the text in the list of strings/identifiers #
                BOOL found    := FALSE;
                INT  text loc := LWB text list - 1;
                FOR t pos FROM LWB text list TO UPB text list WHILE NOT found DO
                    IF found := text list[ t pos ] = str THEN
                        # found the string #
                        text loc := t pos
                    ELIF text list[ t pos ] = "" THEN
                        # have an empty slot for ther string #
                        found := TRUE;
                        text list[ t pos ] := str;
                        text loc := t pos
                    FI
                OD;
                IF NOT found THEN gen error( "Out of string space." ) FI;
                text loc
             END # read text # ;
        # gets an integer from the line - no checks for valid digits #
        PROC read integer = INT:
             BEGIN
                 INT n := 0;
                 WHILE line[ l pos ] /= " " DO
                     ( n *:= 10 ) +:= ( ABS line[ l pos ] - ABS "0" );
                     l pos +:= 1
                 OD;
                 n
             END # read integer # ;

        STRING line, name;
        INT    l pos := 1, nd type := -1;
        read( ( line, newline ) );
        line +:= " ";
        # get the node type name #
        WHILE line[ l pos ] = " " DO l pos +:= 1 OD;
        name := "";
        WHILE IF l pos > UPB line THEN FALSE ELSE line[ l pos ] /= " " FI DO
            name +:= line[ l pos ];
            l pos +:= 1
        OD;
        # determine the node type #
        nd type := LWB nd name;
        IF name /= ";" THEN
            # not a null node #
            WHILE IF   nd type <= UPB nd name
                  THEN name /= nd name[ nd type ]
                  ELSE FALSE
                  FI
            DO nd type +:= 1 OD;
            IF nd type > UPB nd name THEN gen error( "Malformed node: (" + line + ")." ) FI;
            # handle the additional parameter for identifier/string/integer, or sub-nodes #
            # for operator nodes #
            IF nd type = ninteger OR nd type = nidentifier OR nd type = nstring THEN
                WHILE line[ l pos ] = " " DO l pos +:= 1 OD;
                IF     nd type = ninteger
                THEN   result := operand node( nd type, read integer )
                ELIF   nd type = nidentifier
                THEN   result := operand node( nd type, read text( identifiers, " "  ) )
                ELSE # nd type = nString     #
                       result := operand node( nd type, read text( strings,     """" ) )
                FI
            ELSE
                # operator node #
                REF NODE left node = read node;
                result := op node( nd type, left node, read node )
            FI
        FI;
        result
     END # read node # ;

# returns a formatted op code for code generation #
PROC operation = ( INT op code )STRING: "            " + op name[ op code ] + "  ";
# defines the specified label #
PROC define label = ( INT label number )VOID: print( ( "lbl_", whole( label number, 0 ), ":", newline ) );
# generates code to load a string value #
PROC gen load string   = ( INT value )VOID:
     BEGIN
        print( ( operation( opushstr ), "  ", strings[ value ], """", newline ) )
     END # push string # ;
# generates code to load a constant value #
PROC gen load constant = ( INT value )VOID:
     print( ( operation( opush ), "  ", whole( value, 0 ), newline ) );
# generates an operation acting on an address #
PROC gen data op = ( INT op, address )VOID:
     print( ( operation( op ), "  l_", identifiers[ address ], newline ) );
# generates a nullary operation #
PROC gen op 0    = ( INT op )VOID:          print( ( operation( op ), newline ) );
# generates a "not" instruction sequence #
PROC gen not = VOID:
     BEGIN
        gen load constant( 0 );
        print( ( operation( oeq ), newline ) )
     END # gen not # ;
# generates a negated condition #
PROC gen not op = ( INT op, REF NODE n )VOID:
     BEGIN
        gen(  left OF n );
        gen( right OF n );
        gen op 0( op );
        gen not
     END # gen not op # ;
# generates a jump operation #
PROC gen jump = ( INT op, label )VOID: print( ( operation( op ), "  lbl_", whole( label, 0 ), newline ) );
# generates code to output something to System.Console.Out #
PROC gen output = ( REF NODE n, STRING output type )VOID:
     BEGIN
        print( ( "            call       " ) );
        print( ( "class [mscorlib]System.IO.TextWriter [mscorlib]System.Console::get_Out()", newline ) );
        gen( left OF n );
        print( ( "            callvirt   " ) );
        print( ( "instance void [mscorlib]System.IO.TextWriter::Write(", output type, ")", newline ) )
     END # gen output # ;

# generates the code header - assembly info, namespace, class and start of the Main method #
PROC code header = VOID:
     BEGIN
        print( ( ".assembly extern mscorlib { auto }",                                  newline ) );
        print( ( ".assembly RccSample {}",                                              newline ) );
        print( ( ".module RccSample.exe",                                               newline ) );
        print( ( ".namespace Rcc.Sample",                                               newline ) );
        print( ( "{",                                                                   newline ) );
        print( ( "    .class public auto ansi Program extends [mscorlib]System.Object", newline ) );
        print( ( "    {",                                                               newline ) );
        print( ( "        .method public static void Main() cil managed",               newline ) );
        print( ( "        {",                                                           newline ) );
        print( ( "           .entrypoint",                                              newline ) );
        # output the local variables #
        BOOL   have locals  := FALSE;
        STRING local prefix := "           .locals init (int32 l_";
        FOR s pos FROM LWB identifiers TO UPB identifiers WHILE identifiers[ s pos ] /= "" DO
            print( ( local prefix, identifiers[ s pos ], newline ) );
            local prefix := "                        ,int32 l_";
            have locals  := TRUE
        OD;
        IF have locals THEN
            # there were some local variables defined - output the terminator #
            print( ( "                        )", newline ) )
        FI
     END # code header # ;

# generates code for the node n #
PROC gen = ( REF NODE n )VOID:
     IF n IS REF NODE( NIL )        THEN # null node       #
        SKIP
     ELIF type OF n = nidentifier   THEN # load identifier #
        gen data op( ofetch, value OF n )
     ELIF type OF n = nstring       THEN # load string     #
        gen load string( value OF n )
     ELIF type OF n = ninteger      THEN # load integer    #
        gen load constant( value OF n )
     ELIF type OF n = nsequence     THEN # list            #
        gen(  left OF n );
        gen( right OF n )
     ELIF type OF n = nif           THEN # if-else         #
        INT else label := new label;
        gen( left OF n );
        gen jump( ojz, else label );
        gen( left OF right OF n );
        IF right OF right OF n IS REF NODE( NIL ) THEN
            # no "else" part #
            define label( else label )
        ELSE
            # have an "else" part #
            INT end if label := new label;
            gen jump( ojmp, end if label );
            define label( else label );
            gen( right OF right OF n );
            define label( end if label )
        FI
     ELIF type OF n = nwhile        THEN # while-loop      #
        INT loop label := new label;
        INT exit label := new label;
        define label( loop label );
        gen(  left OF n );
        gen jump( ojz,  exit label );
        gen( right OF n );
        gen jump( ojmp, loop label );
        define label( exit label )
     ELIF type OF n = nassign       THEN # assignment      #
        gen( right OF n );
        gen data op( ostore, value OF left OF n )
     ELIF type OF n = nnot          THEN # bolean not      #
        gen( left OF n );
        gen not
     ELIF type OF n = ngreaterequal THEN # compare >=      #
        gen not op( olt, n )
     ELIF type OF n = nnotequal     THEN # compare not =   #
        gen not op( oeq, n )
     ELIF type OF n = nlessequal    THEN # compare <=      #
        gen not op( ogt, n )
     ELIF type OF n = nprts         THEN # print string    #
        gen output( n, "string" )
     ELIF type OF n = nprtc         THEN # print character #
        gen output( n, "char" )
     ELIF type OF n = nprti         THEN # print integer   #
        gen output( n, "int32" )
     ELSE                                # everything else #
        gen(  left OF n );
        gen( right OF n ); # right will be null for a unary op so no code will be generated #
        print( ( operation( ndop( type OF n ) ), newline ) )
     FI # gen # ;

# generates the code trailer - return instruction, end of Main method, end of class and end of namespace #
PROC code trailer = VOID:
     BEGIN
        print( ( "            ret",           newline ) );
        print( ( "        } // Main method",  newline ) );
        print( ( "    } // Program class",    newline ) );
        print( ( "} // Rcc.Sample namespace", newline ) )
     END # code trailer # ;

# parse the output from the syntax analyser and generate code from the parse tree #
REF NODE code = read node;
code header;
gen( code );
code trailer
