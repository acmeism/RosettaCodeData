program levdistdemo(output);

const
  maxlen = 15;

type
  stringalpha = array [1 .. maxlen] of char;

  function min3(a, b, c: integer): integer;
  var
    min: integer;
  begin
    min := a;
    if b < min then
      min := b;
    if c < min then
      min := c;
    min3 := min;
  end;

  function levdist(s: stringalpha; m: integer;
                   t: stringalpha; n: integer): integer;
  var
    d: array [0 .. maxlen, 0 .. maxlen] of integer;
    i, j: integer;
  begin
    for i := 0 to m do
      d[i, 0] := i;
    for j := 0 to n do
      d[0, j] := j;
    for j := 1 to n do
      for i := 1 to m do
        if s[i] = t[j] then
          d[i, j] := d[i - 1, j - 1]
        else
          d[i, j] := min3(d[i - 1, j] + 1, d[i, j - 1] + 1,
            d[i - 1, j - 1] + 1);
    levdist := d[m, n];
  end;

  procedure writeresults(s1, s2: stringalpha);
  var
    n1, n2: integer;

    function purelen(s: stringalpha): integer;
      (* Returns length of s without trailing spaces *)
    var
      i: integer;
    begin
      i := maxlen;
      while (i > 0) and (s[i] = ' ') do
        i := i - 1;
      purelen := i;
    end;

    procedure writenchars(s: stringalpha; n: integer);
    var
      i: integer;
    begin
      for i := 1 to n do
        write(s[i]);
    end;

  begin
    n1 := purelen(s1);
    n2 := purelen(s2);
    write('The Levenshtein distance between "');
    writenchars(s1, n1);
    write('" and "');
    writenchars(s2, n2);
    (* Here the levdist function is called. *)
    writeln('" is: ', levdist(s1, n1, s2, n2): 1);
  end;

begin
  (* In string assignment, a string literal must have the same size
     as a string variable. So trailing spaces are needed, but they are not
     considered in calculating a distance. *)
  writeresults('kitten         ', 'sitting        ');
  writeresults('rosettacode    ', 'raisethysword  ');
end.
