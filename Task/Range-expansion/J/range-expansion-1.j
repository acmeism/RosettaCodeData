require'strings'
thru=: <. + i.@(+*)@-~
num=: _&".
normaliz=: rplc&(',-';',_';'--';'-_')@,~&','
subranges=:<@(thru/)@(num;._2)@,&'-';._1
rngexp=: ;@subranges@normaliz
