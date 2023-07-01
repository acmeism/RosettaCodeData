# RREF
# assume input is a rectangular numeric matrix
def toReducedRowEchelonForm:
  length as $nr
  | (.[0]|length) as $nc
  | { lead: 0, r: -1, a: .}
  | until ($nc == .lead or .r == $nr;
      .r += 1
      | .r as $r
      | .i = $r
      | until ($nc == .lead or .a[.i][.lead] != 0;
          .i += 1
          | if $nr == .i
            then .i = $r
            | .lead += 1
            else .
            end )
      | if $nc > .lead and $nr > $r
        then .i as $i
        | .a |= array_swap($i; $r)
        | .a[$r][.lead] as $div
        | if $div != 0
          then .a[$r] |= map(. / $div)
          else .
          end
        | reduce range(0; $nr) as $k (.;
            if $k != $r
            then .a[$k][.lead] as $mult
            | .a[$k] = array_subtract(.a[$k]; (.a[$r] | map(. * $mult)))
            else .
            end )
        | .lead += 1
        else .
        end )
  | .a;

[   [ 1,  2,  -1,  -4],
    [ 2,  3,  -1, -11],
    [-2,  0,  -3,  22]  ],
[   [1, 2, -1, -4],
    [2, 4, -1, -11],
    [-2, 0, -6, 24] ]

| "Original:", matrix_print, "",
  "RREF:",  (toReducedRowEchelonForm|matrix_print), "\n"
