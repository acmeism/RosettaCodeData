my @langs = <
    abap actionscript actionscript3 ada apache applescript apt_sources
    asm asp autoit avisynth bash basic4gl bf blitzbasic bnf boo c caddcl
    cadlisp cfdg cfm cil c_mac cobol cpp cpp-qt csharp css d delphi
    diff _div dos dot eiffel email fortran freebasic genero gettext
    glsl gml gnuplot groovy haskell hq9plus html4strict idl ini inno
    intercal io java java5 javascript kixtart klonec klonecpp latex lisp
    lolcode lotusformulas lotusscript lscript lua m68k make matlab mirc
    modula3 mpasm mxml mysql nsis objc ocaml ocaml-brief oobas oracle11
    oracle8 pascal per perl php php-brief pic16 pixelbender plsql povray
    powershell progress prolog providex python qbasic rails reg robots
    ruby sas scala scheme scilab sdlbasic smalltalk smarty sql tcl teraterm
    text thinbasic tsql typoscript vb vbnet verilog vhdl vim visualfoxpro
    visualprolog whitespace winbatch xml xorg_conf xpp z80
>;

$_ = slurp;

for @langs -> $l {
    s:g [ '<'  $l '>' ] = "<lang $l>";
    s:g [ '</' $l '>' ] = '</' ~ 'lang>';
}

s:g [ '<code '(.+?) '>' (.*?) '</code>' ] = "<lang $0>{$1}</"~"lang>";

.say;
