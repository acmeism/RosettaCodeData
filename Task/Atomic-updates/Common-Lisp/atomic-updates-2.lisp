ATOMIC-UPDATES> (scenario)
#<SB-THREAD:THREAD "Anonymous thread" RUNNING {10058441D3}>
ATOMIC-UPDATES> (loop repeat 3 do (print-buckets) (sleep 1))
Buckets: #(8 4 12 17 12 10 5 10 9 10 4 11 4 15 16 20 11 8 4 10)
Sum: 200
Buckets: #(2 12 24 7 8 3 13 6 8 31 0 9 7 11 12 8 8 12 15 4)
Sum: 200
Buckets: #(1 2 3 3 2 8 33 23 0 8 4 11 24 2 3 5 32 8 2 26)
Sum: 200
NIL
