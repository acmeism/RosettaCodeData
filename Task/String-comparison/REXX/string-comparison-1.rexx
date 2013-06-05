animal = 'dog'
if animal = 'cat'  then say animal "is lexically equal to cat"
if animal \= 'cat' then say animal "is not lexically equal cat"
if animal > 'cat'  then say animal "is lexically higher than cat"
if animal < 'cat'  then say animal "is lexically lower than cat"
if animal >= 'cat' then say animal "is not lexically lower than cat"
if animal <= 'cat' then say animal "is not lexically higher than cat"

                 /*The above comparative operators do not consider         */
                 /*leading and trailing whitespace when making comparisons.*/

if '  cat  ' = 'cat'  then say "this will print because whitespace is stripped"

                 /*To consider any whitespace in a comparison, */
                 /*we need to use strict comparative operators.*/

if '  cat  ' == 'cat'  then say "this will not print because comparison is strict"
