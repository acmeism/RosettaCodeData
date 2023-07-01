!a=./f && make $a && OMP_NUM_THREADS=2 $a
!gfortran -std=f2008 -Wall -fopenmp -ffree-form -fall-intrinsics -fimplicit-none f.f08 -o f

      module menu
      public :: selector
      contains

      function selector(title,options) result(choice)
      character(len=*),intent(in) :: title
      character(len=*),dimension(:),intent(in) :: options
      character(len=len(options)) :: choice
      integer :: i,ichoose,ios,n

      choice = ""

      n = size(options)
      if (n > 0) then
        do
          print "(a)",title
          print "(i8,"", "",a)",(i,options(i),i=1,n)
          read (*,fmt="(i8)",iostat=ios) ichoose

          if (ios == -1) exit ! EOF error
          if (ios /= 0) cycle ! other error
          if (ichoose < 1) cycle
          if (ichoose > n) cycle ! out-of-bounds

          choice = options(ichoose)
          exit
        end do
      end if
      end function selector
      end module menu

      program menu_demo
      use menu
      character(len=14),dimension(:),allocatable :: zero_items,fairytale
      character(len=len(zero_items)) :: s

      !! empty list demo
      allocate(zero_items(0))
      print "(a)","input items:",zero_items
      s = selector('Choose from the empty list',zero_items)
      print "(a)","returned:",s
      if (s == "") print "(a)","(an empty string)"

      !! Fairy tale demo
      allocate(fairytale(4))
      fairytale = (/'fee fie       ','huff and puff ', &
        'mirror mirror ','tick tock     '/)
      print "(a)","input items:",fairytale
      s = selector('Choose a fairy tale',fairytale)
      print "(a)","returned: ",s
      if (s == "") print "(a)","(an empty string)"

      end program menu_demo
