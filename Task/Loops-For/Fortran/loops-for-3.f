integer :: i
integer, dimension(10) :: v

forall (i=1:size(v)) v(i) = i
