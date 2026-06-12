# jq -c -n -R -f quaternion.jq
Quaternion(1;0;0;0) => 1 + 0i + 0j + 0k
abs($q) => 5.477225575051661
negate($q) => -1 - 2i - 3j + -4k
conj($q) => 1 - 2i - 3j - 4k

plus($r; $q) => 8 + 2i + 3j + 4k
plus($q; $r) => 8 + 2i + 3j + 4k

plus($q1; $q2 ) => 5 + 7i + 9j + 11k

times($r;$q) => 7 + 14i + 21j + 28k
times($q;$r) => 7 + 14i + 21j + 28k

times($q1;$q2) => -56 + 16i + 24j + 26k
times($q2; $q1) => -56 + 18i + 20j + 28k
times($q1; $q2) != times($q2; $q1) => true
