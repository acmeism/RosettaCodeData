NrQueens := function(n)
    local a, up, down, m, sub;
    a := [1 .. n];
    up := ListWithIdenticalEntries(2*n - 1, true);
    down := ListWithIdenticalEntries(2*n - 1, true);
    m := 0;
    sub := function(i)
        local j, k, p, q;
        for k in [i .. n] do
            j := a[k];
            p := i + j - 1;
            q := i - j + n;
            if up[p] and down[q] then
                if i = n then
                    m := m + 1;
                else
                    up[p] := false;
                    down[q] := false;
                    a[k] := a[i];
                    a[i] := j;
                    sub(i + 1);
                    up[p] := true;
                    down[q] := true;
                    a[i] := a[k];
                    a[k] := j;
                fi;
            fi;
        od;
    end;
    sub(1);
    return m;
end;

Queens := function(n)
    local a, up, down, v, sub;
    a := [1 .. n];
    up := ListWithIdenticalEntries(2*n - 1, true);
    down := ListWithIdenticalEntries(2*n - 1, true);
    v := [];
    sub := function(i)
        local j, k, p, q;
        for k in [i .. n] do
            j := a[k];
            p := i + j - 1;
            q := i - j + n;
            if up[p] and down[q] then
                if i = n then
                    Add(v, ShallowCopy(a));
                else
                    up[p] := false;
                    down[q] := false;
                    a[k] := a[i];
                    a[i] := j;
                    sub(i + 1);
                    up[p] := true;
                    down[q] := true;
                    a[i] := a[k];
                    a[k] := j;
                fi;
            fi;
        od;
    end;
    sub(1);
    return v;
end;

NrQueens(8);
a := Queens(8);;
PrintArray(PermutationMat(PermList(a[1]), 8));

[ [  1,  0,  0,  0,  0,  0,  0,  0 ],
  [  0,  0,  0,  0,  1,  0,  0,  0 ],
  [  0,  0,  0,  0,  0,  0,  0,  1 ],
  [  0,  0,  0,  0,  0,  1,  0,  0 ],
  [  0,  0,  1,  0,  0,  0,  0,  0 ],
  [  0,  0,  0,  0,  0,  0,  1,  0 ],
  [  0,  1,  0,  0,  0,  0,  0,  0 ],
  [  0,  0,  0,  1,  0,  0,  0,  0 ] ]
