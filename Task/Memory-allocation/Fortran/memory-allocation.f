program allocation_test

 implicit none

 real,dimension(:),allocatable :: vector
 real,dimension(:,:),allocatable :: matrix

 integer,parameter :: n = 100 !size to allocate

 allocate(vector(n))   !allocate a vector
 allocate(matrix(n,n)) !allocate a matrix
 deallocate(vector)    !deallocate a vector
 deallocate(matrix)    !deallocate a matrix

end program allocation_test
