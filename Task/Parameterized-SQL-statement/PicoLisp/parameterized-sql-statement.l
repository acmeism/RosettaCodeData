(for P (collect 'jerseyNum '+Players 99)
   (put!> P 'name "Smith, Steve")
   (put!> P 'score 42)
   (put!> P 'active T) )
