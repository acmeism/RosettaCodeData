extern crate regex;

use std::io;
use std::io::prelude::*;

use regex::Regex;

const LANGUAGES: &str =
    "_div abap actionscript actionscript3 ada apache applescript apt_sources asm asp autoit \
     avisynth bash basic4gl bf blitzbasic bnf boo c c_mac caddcl cadlisp cfdg cfm cil cobol cpp \
     cpp-qt csharp css d delphi diff dos dot eiffel email fortran freebasic genero gettext glsl \
     gml gnuplot groovy haskell hq9plus html4strict idl ini inno intercal io java java5 \
     javascript kixtart klonec klonecpp latex lisp lolcode lotusformulas lotusscript lscript lua \
     m68k make matlab mirc modula3 mpasm mxml mysql nsis objc ocaml ocaml-brief oobas oracle11 \
     oracle8 pascal per perl php php-brief pic16 pixelbender plsql povray powershell progress \
     prolog providex python qbasic rails reg robots ruby rust sas scala scheme scilab sdlbasic \
     smalltalk smarty sql tcl teraterm text thinbasic tsql typoscript vb vbnet verilog vhdl vim \
     visualfoxpro visualprolog whitespace winbatch xml xorg_conf xpp z80";

fn fix_tags(languages: &[&str], text: &str) -> String {
    let mut replaced_text = text.to_owned();

    for lang in languages.iter() {
        let bad_open = Regex::new(&format!("<{lang}>|<code {lang}>", lang = lang)).unwrap();
        let bad_close = Regex::new(&format!("</{lang}>|</code>", lang = lang)).unwrap();
        let open = format!("<lang {}>", lang);
        let close = "&lt;/lang&gt;";

        replaced_text = bad_open.replace_all(&replaced_text, &open[..]).into_owned();
        replaced_text = bad_close
            .replace_all(&replaced_text, &close[..])
            .into_owned();
    }

    replaced_text
}

fn main() {
    let stdin = io::stdin();
    let mut buf = String::new();
    stdin.lock().read_to_string(&mut buf).unwrap();
    println!(
        "{}",
        fix_tags(&LANGUAGES.split_whitespace().collect::<Vec<_>>(), &buf)
    );
}
