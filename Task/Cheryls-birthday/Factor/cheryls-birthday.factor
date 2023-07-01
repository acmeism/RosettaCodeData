USING: assocs calendar.english fry io kernel prettyprint
sequences sets.extras ;

: unique-by ( seq quot -- newseq )
    2dup map non-repeating '[ @ _ member? ] filter ; inline

ALIAS: day first
ALIAS: month second

{
    { 15 5 } { 16 5 } { 19 5 } { 17 6 } { 18 6 }
    { 14 7 } { 16 7 } { 14 8 } { 15 8 } { 17 8 }
}

! the month cannot have a unique day
dup [ day ] map non-repeating over extract-keys values
'[ month _ member? ] reject

! of the remaining dates, day must be unique
[ day ] unique-by

! of the remaining dates, month must be unique
[ month ] unique-by

! print a date that looks like { { 16 7 } }
first first2 month-name write bl .
