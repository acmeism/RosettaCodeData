abbrevs = Hash(String, String).new

"  Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy
   COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find
   NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput
   Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO
   MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT
   READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT
   RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up
".scan(/([A-Z]+)([a-z]*)/) do |m|
  command, minimal_abbrev, extra_letters = m[0].upcase, m[1], m[2].upcase
  extra_letters.chars.accumulate(minimal_abbrev).each do |k| abbrevs[k] = command end
end

puts "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin".split.map {|w|
  abbrevs[w.upcase]? || "*error*"
}.join(" ")
