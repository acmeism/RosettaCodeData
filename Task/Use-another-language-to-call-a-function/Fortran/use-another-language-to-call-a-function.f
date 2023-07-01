!-----------------------------------------------------------------------
!Function
!-----------------------------------------------------------------------
function  fortran_query(data, length) result(answer) bind(c, name='Query')
   use, intrinsic  :: iso_c_binding, only: c_char, c_int, c_size_t, c_null_char
   implicit none
   character(len=1,kind=c_char), dimension(length),  intent(inout) ::  data
   integer(c_size_t), intent(inout) :: length
   integer(c_int) :: answer
   answer = 0
   if(length<10) return
   data = transfer("Here I am"//c_null_char, data)
   length = 10_c_size_t
   answer = 1
end function fortran_query
