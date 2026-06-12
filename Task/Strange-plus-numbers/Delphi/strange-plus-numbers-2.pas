program StrangePlusNumbers;

const
    m = 18;

var
    pr: array [0..m] of Boolean;
    n, k, a, b: Integer;
    q: Boolean;

begin
    // prime sieve
    for n := 0 to m do
    begin
        q := n > 1;
        for k := 2 to n - 1 do
            if n mod k = 0 then q := False;
        pr[n] := q
    end;

    k := 0;
    for n := 101 to 499 do
    begin
        a := n div 10;  // first two digits
        b := n mod 100; // last two digits
        if pr[a div 10 + a mod 10] and
           pr[b div 10 + b mod 10] then
        begin
            Write(n);
            Inc(k);
            if k mod 10 = 0 then Writeln else Write(' ')
        end
    end
end.
