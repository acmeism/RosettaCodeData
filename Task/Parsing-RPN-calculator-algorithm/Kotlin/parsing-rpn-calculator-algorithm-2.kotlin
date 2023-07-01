{calc 3 4 2 * 1 5 - 2 3 pow pow / +}
->
 3:
 4: 3
 2: 4 3
 *: 2 4 3
 1: 8 3
 5: 1 8 3
 -: 5 1 8 3
 2: -4 8 3
 3: 2 -4 8 3
 pow: 3 2 -4 8 3
 pow: 8 -4 8 3
 /: 65536 8 3
 +: 0.0001220703125 3
 -> 3.0001220703125

where

{def calc
 {def calc.r
  {lambda {:x :s}
   {if {empty? :x}
    then -> {car :s}
    else {car :x}: {disp :s}{br}
         {calc.r {cdr :x}
                 {if {unop? {car :x}}
                  then {cons {{car :x} {car :s}} {cdr :s}}
                  else {if {binop? {car :x}}
                  then {cons {{car :x} {car {cdr :s}} {car :s}} {cdr {cdr :s}}}
                  else {cons {car :x} :s}} }}}}}
 {lambda {:s}
  {calc.r {list :s} nil}}}

using the unop? & binop? functions to test unary and binary operators

{def unop?
 {lambda {:op}
  {or {W.equal? :op sqrt}       // n sqrt  sqrt(n)
      {W.equal? :op exp}        // n exp   exp(n)
      {W.equal? :op log}        // n log   log(n)
      {W.equal? :op cos}        // n cos   cos(n)
      ... and so                // ...
}}}

{def binop?
 {lambda {:op}
  {or {W.equal? :op +}          // m n +     m+n
      {W.equal? :op -}          // m n -     m-n
      {W.equal? :op *}          // m n *     m*n
      {W.equal? :op /}          // m n /     m/n
      {W.equal? :op %}          // m n %     m%n
      {W.equal? :op pow}        // m n pow   m^n
      ... and so on             // ...
}}}

and  the list, empty? and disp functions to create
a list from a string, test its emptynes and display it.

{def list
 {lambda {:s}
  {if {W.empty? {S.rest :s}}
   then {cons {S.first :s} nil}
   else {cons {S.first :s} {list {S.rest :s}}}}}}

{def empty?
 {lambda {:x}
  {W.equal? :x nil}}}

{def disp
 {lambda {:l}
  {if {empty? :l}
   then
   else {car :l} {disp {cdr :l}}}}}

Note that everything is exclusively built on 5 lambdatalk primitives:
- "cons, car, cdr", to create lists,
- "W.equal?" which test the equality between two words,
- and the "or" boolean function.
