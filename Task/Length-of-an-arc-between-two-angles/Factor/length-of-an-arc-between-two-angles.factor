USING: kernel math math.constants math.trig prettyprint ;

: arc-length ( radius angle angle -- x )
    - abs deg>rad 2pi swap - * ;

10 10 120 arc-length .
