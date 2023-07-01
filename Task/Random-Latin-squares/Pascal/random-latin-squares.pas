{$APPTYPE CONSOLE}

const
  Alpha = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';


Type
IncidenceCube = Array of Array Of Array of Integer;

Var
Cube : IncidenceCube;
DIM  : Integer;


Procedure InitIncidenceCube(Var c:IncidenceCube; const Size:Integer);
var i, j, k : integer;
begin
DIM := Size;
SetLength(c,DIM,DIM,DIM);
for i := 0 to DIM-1 do
for j := 0 to DIM-1 do
for k := 0 to DIM-1 do c[i,j,k] := 0 ;

for i := 0 to DIM-1 do
for j := 0 to DIM-1 do c[i,j,(i+j) mod DIM] := 1;
end;


Procedure FreeIncidenceCube(Var c:IncidenceCube);
begin
Finalize(c);
end;


procedure PrintIncidenceCube(var c:IncidenceCube);
var i, j, k : integer;
begin
    for i := 0 to DIM-1 do begin
        for j := 0 to DIM-1 do begin
            for k := 0 to DIM-1 do begin
                if (c[i,j,k]=1) then begin
                    write(Alpha[k+1],' ');
                    break;
                end;
            end;
        end;
        Writeln;
    end;
    Writeln;
	WriteLn;
end;


procedure ShuffleIncidenceCube(var c:IncidenceCube);
var i, j, rx, ry, rz, ox, oy, oz : integer;
begin

    for i := 0 to (DIM*DIM*DIM)-1 do begin

        repeat
            rx := Random(DIM);
            ry := Random(DIM);
            rz := Random(DIM);
        until (c[rx,ry,rz]=0);

        for j := 0 to DIM-1 do begin
            if (c[j,ry,rz]=1) then ox := j;
            if (c[rx,j,rz]=1) then oy := j;
            if (c[rx,ry,j]=1) then oz := j;
        end;

        Inc(c[rx,ry,rz]);
        Inc(c[rx,oy,oz]);
        Inc(c[ox,ry,oz]);
        Inc(c[ox,oy,rz]);

        Dec(c[rx,ry,oz]);
        Dec(c[rx,oy,rz]);
        Dec(c[ox,ry,rz]);
        Dec(c[ox,oy,oz]);

        while (c[ox,oy,oz] < 0) do begin

            rx := ox ;
            ry := oy ;
            rz := oz ;

            if (random(2)=0) then begin
                for j := 0 to DIM-1 do begin
                    if (c[j,ry,rz]=1) then ox := j;
                end;
            end else begin
                for j := DIM-1 downto 0 do begin
                    if (c[j,ry,rz]=1) then ox := j;
                end;
            end;

            if (random(2)=0) then begin
                for j := 0 to DIM-1 do begin
                    if (c[rx,j,rz]=1) then oy := j;
                end;
            end else begin
                for j := DIM-1 downto 0 do begin
                    if (c[rx,j,rz]=1) then oy := j;
                end;
            end;

            if (random(2)=0) then begin
                for j := 0 to DIM-1 do begin
                    if (c[rx,ry,j]=1) then oz := j;
                end;
            end else begin
                for j := DIM-1 downto 0 do begin
                    if (c[rx,ry,j]=1) then oz := j;
                end;
            end;

            Inc(c[rx,ry,rz]);
            Inc(c[rx,oy,oz]);
            Inc(c[ox,ry,oz]);
            Inc(c[ox,oy,rz]);

            Dec(c[rx,ry,oz]);
            Dec(c[rx,oy,rz]);
            Dec(c[ox,ry,rz]);
            Dec(c[ox,oy,oz]);
        end;

    end;
end;

begin
    Randomize;
    InitIncidenceCube(cube, 5); ShuffleIncidenceCube(cube); PrintIncidenceCube(cube); FreeIncidenceCube(Cube);
    InitIncidenceCube(cube, 5); ShuffleIncidenceCube(cube); PrintIncidenceCube(cube); FreeIncidenceCube(Cube);
    InitIncidenceCube(cube,10); ShuffleIncidenceCube(cube); PrintIncidenceCube(cube); FreeIncidenceCube(Cube);	
    InitIncidenceCube(cube,26); ShuffleIncidenceCube(cube); PrintIncidenceCube(cube); FreeIncidenceCube(Cube);
end.
