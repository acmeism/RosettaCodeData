Program transport;
{ based on the program of <Svetlana Belashova> }

Uses Crt;

Label l1;

Const N=10;
      n1=7; n2=7;
      Sa:longint=0;
      Sb:longint=0;

Type points=Array [1..N] of longint;
     distribution=Array [1..N,1..N] of longint;

Var A,B,alfa,beta,B_d,x:points;
    c,p:distribution;
    f,f0,x_min,Sp:longint;
    Nt,x_p,r,r_min,ki,kj,Na,Nb,h,l,i,j:byte;
    d:char;
    u:Array[1..N*N] of byte;

Procedure Nul (var a:points);
var i:byte;
Begin
     for i:=1 to N do a[i]:=0;
End;

Procedure PrintS (x,y:byte; s:string; c:byte);
Begin
     TextColor(c);
     GotoXY(x,y);
     Write(s);
End;

Procedure Print (x,y:byte; n:byte; a:longint; c:byte);
Begin
     TextColor(c);
     GotoXY(x,y); Write(' ':n);
     GotoXY(x,y); Write(a);
End;

Procedure Read (var x:longint; y:byte);
var i:integer;
    s:string;
    c:char;
    j,k:byte;
Begin
     s:=''; i:=1;
     TextColor(11);
     Repeat
           c:=ReadKey;
           Case ord(c) of
48..57:         begin s:=s+c;
                      Write(c);
                      inc(i);
                end;
8:              if i>1 then begin dec(i);
                      Delete(s,i,1);
                      Write(chr(8),' ',chr(8));
                end;
           end;
           j:=WhereX;
           GotoXY(60,1); ClrEOL;
           if i>y then begin
              TextColor(4);
              Write('Not more than ');
              for k:=1 to y-1 do Write('9');
              TextColor(11);
           end;
           GotoXY(j,1);
     Until (ord(c)=13) and (i<y+1);
     val(s,x,i);
End;

Procedure horizontal (a,b,c,d,e:char);
var i,j:byte;
Begin
     Write(a);
     for i:=1 to n2 do Write(b);
     Write(c);
     for i:=1 to Nb do begin
         for j:=1 to n1 do Write(b);
         if i<>Nb then Write(d) else Write(c);
     end;
     for i:=1 to 4 do Write(b);
     Write(e);
End;

Procedure vertical;
var i:byte;
Begin
     Write('│',' ':n2,'║');
     for i:=1 to Nb-1 do Write(' ':n1,'│');
     WriteLn(' ':n1,'║',' ' :4,'│');
End;

Procedure Table; { Drawing the table }
Begin
    ClrScr;
    TextColor(1);
    h:=6+Na*3;
    l:=14+Nb*7;
    GotoXY(1,3);
    for i:=3 to h do vertical;
    GotoXY(1,2);
    horizontal('┌','─','╥','┬','┐');
    for i:=1 to Na+1 do begin
        GotoXY(1,i*3+2);
        if (i=1) or (i=Na+1)
           then horizontal('╞','═','╬','╪','╡')
           else horizontal('├','─','╫','┼','┤');
    end;
    GotoXY(1,h+1);
    horizontal('└','─','╨','┴','┘');
    TextColor(9);
    for i:=1 to Na do begin
        GotoXY(5,i*3+3);
        Write('A',i);
    end;
    for i:=1 to Nb do begin
        GotoXY(i*(n1+1)+n2-2,3);
        Write('B',i);
    end;
    l:=Nb*(n1+1)+n2+3;
    h:=Na*3+6;
    PrintS(4,3,'\Bj',9);
    PrintS(4,4,'Ai\',9);
    PrintS(1,1,'Table N1',14);
    PrintS(l,4,'alfa',9);
    PrintS(3,h,'beta',9);
End;

Procedure EnterIntoTheTable (var a:points; b:byte; c:char); { Entering into the table }
var i,l,m:byte;
Begin
     for i:=1 to b do begin
         TextColor(3);
         GotoXY(32,1);
         ClrEOL;
         Write(c,i,'=  ');
         Read(a[i],n1);
         TextColor(14);
         Case c of
'A':     GotoXY(n2-trunc(ln(a[i])/ln(10)),i*3+4);
'B':     GotoXY(n2+i*(n1+1)-trunc(ln(a[i])/ln(10)),4);
         end;
         Write(a[i]);
     end;
End;

Function CalculatingTheCost:longint;        { Calculating the cost of the plan }
var i,j:byte;
    f:longint;
Begin
     f:=0;
     for i:=1 to Na do
         for j:=1 to Nb do
             if p[i,j]>0 then inc(f,c[i,j]*p[i,j]);
     GotoXY(65,Nt+2);
     TextColor(10);
     Write('F',Nt,'=',f);
     CalculatingTheCost:=f;
End;

Function CalculatingThePotentials:boolean;      { Calculating the potentials }
var k,i,j:byte;
    Z_a,Z_b:points;
    d:boolean;
Begin
     Nul(Z_a); Nul(Z_b);
     alfa[1]:=0; Z_a[1]:=1; k:=1;
     Repeat
           d:=1=1;
           for i:=1 to Na do
               if Z_a[i]=1 then
                  for j:=1 to Nb do
                      if (p[i,j]>-1) and (Z_b[j]=0) then begin
                         Z_b[j]:=1;
                         beta[j]:=c[i,j]-alfa[i];
                         inc(k);
                         d:=1=2;
                      end;
           for i:=1 to Nb do
               if Z_b[i]=1 then
                  for j:=1 to Na do
                      if (p[j,i]>-1) and (Z_a[j]=0) then begin
                         Z_a[j]:=1;
                         alfa[j]:=c[j,i]-beta[i];
                         inc(k);
                         d:=1=2;
                      end;
     Until (k=Na+Nb) or d;
     if d then begin
        i:=1;
        While Z_a[i]=1 do inc(i);
        j:=1;
        While Z_b[j]=0 do inc(j);
        p[i,j]:=0;
        Print((j+1)*(n1+1)+n2-8,i*3+4,1,p[i,j],7);
     end;

     CalculatingThePotentials:=d;
End;

Procedure OutputThePlan;         { Output the plan of distribution }
var i,j,h,l,k:byte;
    c_max:longint;
Begin
     k:=0;
     for i:=1 to Na do begin
         h:=i*3+4;
         for j:=1 to Nb do begin
             l:=j*(n1+1)+n2-5;
             GotoXY(l,h);
             Write(' ':n1);
             if p[i,j]>0 then begin
                inc(k);
                Print(l-trunc(ln(p[i,j])/ln(10))+5,h,1,p[i,j],14);
             end
             else if p[i,j]=0 then begin
                     Print(l+n1-2,h,1,p[i,j],14);
                     inc(k);
             end;
         end;
     end;

     While CalculatingThePotentials do inc(k);

     if k>Na+Nb-1 then PrintS(40,1,'k > n+m-1',12);
End;

Function CalculatingTheCoefficients(var ki,kj:byte):integer; { Calculation the coefficients in the free cells }
var i,j:byte;
    k,k_min:integer;
    b:boolean;
Begin
     b:=1=1;
     for i:=1 to Na do
         for j:=1 to Nb do
             if p[i,j]=-1 then begin
                k:=c[i,j]-alfa[i]-beta[j];
                if b then begin
                   b:=1=2;
                   ki:=i; kj:=j; k_min:=k;
                end else
                    if k<k_min then begin
                       k_min:=k;
                       ki:=i; kj:=j;
                    end;
                TextColor(6);
                GotoXY(j*(n1+1)+n2-5,i*3+4);
                Write('(',k,')');
             end;
     if k_min<0 then PrintS(kj*(n1+1)+n2,ki*3+4,'X',12);
     CalculatingTheCoefficients:=k_min;
End;

Procedure div_mod(c:byte; var a,b:byte);   { Translate one-dimensional array to two-dimensional }
Begin
     b:=c mod Nb; a:=c div Nb +1;
     if b=0 then begin
        b:=Nb; dec(a);
     end;
End;

Procedure Recursive(Xi,Yi:byte; var z:boolean; var c:byte);
var i,j:byte;
Begin
   z:=1=2;
   Case c of
1:   for i:=1 to Na do
         if i<>Xi then
            if p[i,Yi]>-1 then begin
               if u[(i-1)*Nb+Yi]=0 then begin
                  u[(Xi-1)*Nb+Yi]:=(i-1)*Nb+Yi;
                  c:=2;
                  Recursive(i,Yi,z,c);
                  if z then exit;
               end;
            end
            else if (i=ki) and (Yi=kj) then begin
                    u[(Xi-1)*Nb+Yi]:=(ki-1)*Nb+kj;
                    z:=not z;
                    exit;
            end;
2:   for i:=1 to Nb do
         if i<>Yi then
            if p[Xi,i]>-1 then begin
               if u[(Xi-1)*Nb+i]=0 then begin
                  u[(Xi-1)*Nb+Yi]:=(Xi-1)*Nb+i;
                  c:=1;
                  Recursive(Xi,i,z,c);
                  if z then exit;
               end;
            end
            else if (Xi=ki) and (i=kj) then begin
                    u[(Xi-1)*Nb+Yi]:=(ki-1)*Nb+kj;
                    z:=not z;
                    exit;
            end;
   end;
   u[(Xi-1)*Nb+Yi]:=0;
   c:=c mod 2 +1;
End;

Procedure Contour;       { Determine the contour of displacement }
var i,j,k,mi,mj,l:byte;
    z:boolean;
    p_m:longint;
Begin
     for i:=1 to N*N do u[i]:=0;
     l:=1;
     Recursive(ki,kj,z,l);
     i:=ki; j:=kj;
     k:=u[(i-1)*Nb+j];
     div_mod(k,i,j);
     mi:=i; mj:=j; l:=1;
     Repeat
           inc(l);
           k:=u[(i-1)*Nb+j];
           div_mod(k,i,j);
           if l mod 2=1 then
              if p[i,j]<p[mi,mj] then begin
                 mi:=i; mj:=j;
              end;
     Until (i=ki) and (j=kj);

     i:=ki; j:=kj; l:=0;
     p_m:=p[mi,mj];
     Repeat
           if l mod 2=0 then begin
              inc(p[i,j],p_m);
              PrintS((n1+1)*j+n2-1,i*3+3,'(+)',12);
           end else begin
               dec(p[i,j],p_m);
               PrintS((n1+1)*j+n2-1,i*3+3,'(-)',12);
           end;
           if l=0 then inc(p[i,j]);
           k:=u[(i-1)*Nb+j];
           div_mod(k,i,j);
           inc(l);
     Until (i=ki) and (j=kj);
     p[mi,mj]:=-1;
End;

Procedure Pause;
var d:char;
Begin
     TextColor(6);
     GotoXY(40,1);
     Write('Press any key');
     d:=ReadKey;
     GotoXY(40,1);
     ClrEOL;
End;

BEGIN
    Nul(alfa); Nul(beta);
    Nt:=1;
    ClrScr;
    TextColor(10);
    Repeat
          Write('Enter the number of suppliers (2<=Na<=',N-1,')   ');
          ReadLn(Na);
          Write('Enter the number of consumers (2<=Nb<=',N-1,')   ');
          ReadLn(Nb);
    Until (Na>1) and (Na<=N-1) and (Nb>1) and (Nb<=N-1);
    Table;

    PrintS(1,1,'Enter the production quantity:',3);
    EnterIntoTheTable(A,Na,'A');
    EnterIntoTheTable(B,Nb,'B');
    TextColor(3);
    GotoXY(1,1); ClrEOL;
    Write('Enter the cost of transportation');
    for i:=1 to Na do
        for j:=1 to Nb do begin
            TextColor(3);
            GotoXY(29,1); ClrEOL;
            Write('A',i,' - B',j,'  ');
            Read(c[i,j],5);
            Print((n1+1)*j+n2-4,i*3+3,1,c[i,j],11);
        end;

    GotoXY(1,1);
    ClrEOL;
    TextColor(14);
    Write('Table N1');

    for i:=1 to Na do Sa:=Sa+A[i];
    for i:=1 to Nb do Sb:=Sb+B[i];
    if Sa<>Sb then begin
       PrintS(20,1,'The problem is open (Press any key)',7);
       d:=ReadKey;
       if Sa>Sb then begin
          inc(Nb);
          B[Nb]:=Sa-Sb;
          for i:=1 to Na do c[i,Nb]:=0;
       end else begin
           inc(Na);
           A[Na]:=Sb-Sa;
           for i:=1 to Nb do c[Na,i]:=0;
       end;
       Table;
       for i:=1 to Na do
           for j:=1 to Nb do Print((n1+1)*j+n2-4,i*3+3,1,c[i,j],11);
       for i:=1 to Na do
           Print(n2-trunc(ln(A[i])/ln(10)),i*3+4,1,A[i],14);
       for i:=1 to Nb do
           Print(n2+i*(n1+1)-trunc(ln(B[i])/ln(10)),4,1,B[i],14);
       PrintS(20,1,'The problem is open',7);
    end
       else PrintS(20,1,'The problem is closed',7);

(**************** Drafting the basic plan ******************)
    for i:=1 to Nb do B_d[i]:=B[i];
    for i:=1 to Na do begin
        for j:=1 to Nb do x[j]:=j;
        for j:=1 to Nb-1 do begin
            x_min:=c[i,x[j]];
            r_min:=j;
            for r:= j+1 to Nb do
                if (x_min>c[i,x[r]]) or
                 ((x_min=c[i,x[r]]) and (B[x[r]]>b[x[r_min]])) then
                begin
                   x_min :=c[i,x[r]];
                   r_min:=r;
                end;
            x_p:=x[r_min];
            x[r_min]:=x[j];
            x[j]:=x_p;
        end;
        Sp:=0;
        for j:=1 to Nb do begin
            p[i,x[j]]:=B_d[x[j]];
            if p[i,x[j]]>A[i]-Sp then p[i,x[j]]:=A[i]-Sp;
            inc(Sp,p[i,x[j]]);
            dec(B_d[x[j]],p[i,x[j]]);
        end;
    end;
(***********************************************************)

    for i:=1 to Na do
        for j:=1 to Nb do if p[i,j]=0 then p[i,j]:=-1;
    OutputThePlan;
    f:=CalculatingTheCost; f0:=F;

    While CalculatingThePotentials do;
    for i:=1 to Na do Print(l+1,i*3+3,3,alfa[i],11);
    for i:=1 to Nb do Print(i*(n1+1)+n2-4,h,6,beta[i],11);
    Pause;

(******* gradual approach the plan to the optimality ******)
    While CalculatingTheCoefficients(ki,kj)<0 do begin
          Contour;
          pause;
          for i:=1 to Na do
              for j:=1 to Nb do PrintS((n1+1)*j+n2-1,i*3+3,'   ',14);
          inc(Nt);
          GotoXY(1,1);
          Write('Table N',Nt);
          OutputThePlan;
          f0:=f; f:=CalculatingTheCost;
          if CalculatingThePotentials then Goto l1;
          for i:=1 to Na do Print(l+1,i*3+3,3,alfa[i],11);
          for i:=1 to Nb do Print(i*(n1+1)+n2-4,h,6,beta[i],11);
          Pause;
    end;
(***********************************************************)

    PrintS(40,1,'Solution is optimal',12);
    PrintS(60,1,'(any key)',6);
    for i:=1 to Na do
        for j:=1 to Nb do if p[i,j]=-1 then begin
            h:=i*3+4;
            l:=j*(n1+1)+n2-5;
            GotoXY(l,h);
            Write(' ':n1);
        end;
    GotoXY(40,1);
l1: d:=ReadKey;
END.
