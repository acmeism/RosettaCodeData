        program mm
          real   , allocatable :: a(:,:),b(:,:)
          integer              :: l=5,m=6,n=4
          a = reshape([1:l*m],[l,m])
          b = reshape([1:m*n],[m,n])
          print'(<n>f15.7)',transpose(matmul(a,b))
        end program
