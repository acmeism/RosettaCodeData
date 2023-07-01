foreach d0 {1 2 3 4 5 6} {
  foreach d1 {1 2 3 4 5 6} {
    ...
      foreach dN {1 2 3 4 5 6} {
        dict incr sum [::tcl::mathop::+ $n $d0 $d1 ... $DN]
      }
    ...
  }
}
