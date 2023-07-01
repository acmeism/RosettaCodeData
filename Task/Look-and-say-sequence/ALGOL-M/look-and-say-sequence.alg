begin
    string(1) function digit(n);
    integer n;
    case n of begin
        digit := "0";   digit := "1";   digit := "2";
        digit := "3";   digit := "4";   digit := "5";
        digit := "6";   digit := "7";   digit := "8";
        digit := "9";
    end;

    string(1) array cur[1:128];
    string(1) array next[1:128];
    integer curlen, i, cnt, j, n;

    cur[1] := "1";
    curlen := 1;

    for n := 1 step 1 until 15 do begin
        write("");
        for i := 1 step 1 until curlen do
            writeon(cur[i]);

        i := j := 1;
        while i <= curlen do begin
            cnt := 1;
            while cur[i + cnt] = cur[i] do
                cnt := cnt + 1;
            next[j] := digit(cnt);
            next[j + 1] := cur[i];
            j := j + 2;
            i := i + cnt;
        end;

        for i := 1 step 1 until j-1 do
            cur[i] := next[i];

        curlen := j - 1;
    end;
end
