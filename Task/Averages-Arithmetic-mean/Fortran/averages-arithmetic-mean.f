real, target, dimension(100) :: a = (/ (i, i=1, 100) /)
real, dimension(5,20) :: b = reshape( a, (/ 5,20 /) )
real, pointer, dimension(:) :: p => a(2:1)       ! pointer to zero-length array
real :: mean, zmean, bmean
real, dimension(20) :: colmeans
real, dimension(5) :: rowmeans

mean = sum(a)/size(a)                ! SUM of A's elements divided by SIZE of A
mean = sum(a)/max(size(a),1)         ! Same result, but safer code
                                     ! MAX of SIZE and 1 prevents divide by zero if SIZE == 0 (zero-length array)

zmean = sum(p)/max(size(p),1)        ! Here the safety check pays off. Since P is a zero-length array,
                                     ! expression becomes "0 / MAX( 0, 1 ) -> 0 / 1 -> 0", rather than "0 / 0 -> NaN"

bmean = sum(b)/max(size(b),1)        ! multidimensional SUM over multidimensional SIZE

rowmeans = sum(b,1)/max(size(b,2),1) ! SUM elements in each row (dimension 1)
                                     ! dividing by the length of the row, which is the number of columns (SIZE of dimension 2)
colmeans = sum(b,2)/max(size(b,1),1) ! SUM elements in each column (dimension 2)
                                     ! dividing by the length of the column, which is the number of rows (SIZE of dimension 1)
