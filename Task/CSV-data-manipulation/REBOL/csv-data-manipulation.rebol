Rebol [
    title: "Rosetta code: CSV data manipulation"
    file:  %CSV_data_manipulation.r3
    url:   https://rosettacode.org/wiki/CSV_data_manipulation
]

write %test.csv {C1,C2,C3,C4,C5
1,5,9,13,17
2,6,10,14,18
3,7,11,15,19
4,8,12,16,20}                         ;; create a sample CSV file on disk

probe-csv: func [data][
    foreach row data [probe row]      ;; helper: print each parsed CSV row using probe
]

import csv                            ;; enable CSV codec for load/save of CSV files

data: load %test.csv                  ;; load CSV into a block of rows (row 1 is header)
print "^/Original:" probe-csv data    ;; show original data

;; Add SUM column:
append data/1 "SUM"                   ;; extend header with a new column "SUM"
foreach row next data [               ;; iterate over data rows (skip header)
    sum: 0
    forall row [                      ;; walk each cell in the row in place
        change row to integer! row/1  ;; convert current cell to integer (mutates row)
        sum: sum + row/1              ;; accumulate the running total
    ]
    append row sum                    ;; append the computed sum at the end of the row
]
print "^/Modified:" probe-csv data    ;; show data after adding the SUM column

save %new.csv data                    ;; save the modified data to a new CSV file
print "^/Reloaded:" probe-csv load %new.csv  ;; reload and display to verify persistence
