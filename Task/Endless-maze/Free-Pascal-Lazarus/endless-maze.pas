program maze;

 var xp:integer = 127;
     yp:integer = 127;
     na:integer=0;
     a,d,f,n:integer;
     e:array of integer;
     x:array of integer;
     y:array of integer;
     entry:string;

 begin

  setlength(e,0);
  setlength(x,0);
  setlength(y,0);
  f=random(4);

  while (true) do begin

   a:=na;
   for n:=0 to na-1 do
    if (x[n]=xp) and (y[n]=yp) then begin
     a:=n;
     break;
     end;

   if (a=na) then begin
    na:=na+1;
    setlength(x,length(x)+1);
    setlength(y,length(y)+1);
    setlength(e,length(e)+4);
    x[a]:=xp;
    y[a]:=yp;
    for n:=0 to 3 do e[4*a+n] := random(2);
    for n:=0 to na do
          if (x[n]=x[a]+1) and (y[n]=y[a]  ) then e[4*a  ]:=e[4*n+2]
     else if (x[n]=x[a]  ) and (y[n]=y[a]+1) then e[4*a+1]:=e[4*n+3]
     else if (x[n]=x[a]-1) and (y[n]=y[a]  ) then e[4*a+2]:=e[4*n  ]
     else if (x[n]=x[a]  ) and (y[n]=y[a]-1) then e[4*a+3]:=e[4*n+1];
    end;

   write('Paths:');
   if e[4*a+f          ]=1 then write(' ahead');
   if e[4*a+(f+1) mod 4]=1 then write(' right');
   if e[4*a+(f+2) mod 4]=1 then write(' back');
   if e[4*a+(f+3) mod 4]=1 then write(' left');
   writeln();

   d:=-1;
   entry:='';
   while d<0 do begin
    write('> ');
    readln(entry);
         if entry='ahead' then d:=f
    else if entry='right' then d:=(f+1) mod 4
    else if entry='back' then d:=(f+2) mod 4
    else if entry='left' then d:=(f+3) mod 4
    else if entry='exit' then
     if (xp=127) and (yp=127) then begin
      writeln('You have exited the maze.');
      readln();
      exit;
      end
     else writeln('You are not at the exit.')
    else if entry='quit' then begin
     readln();
     exit
     end
    else writeln('Entry invalid.');
    end;

   case d of
    0: if e[4*a  ]=1 then begin xp := xp + 1; f := d; end else d:=-1;
    1: if e[4*a+1]=1 then begin yp := yp + 1; f := d; end else d:=-1;
    2: if e[4*a+2]=1 then begin xp := xp - 1; f := d; end else d:=-1;
    3: if e[4*a+3]=1 then begin yp := yp - 1; f := d; end else d:=-1;
    end;

   end;

  end.
