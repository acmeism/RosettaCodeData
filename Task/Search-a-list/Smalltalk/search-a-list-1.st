| haystack |
haystack := 'Zig,Zag,Wally,Ronald,Bush,Krusty,Charlie,Bush,Bozo' subStrings: $,.
{ 'Washington' . 'Bush' } do: [:word |
  |t|

  ((t := haystack indexOf: word) = 0)
          ifTrue: [ ('%1 is not in the haystack' % { word }) displayNl ]
          ifFalse: [
               |l|
               ('%1 is at index %2' % { word . t }) displayNl.
               l := ( (haystack size) - (haystack reverse indexOf: word) + 1 ).
               ( t = l ) ifFalse: [
                   ('last occurence of %1 is at index %2' %  { word . l }) displayNl ]
               ]
].
