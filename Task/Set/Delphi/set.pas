program Set_task;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Boost.Generics.Collection;

begin
  var s1 := TSet<Integer>.Create([1, 2, 3, 4, 5, 6]);
  var s2 := TSet<Integer>.Create([2, 5, 6, 3, 4, 8]);
  var s3 := TSet<Integer>.Create([1, 2, 5]);

  Writeln('S1 ', s1.ToString);
  Writeln('S2 ', s2.ToString);
  Writeln('S3 ', s3.ToString, #10);

  Writeln('4 is in S1? ', s1.Has(4));
  Writeln('S1 union S2 ', (s1 + S2).ToString);
  Writeln('S1 intersection S2 ', (s1 * S2).ToString);
  Writeln('S1 difference S2 ', (s1 - S2).ToString);
  Writeln('S3 is subset S2 ', s1.IsSubSet(s3));
  Writeln('S1 equality S2? ', s1 = s2);
  readln;
end.
