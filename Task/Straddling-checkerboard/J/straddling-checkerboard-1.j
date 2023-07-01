'Esc Stop'=: '/.'
'Nums Alpha'=: '0123456789';'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
Charset=: Nums,Alpha,Stop

escapenum=: (,@:((; Esc&,)&>) Nums) rplc~ ]               NB. escape numbers
unescapenum=: ((, ; ' '&,@])"1 0  Nums"_) rplc~ ]         NB. unescape coded numbers (x is escape code, y is cipher)
expandKeyatUV=: 0:`[`(1 #~ 2 + #@])} #inv ]
makeChkBrd=: Nums , expandKeyatUV

chkbrd=: conjunction define
  'uv key'=. n
  board=. uv makeChkBrd key
  select. m
  case. 0 do.                                                      NB. encode
    digits=. board 10&#.inv@i. escapenum y
    ' ' -.~ ,(":@{:"1 digits) ,.~ (1 1 0 2{":uv) {~ {."1 digits
  case. 1 do.                                                      NB. decode
    esc=. 0 chkbrd (uv;key) Esc                                    NB. find code for Esc char
    tmp=. esc unescapenum esc,'0',y
    tmp=. ((":uv) ((-.@e.~ _1&|.) *. e.~) tmp) <;.1 tmp            NB. box on chars from rows 0 2 3
    idx=. (}. ,~ (1 1 0 2{":uv) ":@i. {.) each tmp                 NB. recreate indices for rows 0 2 3
    idx=. ;(2&{. , [: ((0 1 $~ +:@#) #inv!.'1' ]) 2&}.) each idx   NB. recreate indices for row 1
    }.board {~ _2 (_&".)\ idx
  end.
)
