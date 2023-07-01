program chi2test

    use gsl_mini_bind_m, only: p_value
    implicit none

    real :: dset1(5) = [199809., 200665., 199607., 200270., 199649.]
    real :: dset2(5) = [522573., 244456., 139979., 71531., 21461.]

    real :: dist, prob
    integer :: dof

    write (*, '(A)', advance='no') "Dataset 1:"
    write (*, '(5(F12.4,:,1x))') dset1

    dist = chisq(dset1)
    dof = size(dset1) - 1
    write (*, '(A,I4,A,F12.4)') 'dof: ', dof, '   chisq: ', dist
    prob = p_value(dist, dof)
    write (*, '(A,F12.4)') 'probability: ', prob
    write (*, '(A,L)') 'uniform? ', prob > 0.05

    ! Lazy copy/past :|
    write (*, '(/A)', advance='no') "Dataset 2:"
    write (*, '(5(F12.4,:,1x))') dset2

    dist = chisq(dset2)
    dof = size(dset2) - 1
    write (*, '(A,I4,A,F12.4)') 'dof: ', dof, '   chisq: ', dist
    prob = p_value(dist, dof)
    write (*, '(A,F12.4)') 'probability: ', prob
    write (*, '(A,L)') 'uniform? ', prob > 0.05

contains

    !> Get chi-square value for a set of data `ds`
    real function chisq(ds)
        real, intent(in) :: ds(:)

        real :: expected, summa

        expected = sum(ds)/size(ds)
        summa = sum((ds - expected)**2)
        chisq = summa/expected

    end function chisq

end program chi2test
