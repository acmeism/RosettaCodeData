Rebol [
    title: "Rosetta code: Abbreviations, simple"
    file:  %Abbreviations,_simple.r3
    url:   https://rosettacode.org/wiki/Abbreviations,_simple
]

find-abbreviation-lengths: function [
    "Find minimal abbreviation length for each command"
    text [string!]
][
    result: make map! []
    parse transcode text [
        some [
             set cmd: word! (cmd: form cmd)
            [set len: integer! | (len: length? cmd)]
            (result/:cmd: len)
        ]
    ]
    result
]

build-abbreviations-table: function [
    "Expand each command into all valid abbreviations"
    cmd-lengths [map!]
][
    result: make map! []
    foreach [cmd min-len] cmd-lengths [
        cmd-up: uppercase copy cmd
        ;; step down from full length to min-len
        for i length? cmd min-len -1 [
            abbr: lowercase copy/part cmd i
            result/:abbr: cmd-up
        ]
    ]
    result
]

split-commands: function/with [commands [string!]][
    out: copy []
    parse commands [
        any [any delimit copy cmd: some chars (append out cmd)]
    ]
    out
][
    delimit: charset " ^-^/"
    chars: complement delimit
]

abbrevs: build-abbreviations-table find-abbreviation-lengths {
   add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3
   compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate
   3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2
   forward 2  get  help 1 hexType 4  input 1 powerInput 3  join 1 split 2 spltJOIN load
   locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2
   msg  next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit  read recover 3
   refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left
   2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1}


inputs: split-commands {
   riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin}

foreach cmd inputs [
    full: any [abbrevs/:cmd "*error*"]
    print [pad cmd 10 '-> full]
]
