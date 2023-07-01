   COMMAND_TABLE=: noun define
Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy
   COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find
   NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput
   Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO
   MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT
   READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT
   RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up
 )

   'CAPA CAPZ'=:a.i.'AZ'
   CT =: (, 3 ": [: +/ (CAPA&<: *. <:&CAPZ)@:(a.&i.))&.>&.:;: CRLF -.~ COMMAND_TABLE
   user_words =: 'riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin'
   CT expand user_words
RIGHT REPEAT *error* PUT MOVE RESTORE *error* *error* *error* POWERINPUT
