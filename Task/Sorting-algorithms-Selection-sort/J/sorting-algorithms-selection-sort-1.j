selectionSort=: verb define
  data=. y
  for_xyz. y do.
    temp=. xyz_index }. data
    nvidx=. xyz_index + temp i. <./ temp
    data=. ((xyz_index, nvidx) { data) (nvidx, xyz_index) } data
  end.
  data
)
