MODE SMAOBJ  = STRUCT(
  LONG REAL sma,
  LONG REAL sum,
  INT period,
  REF[]LONG REAL values,
  INT lv
);

MODE SMARESULT = UNION (
  REF SMAOBJ # handle #,
  LONG REAL # sma #,
  REF[]LONG REAL # values #
);

MODE SMANEW = INT,
     SMAFREE = STRUCT(REF SMAOBJ free obj),
     SMAVALUES = STRUCT(REF SMAOBJ values obj),
     SMAADD = STRUCT(REF SMAOBJ add obj, LONG REAL v),
     SMAMEAN = STRUCT(REF SMAOBJ mean obj, REF[]LONG REAL v);

MODE ACTION = UNION ( SMANEW, SMAFREE, SMAVALUES, SMAADD, SMAMEAN );

PROC sma = ([]ACTION action)SMARESULT:
(
  SMARESULT result;
  REF SMAOBJ obj;
  LONG REAL v;

  FOR i FROM LWB action TO UPB action DO
    CASE action[i] IN
    (SMANEW period):( # args: INT period #
       HEAP SMAOBJ handle;
       sma OF handle := 0.0;
       period OF handle := period;
       values OF handle := HEAP [period OF handle]LONG REAL;
       lv OF handle := 0;
       sum OF handle := 0.0;
       result := handle
    ),
    (SMAFREE args):( # args: REF SMAOBJ free obj #
       free obj OF args := REF SMAOBJ(NIL) # let the garbage collector do it's job #
    ),
    (SMAVALUES args):( # args: REF SMAOBJ values obj #
       result := values OF values obj OF args
    ),
    (SMAMEAN args):( # args: REF SMAOBJ mean obj #
       result := sma OF mean obj OF args
    ),
    (SMAADD args):( # args: REF SMAOBJ add obj, LONG REAL v #
       obj := add obj OF args;
       v := v OF args;
       IF lv OF obj < period OF obj THEN
         (values OF obj)[lv OF obj+:=1] := v;
         sum OF obj +:= v;
         sma OF obj := sum OF obj / lv OF obj
       ELSE
         sum OF obj -:= (values OF obj)[ 1+ lv OF obj MOD period OF obj];
         sum OF obj +:= v;
         sma OF obj := sum OF obj / period OF obj;
         (values OF obj)[ 1+ lv OF obj  MOD  period OF obj ] := v; lv OF obj+:=1
       FI;
       result := sma OF obj
    )
    OUT
      SKIP
    ESAC
  OD;
  result
);

[]LONG REAL v = ( 1, 2, 3, 4, 5, 5, 4, 3, 2, 1 );

main: (
  INT i;

  REF SMAOBJ h3 := ( sma(SMANEW(3)) | (REF SMAOBJ obj):obj );
  REF SMAOBJ h5 := ( sma(SMANEW(5)) | (REF SMAOBJ obj):obj );

  FOR i FROM LWB v TO UPB v DO
    printf(($"next number "g(0,6)", SMA_3 = "g(0,6)", SMA_5 = "g(0,6)l$,
           v[i], (sma(SMAADD(h3, v[i]))|(LONG REAL r):r), ( sma(SMAADD(h5, v[i])) | (LONG REAL r):r )
    ))
  OD#;

  sma(SMAFREE(h3));
  sma(SMAFREE(h5))
#
)
