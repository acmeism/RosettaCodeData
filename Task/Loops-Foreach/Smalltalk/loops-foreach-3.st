(1 to:6 by:2) do:#displayNl.
'hello' do:#displayNl.
(Integer primesUpTo:100) do:#displayNl.
'/' asFilename directoryContents do:#displayNl.
((Smalltalk allClasses collect:#name) asSortedCollection to:2) do:#displayNl.

funnyClassLessObject := Plug new
                          respondTo:#do:
                          with:[:arg |
                             arg value:'look ma'.
                             arg value:'no classes needed'].
funnyClassLessObject do:#displayNl.
etc.
