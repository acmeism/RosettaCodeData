include FMS-SI.f
include FMS-SILib.f

${ Dishonest Fake Left Karl Hillary Monica Bubba Hillary Multi-Millionaire } constant haystack

: needleIndex { addr len $list | cnt -- idx }
  0 to cnt  $list uneach:
  begin
    $list each:
  while
    @: addr len compare 0= if cnt exit then
    cnt 1+ to cnt
  repeat true abort" Not found" ;

: LastIndexOf { addr len $list | cnt last-found -- idx }
  0 to cnt 0 to last-found  $list uneach:
  begin
    $list each:
  while
    @: addr len compare 0= if cnt to last-found  then
    cnt 1+ to cnt
  repeat
  last-found if last-found
  else true abort" Not found"
  then ;

s" Hillary" haystack needleIndex . \ => 4
s" Hillary" haystack LastIndexOf . \ => 7
s" Washington" haystack needleIndex . \ => aborted: Not found
