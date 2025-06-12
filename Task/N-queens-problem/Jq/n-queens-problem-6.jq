def queens(n):
    def q: . as $pl
        | $pl[4] as $r
        | $pl[3] as $cl | $cl[] | . as $c
        | ($r+$c | tostring) as $k0
        | ($r-$c | tostring) as $k1
        | def place:
            ($k0 | in($pl[1]) | not)
            and ($k1 | in($pl[2]) | not);
          select(place)
        | [$pl[0]+[$c], $pl[1]+{$k0:null},
            $pl[2]+{$k1:null}, $cl-[$c], $r+1];
    def pipeline(n):
        q | if n > 1 then pipeline(n-1) end;
    def toletter:
        "abcdefghijklmnopqrstuvwxyz"[.:.+1];
    def fund_solut(f):
        def inverse: . as $xl
            | reduce range(0; n) as $i
                ([]; .+[$xl | index($i)]);
        def variants:
            [., inverse] | map(., reverse)
            | map(., map(n-1-.))
            | map(map(toletter) | add);
        foreach f as $i
            ([null, {}]; .[1] as $ml
            | ($i | variants) as $nl
            | if all($nl[]; in($ml) | not) then
                [$i, ($ml | .[$nl[]]=null)]
              else
                [null, $ml] end;
            .[0])
        | select (. != null);
    fund_solut([[], {}, {}, [range(0; n)], 0]
        | pipeline(n) | .[0])
    | map(toletter) | to_entries
    | map(.value+(.key+1 | tostring)) | sort;
queens(8)
