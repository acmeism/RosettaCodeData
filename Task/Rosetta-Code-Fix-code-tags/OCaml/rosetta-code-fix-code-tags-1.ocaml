#load "str.cma"

let langs =
  Str.split (Str.regexp " ")
    "actionscript ada algol68 amigae applescript autohotkey awk bash basic \
     befunge bf c cfm cobol cpp csharp d delphi e eiffel factor false forth \
     fortran fsharp haskell haxe j java javascript lisaac lisp logo lua m4 \
     mathematica maxscript modula3 moo objc ocaml octave oz pascal perl \
     raku php pike pop11 powershell prolog python qbasic r rebol ruby \
     scala scheme slate smalltalk tcl ti89b vbnet vedit"

let read_in ic =
  let buf = Buffer.create 16384
  and tmp = String.create 4096 in
  let rec aux() =
    let bytes = input ic tmp 0 4096 in
    if bytes > 0 then begin
      Buffer.add_substring buf tmp 0 bytes;
      aux()
    end
  in
  (try aux() with End_of_file -> ());
  (Buffer.contents buf)

let repl pat tpl str =
  let reg = Str.regexp_string_case_fold pat in
  let str = Str.global_replace reg tpl str in
  (str)

(* change <%s> to <lang %s> *)
let repl1 lang str =
  let pat = "<" ^ lang ^ ">"
  and tpl = "<lang " ^ lang ^ ">" in
  (repl pat tpl str)

(* change </%s> to </la\ng> *)
let repl2 lang str =
  let pat = "</" ^ lang ^ ">"
  and tpl = "</lang"^">" in
  (repl pat tpl str)

(* change <code %s> to <lang %s> *)
let repl3 lang str =
  let pat = "<code " ^ lang ^ ">"
  and tpl = "<lang " ^ lang ^ ">" in
  (repl pat tpl str)

(* change </code> to </la\ng> *)
let repl4 lang str =
  let pat = "</code>"
  and tpl = "</lang"^">" in
  (repl pat tpl str)


let () =
  print_string (
    List.fold_left (fun str lang ->
        (repl4 lang (repl3 lang (repl2 lang (repl1 lang str))))
      ) (read_in stdin) langs)
