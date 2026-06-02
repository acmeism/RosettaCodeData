Rebol [
    title: "Rosetta code: Abbreviations, easy"
    file:  %Abbreviations,_easy.r3
    url:   https://rosettacode.org/wiki/Abbreviations,_easy
]

get-full-name: function [
    "Validate abbreviated commands against a command table"
    word [string! char!]
    commands [block!]
][
    word: to string! word
    foreach cmd commands [
        ;; count required uppercase prefix length
        prefix-end: 0
        foreach c cmd [
            if c > #"Z" [break]
            ++ prefix-end
        ]
        prefix: copy/part cmd prefix-end
        if all [
            parse word [prefix to end] ;; starts with required prefix
            parse cmd  [word   to end] ;; is not longer than command
        ][
            return uppercase copy cmd
        ]
    ]
    "*error*"
]

split-commands: function/with [commands [string!]][
    parse commands [
        any delimit
        collect any [keep some chars any delimit]
    ]
][
    delimit: charset " ^-^/"
    chars: complement delimit
]

commands: split-commands {
   Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy
   COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find
   NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput
   Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO
   MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT
   READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT
   RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up}

inputs: split-commands {riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin}

foreach cmd inputs [
    full: get-full-name cmd commands
    print [pad cmd 10 '-> full]
]
