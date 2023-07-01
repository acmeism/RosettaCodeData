row0=: u: 9812+2}.5|i.10
king=: u:9812
rook=: u:9814
bish=: u:9815
pos=: I.@e.
bishok=: 1=2+/ .| pos&bish
rookok=: pos&rook -: (<./,>./)@pos&(rook,king)
ok=: bishok*rookok
perm=: A.&i.~ !
valid=: (#~ ok"1) ~.row0{"1~perm 8
gen=: valid {~ ? bind 960
