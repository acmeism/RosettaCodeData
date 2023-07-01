USING: arrays kernel math math.vectors prettyprint ranges
sequences ;

20 [1..b] [ dup 2^ * 1 + ] map dup 2 v-n 2array simple-table.
