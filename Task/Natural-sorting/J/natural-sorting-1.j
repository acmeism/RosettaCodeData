require'strings regex'

lines=: <;.2
titleFix=: ('^\s*(the|a|an)\b';'')&rxrplc
isNum=: e.&'0123456789'
num=: ".^:(isNum@{.)
split=: <@num/.~ [:+/\1,2 ~:/\ isNum
norm=: [: split (32 9 12 13 14 15{a.) -.~ [: titleFix tolower

natSor=:  lines ;@/: norm&.>@lines
