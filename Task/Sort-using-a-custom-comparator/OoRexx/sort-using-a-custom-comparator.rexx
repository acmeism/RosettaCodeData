A=.array~of('The seven deadly sins','Pride','avarice','Wrath','envy','gluttony','sloth','Lust')
say 'Sorted in order of descending length, and in ascending lexicographic order'
say A~sortWith(.DescLengthAscLexical~new)~makeString

::class DescLengthAscLexical mixinclass Comparator
::method compare
use strict arg left, right
if left~length==right~length
  then return left~caselessCompareTo(right)
  else return right~length-left~length
