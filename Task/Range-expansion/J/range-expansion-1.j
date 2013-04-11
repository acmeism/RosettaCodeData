require'strings'
to=: [ + i.@>:@-~
num=: _&".
normaliz=: rplc&(',-';',_';'--';'-_')@,~&','
subranges=:<@(to/)@(num;._2)@,&'-';._1
rngexp=: ;@subranges@normaliz
