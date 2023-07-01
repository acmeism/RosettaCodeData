program TestTrialDiv;
{$IFDEF FPC}
  {$MODE DELPHI}{$Smartlink ON}
{$ELSE}
  {$APPLICATION CONSOLE}// for Delphi
{$ENDIF}
uses
  primtrial;
{ Test and display primes 0 .. 50 }
begin
  repeat
    write(actPrime,' ');
  until nextPrime > 50;
end.
