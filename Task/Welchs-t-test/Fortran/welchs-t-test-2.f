subroutine welch_ttest(n1, x1, n2, x2, t, df, p)
    implicit none
    integer :: n1, n2
    double precision :: x1(n1), x2(n2)
    double precision :: m1, m2, v1, v2, t, df, p
    double precision :: dbetai

    m1 = sum(x1) / n1
    m2 = sum(x2) / n2
    v1 = sum((x1 - m1)**2) / (n1 - 1)
    v2 = sum((x2 - m2)**2) / (n2 - 1)
    t = (m1 - m2) / sqrt(v1 / n1 + v2 / n2)
    df = (v1 / n1 + v2 / n2)**2 / &
         (v1**2 / (n1**2 * (n1 - 1)) + v2**2 / (n2**2 * (n2 - 1)))
    p = dbetai(df / (t**2 + df), 0.5d0 * df, 0.5d0)
end subroutine

program pvalue
    implicit none
    double precision :: x(4) = [3d0, 4d0, 1d0, 2.1d0]
    double precision :: y(3) = [490.2d0, 340.0d0, 433.9d0]
    double precision :: t, df, p

    call welch_ttest(4, x, 3, y, t, df, p)
    print *, t, df, p
end program
