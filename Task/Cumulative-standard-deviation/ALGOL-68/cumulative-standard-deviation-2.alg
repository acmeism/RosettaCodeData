MODE STAT = STRUCT(
  LONG REAL sum,
  LONG REAL sum2,
  INT num
);

OP INIT = (REF STAT new)REF STAT:
  (init OF class stat)(new);

MODE CLASSSTAT = STRUCT(
  PROC (REF STAT, LONG REAL #value#)VOID plusab,
  PROC (REF STAT)LONG REAL stddev, mean, variance, count,
  PROC (REF STAT)REF STAT init
);

CLASSSTAT class stat;

plusab OF class stat := (REF STAT self, LONG REAL value)VOID:(
    num OF self +:= 1;
    sum OF self +:= value;
    sum2 OF self +:= value*value
  );

OP +:= = (REF STAT lhs, LONG REAL rhs)VOID: # some syntatic sugar #
  (plusab OF class stat)(lhs, rhs);

stddev OF class stat := (REF STAT self)LONG REAL:
    long sqrt((variance OF class stat)(self));

# could define STDDEV as an operator for more syntatic sugar
  OP STDDEV = ([]LONG REAL value)LONG REAL: (
    REF STAT stat = INIT LOC STAT;
    FOR i FROM LWB value TO UPB value DO
      stat +:= value[i]
    OD;
    (stddev OF class stat)(stat)
  );
#

mean OF class stat := (REF STAT self)LONG REAL:
    sum OF self/LONG REAL(num OF self);

variance OF class stat := (REF STAT self)LONG REAL:(
    LONG REAL m = (mean OF class stat)(self);
    sum2 OF self/LONG REAL(num OF self)-m*m
  );

count OF class stat := (REF STAT self)LONG REAL:
    num OF self;

init OF class stat := (REF STAT self)REF STAT:(
    sum OF self := sum2 OF self := num OF self := 0;
    self
  );

# main # (
  []LONG REAL value = ( 2,4,4,4,5,5,7,9 );
#  printf(($"standard deviation operator = "g(0,6)l$, STDDEV value));
#
  REF STAT stat = INIT LOC STAT;
  FOR i FROM LWB value TO UPB value DO
    stat +:= value[i];
    printf(($"value: "g(0,6)," standard dev := "g(0,6)l$, value[i], (stddev OF class stat)(stat)))
  OD;
#
  printf(($"standard deviation = "g(0,6)l$, (stddev OF class stat)(stat)));
  printf(($"mean = "g(0,6)l$, (mean OF class stat)(stat)));
  printf(($"variance = "g(0,6)l$, (variance OF class stat)(stat)));
  printf(($"count = "g(0,6)l$, (count OF class stat)(stat)));
#
  SKIP
)
