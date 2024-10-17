program QuaternionTest;

{$APPTYPE CONSOLE}

uses
  Quaternions in 'Quaternions.pas';

var
  r : double;
  q, q1, q2 : TQuaternion;
begin
  r := 7;
  q  := q .Init(1, 2, 3, 4);
  q1 := q1.Init(2, 3, 4, 5);
  q2 := q2.Init(3, 4, 5, 6);

  writeln('q  = ', q.ToString);
  writeln('q1 = ', q1.ToString);
  writeln('q2 = ', q2.ToString);
  writeln('r  = ', r);
  writeln('Norm(q ) = ', q.Norm);
  writeln('Norm(q1) = ', q1.Norm);
  writeln('Norm(q2) = ', q2.Norm);
  writeln('-q = ', (-q).ToString);
  writeln('Conjugate q = ', q.Conjugate.ToString);
  writeln('q1 + q2 = ', (q1 + q2).ToString);
  writeln('q2 + q1 = ', (q2 + q1).ToString);
  writeln('q * r   = ', (q * r).ToString);
  writeln('r * q   = ', (r * q).ToString);
  writeln('q1 * q2 = ', (q1 * q2).ToString);
  writeln('q2 * q1 = ', (q2 * q1).ToString);
end.
