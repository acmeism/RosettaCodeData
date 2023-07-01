def multipliers:
 [
    1, 3, 5, 7, 11, 3*5, 3*7, 3*11, 5*7, 5*11, 7*11, 3*5*7, 3*5*11, 3*7*11, 5*7*11, 3*5*7*11
 ];

# input should be a number
def squfof:
  def toi : floor | tostring | tonumber;
  . as $N
  | (($N|sqrt + 0.5)|toi) as $s
  | if ($s*$s == $N) then $s
    else label $out
    | {}
    | multipliers[] as $multiplier
    | ($N * $multiplier) as $D
        | .P = ($D|isqrt)
        | .Pprev = .P
        | .Pprev as $Po
        | .Qprev = 1
        | .Q = $D - $Po*$Po
        | (($s * 8)|isqrt) as $L
        | (3 * $L) as $B
        | .i = 2
        | .b = 0
        | .q = 0
        | .r = 0
	| .stop = false
        | until( (.i >= $B) or .stop;
            .b = idivide($Po + .P; .Q)
            | .P = .b * .Q - .P
            | .q = .Q
            | .Q = .Qprev + .b * (.Pprev - .P)

            | .r = (((.Q|isqrt) + 0.5)|toi)

            | if ((.i % 2) == 0 and (.r*.r) == .Q) then .stop = true
	      else
                .Qprev = .q
              | .Pprev = .P
              |  .i += 1
	      end )
        | if .i < $B
	  then
            .b = idivide($Po - .P; .r)
	    | .P = .b*.r + .P
            | .Pprev = .P
            | .Qprev = .r
            | .Q = idivide($D - .Pprev*.Pprev; .Qprev)
            | .i = 0
	    | .stop = false
            | until (.stop;
	        .b = idivide($Po + .P; .Q)
                | .Pprev = .P
                | .P = .b * .Q - .P
                | .q = .Q
                | .Q = .Qprev + .b * (.Pprev - .P)
                | .Qprev = .q
                | .i += 1
                | if (.P == .Pprev) then .stop = true else . end )
            | .r = gcd($N; .Qprev)
            | if .r != 1 and .r != $N then .r, break $out else empty end
          else empty
          end
    end
    // 0 ;

def examples: [
    "2501",
    "12851",
    "13289",
    "75301",
    "120787",
    "967009",
    "997417",
    "7091569",
    "13290059",
    "42854447",
    "223553581",
    "2027651281",
    "11111111111",
    "100895598169",
    "1002742628021",
    "60012462237239",
    "287129523414791",
    "9007199254740931",
    "11111111111111111",
    "314159265358979323",
    "384307168202281507",
    "419244183493398773",
    "658812288346769681",
    "922337203685477563",
    "1000000000000000127",
    "1152921505680588799",
    "1537228672809128917",
    "4611686018427387877"
];

"[Integer, Factor, Quotient]"
"---------------------------",
(examples[] as $example
  | ($example|tonumber) as $N
  | ($N | squfof) as $fact
  | if $fact == 0 then "fail"
    else idivide($N; $fact) as $quot
    | [$N, $fact, $quot]
    end
)
