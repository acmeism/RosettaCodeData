   msg=: (<'is not in haystack')"_                  NB. not found message
   idxmissing=: #@[ I.@:= ]                         NB. indices of items not found
   fmtdata=: 8!:0@]                                 NB. format atoms as boxed strings
   findLastIndex=: ;:inv@(] ,. [ msg`idxmissing`fmtdata} i:)

   Haystack findLastIndex Needles                   NB. usage
Washington is not in haystack
Bush 7
