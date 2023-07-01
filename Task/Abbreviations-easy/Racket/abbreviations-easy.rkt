#lang racket

(define command-string
  "Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy
   COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find
   NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput
   Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO
   MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT
   READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT
   RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up")

(define input-string
  "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin")

(define (make-command command)
  (cons (string-upcase command)
        (list->string (takef (string->list command) char-upper-case?))))

(define commands (map make-command (string-split command-string)))

(string-join
 (for/list ([s (in-list (string-split input-string))])
   (define up (string-upcase s))
   (or (for/or ([command (in-list commands)])
         (match-define (cons full-command abbrev) command)
         (and (string-prefix? up abbrev)
              (string-prefix? full-command up)
              full-command))
       "*error*"))
 " ")
