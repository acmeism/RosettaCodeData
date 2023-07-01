program ternarytests;
{$mode objfpc}
uses
  ternarylogic;
begin
  writeln(' a AND b');
  writeln('F':7,'U':7, 'T':7);
  writeln('F|',tFalse and tFalse:7,tFalse and tMaybe:7,tFalse and tTrue:7);
  writeln('U|',tMaybe and tFalse:7,tMaybe and tMaybe:7,tMaybe and tTrue:7);
  writeln('T|',tTrue and tFalse:7,tTrue and tMaybe:7,tTrue and tTrue:7);
  writeln;

  writeln(' a OR b');
  writeln('F':7,'U':7, 'T':7);
  writeln('F|',tFalse or tFalse:7,tFalse or tMaybe:7,tFalse or tTrue:7);
  writeln('U|',tMaybe or tFalse:7,tMaybe or tMaybe:7,tMaybe or tTrue:7);
  writeln('T|',tTrue or tFalse:7,tTrue or tMaybe:7,tTrue or tTrue:7);
  writeln;

  writeln(' NOT a');
  writeln('F|',not tFalse:7);
  writeln('U|',not tMaybe:7);
  writeln('T|',not tTrue:7);
  writeln;

  writeln(' a XOR b');
  writeln('F':7,'U':7, 'T':7);
  writeln('F|',tFalse xor tFalse:7,tFalse xor tMaybe:7,tFalse xor tTrue:7);
  writeln('U|',tMaybe xor tFalse:7,tMaybe xor tMaybe:7,tMaybe xor tTrue:7);
  writeln('T|',tTrue xor tFalse:7,tTrue xor tMaybe:7,tTrue xor tTrue:7);
  writeln;

  writeln('equality/equivalence and multiplication');
  writeln('F':7,'U':7, 'T':7);
  writeln('F|', tFalse * tFalse:7,tFalse * tMaybe:7, tFalse * tTrue:7);
  writeln('U|', tMaybe * tFalse:7,tMaybe * tMaybe:7,tMaybe * tTrue:7);
  writeln('T|', tTrue * tFalse:7, tTrue * tMaybe:7, tTrue * tTrue:7);
   writeln;

  writeln('IMP. a.k.a. IfThen -> not(a) or b');
  writeln('F':7,'U':7, 'T':7);
  writeln('T|',tTrue >< tTrue:7,tTrue >< tMaybe:7,tTrue >< tFalse:7);
  writeln('U|',tMaybe >< tTrue:7,tMaybe >< tMaybe:7,tMaybe >< tFalse:7);
  writeln('F|',tFalse >< tTrue:7, tFalse >< tMaybe:7,tFalse >< tFalse:7);
  writeln;
end.
