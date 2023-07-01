|=  [arr=(list @ud) x=@ud]
=/  lo=@ud  0
=/  hi=@ud  (dec (lent arr))
|-
?>  (lte lo hi)
=/  mid  (div (add lo hi) 2)
=/  val  (snag mid arr)
?:  (lth x val)  $(hi (dec mid))
?:  (gth x val)  $(lo +(mid))
mid
