#! xbigforth
\ automatic generated code
\ do not edit

also editor also minos also forth

component class ccount
public:
  early widget
  early open
  early dialog
  early open-app
  text-label ptr click#
 ( [varstart] ) cell var clicks ( [varend] )
how:
  : open     new DF[ 0 ]DF s" Click counter" open-component ;
  : dialog   new DF[ 0 ]DF s" Click counter" open-dialog ;
  : open-app new DF[ 0 ]DF s" Click counter" open-application ;
class;

ccount implements
 ( [methodstart] )  ( [methodend] )
  : widget  ( [dumpstart] )
        X" There have been no clicks yet" text-label new  ^^bind click#
        ^^ S[ 1 clicks +!
clicks @ 0 <# #S s" Number of clicks: " holds #> click# assign ]S ( MINOS ) X" Click me"  button new
      &2 vabox new panel
    ( [dumpend] ) ;
  : init  ^>^^  assign  widget 1 :: init ;
class;

: main
  ccount open-app
  $1 0 ?DO  stop  LOOP bye ;
script? [IF]  main  [THEN]
previous previous previous
