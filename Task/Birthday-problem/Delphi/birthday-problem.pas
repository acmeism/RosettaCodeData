program Birthday_problem;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

const
  _DAYS = 365;

var
  days: array[0..(_DAYS) - 1] of Integer;
  runs: Integer;

function rand_day: Integer; inline;
begin
  Result := random(_DAYS);
end;

/// <summary>
///   given p people, if n of them have same birthday in one run
/// </summary>
function simulate1(p, n: Integer): Integer;
var
  index, i: Integer;
begin
  for i := 0 to High(days) do
  begin
    days[i] := 0;
  end;

  for i := 0 to p - 1 do
  begin
    index := rand_day();
    inc(days[index]);
    if days[index] = n then
      Exit(1);
  end;
  Exit(0);
end;

/// <summary>
///   decide if the probability of n out of np people sharing a birthday
///   is above or below p_thresh, with n_sigmas sigmas confidence
///   note that if p_thresh is very low or hi, minimum runs need to be much higher
/// </summary>
function prob(np, n: Integer; n_sigmas, p_thresh: Double; var d: Double): Double;
var
  p: Double;
  runs, yes: Integer;
begin
  runs := 0;
  yes := 0;

  repeat
    yes := yes + (simulate1(np, n));
    inc(runs);
    p := yes / runs;
    d := sqrt(p * (1 - p) / runs);
  until ((runs >= 10) and (abs(p - p_thresh) >= (n_sigmas * d)));

  Exit(p);
end;

/// <summary>
///   bisect for truth
/// </summary>
function find_half_chance(n: Integer; var p: Double; var d: Double): Integer;
var
  lo, hi, mid: Integer;
label
  reset;
begin
reset:
  lo := 0;
  hi := _DAYS * (n - 1) + 1;
  repeat
    mid := (hi + lo) div 2;

    p := prob(mid, n, 3, 0.5, d);
    if p < 0.5 then
      lo := mid + 1
    else
      hi := mid;
    if hi < lo then
      goto reset;

  until ((lo >= mid) and (p >= 0.5));
  Exit(mid);
end;

var
  n, np: Integer;
  p, d: Double;
begin
  Randomize;
  writeln('Wait for calculate');
  for n := 2 to 5 do
  begin
    np := find_half_chance(n, p, d);
    writeln(format('%d collision: %d people, P =  %.8f +/-  %.8f', [n, np, p, d]));
  end;
  writeln('Press enter to exit');
  readln;
end.
