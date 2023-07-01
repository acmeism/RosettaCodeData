USING: math math.factorials prettyprint sequences ;
IN: rosetta-code.calculate-e

CONSTANT: terms 20

terms <iota> [ n! recip ] map-sum >float .
