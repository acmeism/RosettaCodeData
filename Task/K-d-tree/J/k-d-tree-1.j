coclass 'kdnode'
  create=:3 :0
    Axis=: ({:$y)|<.2^.#y
    Mask=: Axis~:i.{:$y
    if. 3>#y do.
      Leaf=:1
      Points=: y
    else.
      Leaf=:0
      data=. y /: Axis|."1 y
      n=. <.-:#data
      Points=: ,:n{data
      Left=: conew&'kdnode' n{.data
      Right=: conew&'kdnode' (1+n)}.data
    end.
  )

  distance=: +/&.:*:@:-"1

  nearest=:3 :0
    _ 0 nearest y
  :
    n=.' ',~":N_base_=:N_base_+1
    dists=. Points distance y
    ndx=. (i. <./) dists
    nearest=. ndx { Points
    range=. ndx { dists
    if. Leaf do.
      range;nearest return.
    else.
      d0=. x <. range
      p0=. nearest
      if. d0=0 do. 0;y return. end.
      if. 0={./:Axis|."1 y,Points do.
        'dist pnt'=.d0 nearest__Left y
        if. dist > d0 do.
          d0;p0 return.
        end.
        if. dist < d0 do.
          if. dist > (Mask#pnt) distance Mask#,Points do.
            'dist2 pnt2'=. d0 nearest__Right y
            if. dist2 < dist do. dist2;pnt2 return. end.
          end.
        end.
      else.
        'dist pnt'=. d0 nearest__Right y
        if. dist > d0 do.
          d0;p0 return.
        end.
        if. dist < d0 do.
          if. dist > (Mask#pnt) distance Mask#,Points do.
            'dist2 pnt2'=. d0 nearest__Left y
            if. dist2 < dist do. dist2;pnt2 return. end.
          end.
        end.
      end.
    end.
    dist;pnt return.
  )

coclass 'kdtree'
  create=:3 :0
    root=: conew&'kdnode' y
  )
  nearest=:3 :0
    N_base_=:0
    'dist point'=. nearest__root y
    dist;N_base_;point
  )
