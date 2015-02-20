constant ln2 = [+] (1/2.FatRat, */2 ... *) Z/ 1 .. 100;
constant h = [\*] 1/2, 1..* X/ ln2;

use Test;
plan *;

for h[1..17] {
    ok m/'.'<[09]>/, .round(0.001)
}
