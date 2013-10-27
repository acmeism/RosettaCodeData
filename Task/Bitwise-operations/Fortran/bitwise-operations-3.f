program    bits_rosetta
implicit none

 call bitwise(14,3)

 contains

subroutine bitwise(a,b)
implicit none
 integer, intent(in):: a,b
 character(len=*), parameter :: fmt1 = '(2(a,i10))'
 character(len=*),parameter :: fmt2 = '(3(a,b32.32),i20)'

write(*,fmt1) 'input a=',a,' b=',b
write(*,fmt2) 'and : ', a,' &  ',b,' = ',iand(a, b),iand(a, b)
write(*,fmt2) 'or  : ', a,' |  ',b,' = ',ior(a, b),ior(a, b)
write(*,fmt2) 'xor : ', a,' ^  ',b,' = ',ieor(a, b),ieor(a, b)
write(*,fmt2) 'lsh : ', a,' << ',b,' = ',ishft(a, abs(b)),ishft(a, abs(b))
write(*,fmt2) 'rsh : ', a,' >> ',b,' = ',ishft(a, -abs(b)),ishft(a, -abs(b))
write(*,fmt2) 'not : ', a,' ~  ',b,' = ',not(a),not(a)
write(*,fmt2) 'rot : ', a,' r  ',b,' = ',ishftc(a,-abs(b)),ishftc(a,-abs(b))

end subroutine bitwise

end program bits_rosetta
