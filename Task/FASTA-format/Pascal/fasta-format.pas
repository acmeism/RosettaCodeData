program FASTA_Format;
// FPC 3.0.2
var InF,
    OutF: Text;
    ch: char;
    First: Boolean=True;
    InDef: Boolean=False;

begin
  Assign(InF,'');
  Reset(InF);
  Assign(OutF,'');
  Rewrite(OutF);
  While Not Eof(InF) do
  begin
    Read(InF,ch);
    Case Ch of
      '>': begin
            if Not(First) then
              Write(OutF,#13#10)
            else
              First:=False;
            InDef:=true;
          end;
      #13: Begin
               if InDef then
               begin
                 InDef:=false;
                 Write(OutF,': ');
               end;
               Ch:=#0;
             end;
      #10: ch:=#0;
      else Write(OutF,Ch);
    end;
  end;
  Close(OutF);
  Close(InF);
end.
