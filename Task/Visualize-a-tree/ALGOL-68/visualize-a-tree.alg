# outputs nested html tables to visualise a tree #

# mode representing nodes of the tree #
MODE NODE = STRUCT( STRING value, REF NODE child, REF NODE sibling );
REF  NODE nil node = NIL;

# tags etc. #
STRING table = "<table border=""1"" cellspacing=""4"">"
     , elbat = "</table>"
     , tr    = "<tr>"
     , rt    = "</tr>"
     , td    = "<td style=""text-align: center; vertical-align: top; """
     , dt    = "</td>"
     , nbsp  = "&nbsp;"
     ;
CHAR   nl    = REPR 10;

# returns the number of child elements of tree #
OP CHILDCOUNT = ( REF NODE tree )INT:
    BEGIN
        INT      result := 0;
        REF NODE child  := child OF tree;
        WHILE REF NODE( child ) ISNT nil node
        DO
            result +:= 1;
            child   := sibling OF child
        OD;
        result
    END # CHILDCOUNT # ;

# generates nested HTML tables from the tree #
OP  TOHTML = ( REF NODE tree )STRING:
    IF tree IS nil node
    THEN
        # no node #
        ""
    ELSE
        # hae at least one node #
        STRING result     := "";
        INT    child count = CHILDCOUNT tree;
        result +:= table + nl
                 +   tr  + nl
                 +     td + " colspan="""
                          + whole( IF child count < 1 THEN 1 ELSE child count FI, 0 )
                          + """>" + nbsp + value OF tree + nbsp
                 +     dt + nl
                 +   rt  + nl
                 ;
        IF child count > 0
        THEN
            # the node has branches #
            REF NODE  child  := child OF tree;
            child   := child OF tree;
            result +:= tr + nl;
            WHILE child ISNT nil node
            DO
                result +:= td + ">" + nl
                         + IF CHILDCOUNT child < 1 THEN nbsp + value OF child + nbsp ELSE TOHTML child FI
                         + dt + nl;
                child := sibling OF child
            OD;
            result +:= rt + nl
        FI;
        result +:= elbat + nl
    FI # TOHTML # ;

# test the tree visualisation #

# returns a new node with the specified value and no child or siblings #
PROC new node = ( STRING value )REF NODE: HEAP NODE := NODE( value, nil node, nil node );
# appends a sibling node to the node n, returns the sibling #
OP +:= = ( REF NODE n, REF NODE sibling node )REF NODE:
    BEGIN
        REF NODE sibling := n;
        WHILE REF NODE( sibling OF sibling ) ISNT nil node
        DO
            sibling := sibling OF sibling
        OD;
        sibling OF sibling := sibling node # will get a potential scope violation warning #
    END # +:= # ;
# appends a new sibling node to the node n, returns the sibling #
OP +:= = ( REF NODE n, STRING   sibling value )REF NODE: n +:= new node( sibling value );
# adds a child node to the node n, returns the child #
OP /:= = ( REF NODE n, REF NODE child node    )REF NODE: child OF n := child node;
# adda a new child node to the node n, returns the child #
OP /:= = ( REF NODE n, STRING   child value   )REF NODE: n /:= new node( child value );

NODE animals  := new node( "animals"  );
NODE fish     := new node( "fish"     );
NODE reptiles := new node( "reptiles" );
NODE mammals  := new node( "mammals"  );
NODE primates := new node( "primates" );
NODE sharks   := new node( "sharks"   );
sharks   /:= "great-white" +:= "hammer-head";
fish     /:= "cod"         +:= sharks           +:= "piranha";
reptiles /:= "iguana"      +:= "brontosaurus";
primates /:= "gorilla"     +:= "lemur";
mammals  /:= "sloth"       +:= "horse"          +:= "bison" +:= primates;
animals  /:= fish          +:= reptiles         +:= mammals;

print( ( TOHTML animals ) )
