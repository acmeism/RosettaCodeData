###
  REQUIRES(MODE SCALAR, OP(SCALAR,SCALAR)BOOL =, OP(SCALAR,SCALAR)SCALAR +);
###
MODE SCALARLIST = FLEX[0]SCALAR;
MODE YIELDINT = PROC(SCALAR)VOID;

################################################################
# Declarations for manipulating lists of range pairs [lwb:upb] #
################################################################
MODE RANGE = STRUCT(SCALAR lwb, upb);
MODE RANGELIST = FLEX[0]RANGE;
MODE YIELDRANGE = PROC(RANGE)VOID;

PROC range repr = (RANGE range)STRING: (
  STRING lwb := whole(lwb OF range,0);
  IF lwb OF range = upb OF range THEN
    lwb
  ELSE
    # "["+lwb+":"+whole(upb OF range,0)+"]"  #
    lwb+"-"+whole(upb OF range,0)
  FI
);

# OP REPR = (RANGE range)STRING: range repr(range); # # firmly related to UNIRANGE #

######################################################################
# Declarations for manipulating lists containing pairs AND lone INTs #
######################################################################
MODE UNIRANGE = UNION(SCALAR, RANGE);
MODE UNIRANGELIST = FLEX[0]UNIRANGE;
MODE YIELDUNIRANGE = PROC(UNIRANGE)VOID;

PROC unirange repr = (UNIRANGE unirange)STRING:
  CASE unirange IN
    (RANGE range): range repr(range),
    (SCALAR scalar): whole(scalar,0)
  ESAC;

OP (UNIRANGE)STRING REPR = unirange repr; # alias #

# The closest thing Algol68 has to inheritance is the UNION #
MODE UNIRANGELISTS = UNION(UNIRANGELIST, RANGELIST, SCALARLIST);

PROC unirange list repr = (UNIRANGELIST unirange list)STRING: (
### Produce a STRING representation of a UNIRANGELIST ###
  STRING out # := "("#, sep := "";
  FOR key FROM LWB unirange list TO UPB unirange list DO
    out +:= sep + REPR unirange list[key];
    sep := "," # +" " #
  OD;
  out # +")" #
);

OP (UNIRANGELIST)STRING REPR = unirange list repr; # alias #
