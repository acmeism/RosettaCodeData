cyc0=:3 :0
  c=. (#~ 1 < #@>)C./:/: y
  writes=. 0
  for_box. c do.
    inds=. >box
    v=. ({:inds) { y
    for_ind. inds do.
      writes=. writes+1
      t=. ind{ y
      y=. v ind} y
      v=. t
    end.
  end.
  smoutput (":writes),' writes'
  y
)
