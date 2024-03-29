cubes=: 3^~1+i.100 NB. first 100 cubes
triples=: /:~ ~. ,/ (+ , /:~@,)"0/~cubes NB. ordered pairs of cubes (each with their sum)
candidates=: ;({."#. <@(0&#`({.@{.(;,)<@}."1)@.(1<#))/. ])triples

NB. we just want the first 25 taxicab numbers
25{.(,.~ <@>:@i.@#) candidates
┌──┬──────┬────────────┬─────────────┐
│1 │1729  │1 1728      │729 1000     │
├──┼──────┼────────────┼─────────────┤
│2 │4104  │8 4096      │729 3375     │
├──┼──────┼────────────┼─────────────┤
│3 │13832 │8 13824     │5832 8000    │
├──┼──────┼────────────┼─────────────┤
│4 │20683 │1000 19683  │6859 13824   │
├──┼──────┼────────────┼─────────────┤
│5 │32832 │64 32768    │5832 27000   │
├──┼──────┼────────────┼─────────────┤
│6 │39312 │8 39304     │3375 35937   │
├──┼──────┼────────────┼─────────────┤
│7 │40033 │729 39304   │4096 35937   │
├──┼──────┼────────────┼─────────────┤
│8 │46683 │27 46656    │19683 27000  │
├──┼──────┼────────────┼─────────────┤
│9 │64232 │4913 59319  │17576 46656  │
├──┼──────┼────────────┼─────────────┤
│10│65728 │1728 64000  │29791 35937  │
├──┼──────┼────────────┼─────────────┤
│11│110656│64 110592   │46656 64000  │
├──┼──────┼────────────┼─────────────┤
│12│110808│216 110592  │19683 91125  │
├──┼──────┼────────────┼─────────────┤
│13│134379│1728 132651 │54872 79507  │
├──┼──────┼────────────┼─────────────┤
│14│149389│512 148877  │24389 125000 │
├──┼──────┼────────────┼─────────────┤
│15│165464│8000 157464 │54872 110592 │
├──┼──────┼────────────┼─────────────┤
│16│171288│4913 166375 │13824 157464 │
├──┼──────┼────────────┼─────────────┤
│17│195841│729 195112  │10648 185193 │
├──┼──────┼────────────┼─────────────┤
│18│216027│27 216000   │10648 205379 │
├──┼──────┼────────────┼─────────────┤
│19│216125│125 216000  │91125 125000 │
├──┼──────┼────────────┼─────────────┤
│20│262656│512 262144  │46656 216000 │
├──┼──────┼────────────┼─────────────┤
│21│314496│64 314432   │27000 287496 │
├──┼──────┼────────────┼─────────────┤
│22│320264│5832 314432 │32768 287496 │
├──┼──────┼────────────┼─────────────┤
│23│327763│27000 300763│132651 195112│
├──┼──────┼────────────┼─────────────┤
│24│373464│216 373248  │157464 216000│
├──┼──────┼────────────┼─────────────┤
│25│402597│74088 328509│175616 226981│
└──┴──────┴────────────┴─────────────┘
