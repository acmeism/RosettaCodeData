 include FMS-SI.f
include FMS-SILib.f

: foo { l | s -- }
  cr ." {"
  l size: dup 1- to s
    0 ?do
    i l at: p:
    s i - 1 >
     if ." , "
     else s i <> if ."  and " then
     then
    loop
  ." }" l <free ;

${ } foo
\ {}
${ ABC } foo
\ {ABC}
${ ABC DEF } foo
\ {ABC and DEF}
${ ABC DEF G } foo
\ {ABC, DEF and G}
${ ABC DEF G H } foo
\ {ABC, DEF, G and H}
${ ABC DEF G H I } foo
\ {ABC, DEF, G, H and I}
