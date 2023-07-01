   primes_less_than=: i.&.:(p:inv)
   assert 2 3 5 -: primes_less_than 7
   Primes=: primes_less_than 1e6

   NB. Insert minus `-/' into the length two infixes `\'.
   NB. Passive `~' swaps the arguments producing the positive differences.
   Successive_Differences=: 2 -~/\ Primes
   assert 8169 -: +/ 2 = Successive_Differences   NB. twin prime tally

   Groups=: 2 ; 1 ; 2 2 ; 2 4 ; 4 2 ; 6 4 2

   group_index=: [: I. E.
   end_groups=: Primes {~  ({. , {:)@] +/ 0,#\@[

   Header=: <;._2 'Group;Count;First/Last groups;'

   Header ,> Groups ([ ([ ; #@] ; end_groups) group_index)&.> <Successive_Differences
┌─────┬─────┬───────────────────────────┐
│Group│Count│First/Last groups          │
├─────┼─────┼───────────────────────────┤
│2    │8169 │     3      5              │
│     │     │999959 999961              │
├─────┼─────┼───────────────────────────┤
│1    │1    │2 3                        │
│     │     │2 3                        │
├─────┼─────┼───────────────────────────┤
│2 2  │1    │3 5 7                      │
│     │     │3 5 7                      │
├─────┼─────┼───────────────────────────┤
│2 4  │1393 │     5      7     11       │
│     │     │999431 999433 999437       │
├─────┼─────┼───────────────────────────┤
│4 2  │1444 │     7     11     13       │
│     │     │997807 997811 997813       │
├─────┼─────┼───────────────────────────┤
│6 4 2│306  │    31     37     41     43│
│     │     │997141 997147 997151 997153│
└─────┴─────┴───────────────────────────┘
