program fly
  !A program to print the "Old lady swallowed a fly" poem
  implicit none

  character(len=52), dimension(0:8,2) :: line
  integer :: i,j
  !Define Lines of Poem
  line(1,1) = 'fly'
  line(2,1) = 'spider'
  line(3,1) = 'bird'
  line(4,1) = 'cat'
  line(5,1) = 'dog'
  line(6,1) = 'goat'
  line(7,1) = 'cow'
  line(8,1) = 'horse'
  line(0,2) = "Perhaps she'll die."
  line(1,2) = "I don't know why she swallowed that fly."
  line(2,2) = "That wiggled and jiggled and tickled inside her."
  line(3,2) = "How absurd to swallow a bird."
  line(4,2) = "Imagine that. She swallowed a cat."
  line(5,2) = "What a hog to swallow a dog."
  line(6,2) = "She just opened her throat and swallowed that goat."
  line(7,2) = "I don't know how she swallowed that cow."
  line(8,2) = "She's dead of course."

  !List each verse
  verses:do i = 1,8
     write(*,*) 'There was an old lady who swallowed a '//trim(line(i,1))//"."
     write(*,*) trim(line(i,2))
     !List things swallowed
     swallowed:do j = i,2,-1
        write(*,*) "She swallowed the "//trim(line(j,1))//" to catch the "//trim(line(j-1,1))//","
     end do swallowed
     write(*,*)  trim(line(0,2))
     write(*,*)
  end do verses

end program fly
