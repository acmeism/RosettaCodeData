ensure2D=: ,:^:(1 = #@$)                 NB. if list make 1 row table
normalise=: ([: /:~ /:~"1)@ensure2D      NB. normalises list of ranges
merge=: ,:`(<.&{. , >.&{:)@.(>:/&{: |.)  NB. merge ranges x and y
consolidate=: (}.@] ,~ (merge {.)) ensure2D
