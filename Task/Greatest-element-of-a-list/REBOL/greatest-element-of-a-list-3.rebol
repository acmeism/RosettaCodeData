vect: #(i16! [1 2 9 2 4])
vect/maximum
;== 9
query vect 'max
;== 9
query vect [maximum minimum]
;== [maximum: 9 minimum: 1]
query vect [:maximum :minimum]
;== [9 1]
