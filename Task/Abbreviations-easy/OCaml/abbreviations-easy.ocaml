let cmds = "\
  Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy
  COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find
  NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput
  Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO
  MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT
  READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT
  RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up"

let user =
  "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin"

let char_is_uppercase c =
  match c with
  | 'A'..'Z' -> true
  | _ -> false

let get_abbr s =
  let seq = String.to_seq s in
  let seq = Seq.filter char_is_uppercase seq in
  (String.of_seq seq)

let () =
  let cmds = Str.split (Str.regexp "[ \r\n]+") cmds in
  let cmds =
    List.map (fun s ->
      get_abbr s,
      String.uppercase_ascii s
    ) cmds
  in
  let user = Str.split (Str.regexp "[ \r\n]+") user in
  let r =
    List.map (fun ucmd ->
      let n = String.length ucmd in
      let find_abbr (abbr, cmd) =
        let na = String.length abbr in
        let nc = String.length cmd in
        if n < na || nc < n then false else
          let sub = String.sub cmd 0 n in
          (sub = String.uppercase_ascii ucmd)
      in
      match List.find_opt find_abbr cmds with
      | Some (_, found) -> found
      | None -> "*error*"
    ) user
  in
  print_endline (String.concat " " r)
