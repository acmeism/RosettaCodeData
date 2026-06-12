program IdenticalStrings;
const
    LIMIT = 1000;
var
    n: Integer;

function BitLength(n: Integer): Integer;
    var count: Integer;
    begin
        count := 0;
        while n > 0 do
        begin
            n := n shr 1;
            count := count + 1;
        end;
        BitLength := count;
    end;

function Concat(n: Integer): Integer;
    begin
        Concat := n shl BitLength(n) or n;
    end;

procedure WriteBits(n: Integer);
    var bit: Integer;
    begin
        bit := 1 shl (BitLength(n)-1);
        while bit > 0 do
        begin
            if (bit and n) <> 0 then Write('1')
            else Write('0');
            bit := bit shr 1;
        end;
   end;

begin
   n := 1;
   while Concat(n) < LIMIT do
   begin
       Write(Concat(n));
       Write(': ');
       WriteBits(Concat(n));
       WriteLn;
       n := n + 1;
   end;
end.
