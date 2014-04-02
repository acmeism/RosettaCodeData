MODE YIELDINT = PROC(INT)VOID;

MODE RANGE = STRUCT(INT lwb, upb);
MODE RANGEINT = UNION(RANGE, INT);

OP SIZEOF = ([]RANGEINT list)INT: (
# determine the length of the output array #
  INT upb := LWB list - 1;
  FOR key FROM LWB list TO UPB list DO
    CASE list[key] IN
      (RANGE value): upb +:= upb OF value - lwb OF value + 1,
      (INT): upb +:= 1
    ESAC
  OD;
  upb
);

PROC gen range expand = ([]RANGEINT list, YIELDINT yield)VOID:
  FOR key FROM LWB list TO UPB list DO
    CASE list[key] IN
      (RANGE range): FOR value FROM lwb OF range TO upb OF range DO yield(value) OD,
      (INT int): yield(int)
    ESAC
  OD;

PROC range expand = ([]RANGEINT list)[]INT: (
  [LWB list: LWB list + SIZEOF list - 1]INT out;
  INT upb := LWB out - 1;
# FOR INT value IN # gen range expand(list, # ) DO #
##   (INT value)VOID:
    out[upb +:= 1] := value
# OD #);
  out
);

#
test:(
  []RANGEINT list = (-6, RANGE(-3, -1), RANGE(3, 5),  RANGE(7, 11), 14, 15, RANGE(17, 20));
  print((range expand(list), new line))
)
#


# converts string containing a comma-separated list of ranges and values to a []RANGEINT #
OP TORANGE = ( STRING s )[]RANGEINT:
BEGIN

    # counts the number of elements - one more than the number of commas #
    # and so assumes there is always at least one element                #
    PROC count elements = INT:
    BEGIN

        INT    elements := 1;

        FOR pos FROM LWB s TO UPB s
        DO
            IF s[ pos ] = ","
            THEN
                elements +:= 1
            FI
        OD;

    # RESULT #
        elements
    END; # count elements #

    REF[]RANGEINT result = HEAP [ 1 : count elements ]RANGEINT;

    # does the actual parsing - assumes the string is syntatically valid and doesn't check for errors #
    # - in particular, a string with no elements will cause problems, as will space characters in the string #
    PROC parse range string = []RANGEINT:
    BEGIN

        INT  element := 0;
        INT  str pos := 1;

        PROC next       = VOID: str pos +:= 1;
        PROC curr char  = CHAR: IF str pos > UPB s THEN "?" ELSE s[ str pos ] FI;
        PROC have minus = BOOL: curr char = "-";
        PROC have digit = BOOL: curr char >= "0" AND curr char <= "9";


        # parses a number out of the string #
        # the number must be a sequence of digits with an optional leading minus sign #
        PROC get number = INT:
        BEGIN

            INT number := 0;

            INT sign multiplier = IF have minus
                                  THEN
                                      # negaive number #
                                      # skip the sign #
                                      next;
                                      -1
                                  ELSE
                                      # positive number #
                                      1
                                  FI;

            WHILE curr char >= "0" AND curr char <= "9"
            DO
                number *:= 10;
                number +:= ( ABS curr char - ABS "0" );
                next
            OD;

        # RESULT #
            number * sign multiplier
        END; # get number #


        # main parsing #
        WHILE str pos <= UPB s
        DO
            CHAR c = curr char;

            IF have minus OR have digit
            THEN
                # have the start of a number #
                INT from value = get number;
                element +:= 1;
                IF NOT have minus
                THEN
                    # not a range #
                    result[ element ] := from value
                ELSE
                    # have a range #
                    next;
                    INT to value = get number;
                    result[ element ] := RANGE( from value, to value )
                FI
            ELSE
                # should be a comma #
                next
            FI
        OD;

    # RESULT #
        result
    END; # parse range string #


# RESULT #
    parse range string
END; # TORANGE #


# converts a []INT to a comma separated string of the elements #
OP TOSTRING = ( []INT values )STRING:
BEGIN

    # converts an integer to a string #
    OP TOSTRING = ( INT value )STRING:
    BEGIN
        STRING result := "";
        INT    n      := ABS value;

        WHILE
            REPR ( ( n MOD 10 ) + ABS "0" ) PLUSTO result;
            n OVERAB 10;
            n > 0
        DO
            SKIP
        OD;

    # RESULT #
        IF value < 0 THEN "-" ELSE "" FI + result
    END; # TOSTRING #


    STRING result    := "";
    STRING separator := "";

    FOR pos FROM LWB values TO UPB values
    DO
        result +:= ( separator + TOSTRING values[ pos ] );
        separator := ","
    OD;

# RESULT #
    result
END; # TOSTRING #



test:(
    print( ( TOSTRING range expand( TORANGE "-6,-3--1,3-5,7-11,14,15,17-20" ), newline ) )
)
