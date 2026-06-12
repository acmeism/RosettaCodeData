USING: kernel math math.combinatorics namespaces prettyprint
prettyprint.config ranges sequences ;

100 margin set

15 [
    dup [0..b] [ [0..b] [ nCk ] with map-sum ] with map .
] each-integer
