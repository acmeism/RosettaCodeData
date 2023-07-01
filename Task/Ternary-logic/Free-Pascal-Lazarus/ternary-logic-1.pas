{$mode objfpc}
unit ternarylogic;

interface
type
  { ternary type, balanced }
  trit = (tFalse=-1, tMaybe=0, tTrue=1);

 { ternary operators }

  { equivalence = multiplication }
  operator * (const a,b:trit):trit;
  operator and (const a,b:trit):trit;inline;
  operator or (const a,b:trit):trit;inline;
  operator not (const a:trit):trit;inline;
  operator xor (const a,b:trit):trit;
  { imp ==>}
  operator >< (const a,b:trit):trit;


implementation

  operator and (const a,b:trit):trit;inline;
    const lookupAnd:array[trit,trit] of trit =
                    ((tFalse,tFalse,tFalse),
                     (tFalse,tMaybe,tMaybe),
                     (tFalse,tMaybe,tTrue));
  begin
    Result:= LookupAnd[a,b];
  end;

  operator or (const a,b:trit):trit;inline;
    const lookupOr:array[trit,trit] of trit =
                   ((tFalse,tMaybe,tTrue),
                    (tMaybe,tMaybe,tTrue),
                    (tTrue,tTrue,tTrue));
  begin
    Result := LookUpOr[a,b];
  end;

  operator not (const a:trit):trit;inline;
    const LookupNot:array[trit] of trit =(tTrue,tMaybe,tFalse);
  begin
     Result:= LookUpNot[a];
  end;

  operator xor (const a,b:trit):trit;
    const LookupXor:array[trit,trit] of trit =
                    ((tFalse,tMaybe,tTrue),
                     (tMaybe,tMaybe,tMaybe),
                     (tTrue,tMaybe,tFalse));
  begin
    Result := LookupXor[a,b];
  end;

  operator * (const a,b:trit):trit;
  begin
    result := not (a xor b);
  end;

  { imp ==>}
  operator >< (const a,b:trit):trit;
  begin
     result := not(a) or b;
  end;
end.
