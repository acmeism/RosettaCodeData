import "./pattern" for Pattern

var source1 = """
<lang AutoHotkey>; usage: > fixtags.ahk input.txt ouput.txt
FileRead, text, %1%
langs = ada,awk,autohotkey,etc
slang = /lang
slang := "<" . slang . "/>"
Loop, Parse, langs, `,
{
  tag1 = <%A_LoopField%>
  tag2 = </%A_LoopField%>
  text := RegExReplace(text, tag1, "<lang " . A_LoopField . ">")
  text := RegExReplace(text, tag2, slang)
  text := RegExReplace(text, "<code (.+?)>(.*?)</code>"
          , "<lang $1>$2" . slang)
}
FileAppend, % text, %2%
</lang>
"""

var source2 = """
<lang perl>my @langs = qw(ada cpp-qt pascal lscript z80 visualprolog
html4strict cil objc asm progress teraterm hq9plus genero tsql
email pic16 tcl apt_sources io apache vhdl avisynth winbatch
vbnet ini scilab ocaml-brief sas actionscript3 qbasic perl bnf
cobol powershell php kixtart visualfoxpro mirc make javascript
cpp sdlbasic cadlisp php-brief rails verilog xml csharp
actionscript nsis bash typoscript freebasic dot applescript
haskell dos oracle8 cfdg glsl lotusscript mpasm latex sql klonec
ruby ocaml smarty python oracle11 caddcl robots groovy smalltalk
diff fortran cfm lua modula3 vb autoit java text scala
lotusformulas pixelbender reg _div whitespace providex asp css
lolcode lisp inno mysql plsql matlab oobas vim delphi xorg_conf
gml prolog bf per scheme mxml d basic4gl m68k gnuplot idl abap
intercal c_mac thinbasic java5 xpp boo klonecpp blitzbasic eiffel
povray c gettext);

my $text = join "", <STDIN>;
my $slang="/lang";
for (@langs) {
    $text =~ s|<$_>|<lang $_>|g;
    $text =~ s|</$_>|<$slang>|g;
}

$text =~ s|<code (.+?)>(.*?)</code>|<lang $1>$2<$slang>|sg;

print $text;</lang>
"""

var source3 = """
<lang>HAI 1.3

I HAS A bottles ITZ 99 I HAS A plural ITZ "Z" I HAS A lyric ITZ "99 BOTTLZ OV BEER"

IM IN YR song

   VISIBLE lyric " ON TEH WALL"
   VISIBLE lyric
   VISIBLE "TAEK 1 DOWN, PAZ IT AROUN"
   bottles R DIFF OF bottles AN 1
   NOT bottles, O RLY?
       YA RLY, VISIBLE "NO MOAR BOTTLZ OV BEER ON TEH WALL", GTFO
   OIC
   BOTH SAEM bottles AN 1, O RLY?
       YA RLY, plural R ""
   OIC
   lyric R SMOOSH bottles " BOTTL" plural " OV BEER" MKAY
   VISIBLE lyric " ON TEH WALL:)"
IM OUTTA YR song

KTHXBYE</lang>
"""

var p = Pattern.new("<lang [+1^>]>")
var sh = "syntaxhighlight"
var repl = "<%(sh) lang=\"$1\">"
for (source in [source1, source2, source3]) {
    source = p.replace(source, repl, 1, 0).
             replace("<lang>", "<%(sh) lang=\"text\">").
             replace("</lang>", "</%(sh)>")
    System.print(source)
    System.print()
}
