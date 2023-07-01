/*REXX program generates values for six core attributes for an RPG (Role Playing Game).*/
Do n=1 By 1 until m>=2 & tot>=75;
  slist=''
  tot=0
  m=0
  Do 6
    sum=0
    Do d=1 To 4;
      cast.d=random(1,6)
      sum=sum+cast.d
      End
    min=min(cast.1,cast.2,cast.3,cast.4)
    sum=sum-min
    slist=slist sum
    tot=tot+sum
    m=m+(sum>=15)
    end
  Say 'the total for' space(slist) 'is -->' tot', 'm' entries are >= 15.'
  end
Say 'Solution found with' n 'iterations'
