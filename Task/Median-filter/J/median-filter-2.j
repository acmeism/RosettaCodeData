median_filter =: dyad define
 win =. y -~ i. >: +: y
 height =. {: }: $ x
 width =. {. }: $ x
 h_indexes =. < @ (#~ >:&0 * <&height) @ (win&+)"0 i. height
 w_indexes =. < @ (#~ >:&0 * <&width) @ (win&+)"0 i. width
 sets =. w_indexes < @ ({&x) @ < @ ,"0 0/ h_indexes
 medians =. ({~ <. @ -: @ {. @ $) @ ({~ /: @: toGray) @ (,/) @ > sets
)
