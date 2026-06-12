def count(s): reduce s as $x (null; .+1);

("aiou" | explode) as $disallow
| inputs
| . as $word
| explode
| select( all(.[]; . != $disallow[]) and
          count(.[] | select(. == 101)) > 3) # "e" is 101
| $word
