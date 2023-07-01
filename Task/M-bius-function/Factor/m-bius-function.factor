USING: formatting grouping io math.extras math.ranges sequences ;

"First 199 terms of the Möbius sequence:" print
199 [1,b] [ mobius ] map " " prefix 20 group
[ [ "%3s" printf ] each nl ] each
