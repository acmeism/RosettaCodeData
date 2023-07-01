import re, strutils

const
  Langs = ["ada", "cpp-qt", "pascal", "lscript", "z80", "visualprolog",
           "html4strict", "cil", "objc", "asm", "progress", "teraterm", "hq9plus",
           "genero", "tsql", "email", "pic16", "tcl", "apt_sources", "io", "apache",
           "vhdl", "avisynth", "winbatch", "vbnet", "ini", "scilab", "ocaml-brief",
           "sas", "actionscript3", "qbasic", "perl", "bnf", "cobol", "powershell",
           "php", "kixtart", "visualfoxpro", "mirc", "make", "javascript", "cpp",
           "sdlbasic", "cadlisp", "php-brief", "rails", "verilog", "xml", "csharp",
           "actionscript", "nsis", "bash", "typoscript", "freebasic", "dot",
           "applescript", "haskell", "dos", "oracle8", "cfdg", "glsl", "lotusscript",
           "mpasm", "latex", "sql", "klonec", "ruby", "ocaml", "smarty", "python",
           "oracle11", "caddcl", "robots", "groovy", "smalltalk", "diff", "fortran",
           "cfm", "lua", "modula3", "vb", "autoit", "java", "text", "scala",
           "lotusformulas", "pixelbender", "reg", "_div", "whitespace", "providex",
           "asp", "css", "lolcode", "lisp", "inno", "mysql", "plsql", "matlab",
           "oobas", "vim", "delphi", "xorg_conf", "gml", "prolog", "bf", "per",
           "scheme", "mxml", "d", "basic4gl", "m68k", "gnuplot", "idl", "abap",
           "intercal", "c_mac", "thinbasic", "java5", "xpp", "boo", "klonecpp",
           "blitzbasic", "eiffel", "povray", "c", "gettext"]

var text = stdin.readAll()

for lang in Langs:
  text = text.replace("<$#>" % lang, "<lang $#>" % lang)
  text = text.replace("</$#>" % lang, "</lang>")

text = text.replacef(re"(?s)<code (.+?)>(.*?)</code>", r"<lang $1>$2</lang>")

stdout.write text
