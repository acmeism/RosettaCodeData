def duval:
  . as $s
  | def a($i): $s[$i:$i+1];
  length as $n
  | { i: 0, factorization: []}
  | until (.i >= $n;
       .j = .i + 1
       | .k = .i
       | until (.j >= $n or a(.k) > a(.j);
            if a(.k) < a(.j) then .k = .i else .k += 1 end
            | .j += 1 )
       | until (.i > .k;
            .factorization += [$s[.i: .i+.j-.k]]
            | .i += .j - .k ) )
  | .factorization ;

# Thue-Morse example
def m:
  reduce range(0; 7) as $i ( "0";
    . as $m0
    | gsub("0"; "a")
    | gsub("1"; "0")
    | gsub("a"; "1")
    | $m0 + .) ;

m | duval | join("\n")
