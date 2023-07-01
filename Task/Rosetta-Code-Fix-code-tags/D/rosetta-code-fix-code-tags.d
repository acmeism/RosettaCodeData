import std.stdio, std.regex, std.string, std.array;

immutable langs = "_div abap actionscript actionscript3 ada apache
applescript apt_sources asm asp autoit avisynth bash basic4gl bf
blitzbasic bnf boo c c_mac caddcl cadlisp cfdg cfm cil cobol cpp
cpp-qt csharp css d delphi diff dos dot eiffel email fortran
freebasic genero gettext glsl gml gnuplot groovy haskell hq9plus
html4strict idl ini inno intercal io java java5 javascript kixtart
klonec klonecpp latex lisp lolcode lotusformulas lotusscript
lscript lua m68k make matlab mirc modula3 mpasm mxml mysql nsis
objc ocaml ocaml-brief oobas oracle11 oracle8 pascal per perl php
php-brief pic16 pixelbender plsql povray powershell progress
prolog providex python qbasic rails reg robots ruby sas scala
scheme scilab sdlbasic smalltalk smarty sql tcl teraterm text
thinbasic tsql typoscript vb vbnet verilog vhdl vim visualfoxpro
visualprolog whitespace winbatch xml xorg_conf xpp z80".split;

string fixTags(string text) {
    static immutable slang = "/lang";
    static immutable code = "code";

    foreach (immutable lang; langs) {
        text = text.replace("<%s>".format(lang),
                            "<lang %s>".format(lang));
        text = text.replace("</%s>".format(lang),
                            "<%s>".format(slang));
    }

    return text.replace("<%s (.+?)>(.*?)</%s>"
                        .format(code, code).regex("g"),
                        "<lang $1>$2<%s>".format(slang));
}

void main() {
    ("lorem ipsum <c>some c code</c>dolor sit amet, <csharp>some " ~
    "csharp code</csharp> consectetur adipisicing elit, <code r>" ~
    " some r code </code>sed do eiusmod tempor incididunt")
    .fixTags
    .writeln;
}
