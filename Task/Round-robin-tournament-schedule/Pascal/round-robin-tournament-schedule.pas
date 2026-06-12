program RoundRobin;
(*
Rosetta Code: write list of matches in a round robin tournament.
Command line:
    RoundRobin number_of_players
*)
{$mode objfpc}{$H+}

uses SysUtils;

var
  nrPlayers, round : integer;
  n, m, c, j, k : integer;
  a : array of integer;

    // Write the matches in a round, formatting nicely
    procedure WriteRound();
    var
      t, u : integer;
    begin
      Write( 'Round', round:3, ': ');
      u := 0;
      for t := 0 to m - 2 do begin
        Write( '(', a[u]:2);  inc(u);
        Write( ' v', a[u]:3, ') ');  inc(u);
      end;
      Write( '(', a[u]:2); // u = n - 2
      if c > 0 then
        WriteLn( ' v', c:3, ')')
      else
        WriteLn( ' bye)');
    end;

begin
  if ParamCount < 1 then begin
    WriteLn( 'Number of players is required');
    exit;
  end;
  nrPlayers := SysUtils.StrToIntDef( ParamStr(1), -1);
               // if string can't be converted, nrPlayers := -1
  if (nrPlayers < 2) then begin
    WriteLn( 'Invalid number of players');
    exit;
  end;
  WriteLn( 'Round robin with ', nrPlayers, ' players');
  m := (nrPlayers + 1) div 2;
  n := 2*m;
  if Odd( nrPlayers) then c := 0  // dummy player, opponent gets a bye
                     else c := n; // genuine player
  SetLength( a, n);
  k := 0;
  for j := 0 to m - 2 do begin
    a[k] := m - j;  inc(k);
    a[k] := m + 1 + j;  inc(k);
  end;
  a[k] := 1;
  a[n - 1] := c; // a[n - 1] stays = c throughout
  round := 1;
  WriteRound();
  for round := 2 to n - 1 do begin
    for j := 0 to n - 2 do begin // increment all entries except a[n - 1]
      inc(a[j]);
      if a[j] = n then a[j] := 1; // wrap round if necessary
    end;
    WriteRound();
  end;
end.
