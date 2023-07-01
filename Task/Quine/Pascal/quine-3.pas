program main(output);type string=packed array[1..60]of char;
var l:array[1..9]of string; c:array[1..7]of char; i:integer;
lc, a, o, k, n, e, s, t:char; begin
l[1]:='program main(output);type string=packed array[1..60]of char;';
l[2]:='var l:array[1..9]of string; c:array[1..7]of char; i:integer;';
l[3]:='lc, a, o, k, n, e, s, t:char; begin                         ';
l[4]:='for i := 1 to 3 do writeln(l[i]);                           ';
l[5]:='a:=c[1];t:=c[2];o:=c[3];k:=c[4];n:=c[5];e:=c[6];s:=c[7];    ';
l[6]:='for i := 1 to 9 do writeln(a,o,i:1,k,n,e,lc,l[i],lc,s);     ';
l[7]:='writeln(a, t, n, e, lc, lc, lc, lc, s);                     ';
l[8]:='for i := 1 to 7 do write(t,o,i:1,k,n,e,lc,c[i],lc,s);       ';
l[9]:='writeln; for i := 4 to 9 do writeln(l[i]); end.             ';
lc:='''';
c[1]:='l';c[2]:='c';c[3]:='[';c[4]:=']';c[5]:=':';c[6]:='=';c[7]:=';';
for i := 1 to 3 do writeln(l[i]);
a:=c[1];t:=c[2];o:=c[3];k:=c[4];n:=c[5];e:=c[6];s:=c[7];
for i := 1 to 9 do writeln(a,o,i:1,k,n,e,lc,l[i],lc,s);
writeln(a, t, n, e, lc, lc, lc, lc, s);
for i := 1 to 7 do write(t,o,i:1,k,n,e,lc,c[i],lc,s);
writeln; for i := 4 to 9 do writeln(l[i]); end.
