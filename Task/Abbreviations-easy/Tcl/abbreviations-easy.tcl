proc appendCmd {word} {
  # Procedure to append the correct command from the global list ::cmds
  # for the word given as parameter to the global list ::result.
  # If a matching word has been found and appended to ::result, this procedure
  # behaves like a "continue" statement, causing the loop containing it to
  # jump over the rest of the body.
  set candidates [lsearch -inline -all -nocase -glob $::cmds "${word}*"]
  foreach cand $candidates {
    if {[string length $word] >= $::minLen($cand)} {
      lappend ::result [string toupper $cand]
      return -code continue
    }
  }
}

set cmds {Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy
   COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find
   NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput
   Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO
   MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT
   READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT
   RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up}

# Find the minimum lengths necessary for each command.
foreach c $cmds {
  regexp {^[A-Z]+} $c match
  set minLen($c) [string length $match]
}

set words {riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin}
set result {}

foreach w $words {
  appendCmd $w
  lappend result *error*
}

puts $result
