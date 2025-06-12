program bezier_intersections
    ! This program does not do any subdivision, but instead takes
    ! advantage of monotonicity.
    !
    ! It is possible for points accidentally to be counted twice, for
    ! instance if they lie right on an interval boundary. We will avoid
    ! that by the crude (but likely satisfactory) mechanism of requiring
    ! a minimum max norm between intersections.
    implicit none

    ! Constants
    integer, parameter :: max_intersections = 4
    integer, parameter :: max_start_interv = 4
    integer, parameter :: max_workload = 1000  ! Maximum size for workload stack
    double precision, parameter :: px0 = -1.0, px1 = 0.0, px2 = 1.0
    double precision, parameter :: py0 = 0.0, py1 = 10.0, py2 = 0.0
    double precision, parameter :: qx0 = 2.0, qx1 = -8.0, qx2 = 2.0
    double precision, parameter :: qy0 = 1.0, qy1 = 2.0, qy2 = 3.0
    double precision, parameter :: tol = 0.0000001
    double precision, parameter :: spacing = 100.0 * tol

    ! Variables
    logical :: px_has_extreme_pt, py_has_extreme_pt
    logical :: qx_has_extreme_pt, qy_has_extreme_pt
    double precision :: px_extreme_pt, py_extreme_pt
    double precision :: qx_extreme, qy_extreme
    integer :: p_num_start_interv, q_num_start_interv
    double precision :: p_start_interv(max_start_interv)
    double precision :: q_start_interv(max_start_interv)
    double precision :: workload(4, max_workload)  ! tp0, tp1, tq0, tq1
    integer :: workload_size
    integer :: num_intersections
    double precision :: intersections_x(max_intersections)
    double precision :: intersections_y(max_intersections)
    integer :: i, j, k
    double precision :: tp0, tp1, tq0, tq1
    double precision :: xp0, xp1, xq0, xq1
    double precision :: yp0, yp1, yq0, yq1
    logical :: exclude, accept
    double precision :: x, y
    double precision :: tp_middle, tq_middle

! Main program logic
    ! Find monotonic sections of the curves, and use those as the
    ! starting jobs.
    p_num_start_interv = 2
    p_start_interv(1) = 0.0
    p_start_interv(2) = 1.0
    call possibly_insert_extreme_point(px0, px1, px2, p_num_start_interv, p_start_interv)
    call possibly_insert_extreme_point(py0, py1, py2, p_num_start_interv, p_start_interv)
    q_num_start_interv = 2
    q_start_interv(1) = 0.0
    q_start_interv(2) = 1.0
    call possibly_insert_extreme_point(qx0, qx1, qx2, q_num_start_interv, q_start_interv)
    call possibly_insert_extreme_point(qy0, qy1, qy2, q_num_start_interv, q_start_interv)

    workload_size = 0
    do i = 2, p_num_start_interv
        do j = 2, q_num_start_interv
            call defer_work(p_start_interv(i - 1), p_start_interv(i), &
                            q_start_interv(j - 1), q_start_interv(j))
        end do
    end do

    ! Go through the workload, deferring work as necessary.
    num_intersections = 0
    do while (.not. work_is_done())
        ! The following code recomputes values of the splines
        ! sometimes. You may wish to store such values in the work pile,
        ! to avoid recomputing them.
        call do_some_work(tp0, tp1, tq0, tq1)
        xp0 = schumaker_volk(px0, px1, px2, tp0)
        yp0 = schumaker_volk(py0, py1, py2, tp0)
        xp1 = schumaker_volk(px0, px1, px2, tp1)
        yp1 = schumaker_volk(py0, py1, py2, tp1)
        xq0 = schumaker_volk(qx0, qx1, qx2, tq0)
        yq0 = schumaker_volk(qy0, qy1, qy2, tq0)
        xq1 = schumaker_volk(qx0, qx1, qx2, tq1)
        yq1 = schumaker_volk(qy0, qy1, qy2, tq1)
        call test_intersection(xp0, xp1, yp0, yp1, xq0, xq1, yq0, yq1, tol, exclude, accept, x, y)
        if (accept) then
            call maybe_add_intersection(x, y, spacing)
        else if (.not. exclude) then
            tp_middle = 0.5 * (tp0 + tp1)
            tq_middle = 0.5 * (tq0 + tq1)
            call defer_work(tp0, tp_middle, tq0, tq_middle)
            call defer_work(tp0, tp_middle, tq_middle, tq1)
            call defer_work(tp_middle, tp1, tq0, tq_middle)
            call defer_work(tp_middle, tp1, tq_middle, tq1)
        end if
    end do

    if (num_intersections == 0) then
        print *, 'no intersections'
    else
        do k = 1, num_intersections
            write (*, '(A, F12.8, A, F12.8, A)') '(', intersections_x(k), ', ', intersections_y(k), ')'
        end do
    end if

contains

    ! Schumaker's and Volk's algorithm for evaluating a Bezier spline in
    ! Bernstein basis. This is faster than de Casteljau, though not quite
    ! as numerical stable.
    double precision function schumaker_volk(c0, c1, c2, t)
        double precision, intent(IN) :: c0, c1, c2, t
        double precision :: s, u, v
        s = 1.0 - t
        if (t <= 0.5) then
            ! Horner form in the variable u = t/s, taking into account the
            ! binomial coefficients = 1,2,1.
            u = t / s
            v = c0 + (u * (c1 + c1 + (u * c2)))
            ! Multiply by s raised to the degree of the spline.
            v = v * s * s
        else
            ! Horner form in the variable u = s/t, taking into account the
            ! binomial coefficients = 1,2,1.
            u = s / t
            v = c2 + (u * (c1 + c1 + (u * c0)))
            ! Multiply by t raised to the degree of the spline.
            v = v * t * t
        end if
        schumaker_volk = v
    end function schumaker_volk

    ! Find extreme point of a quadratic Bezier spline
    subroutine find_extreme_point(c0, c1, c2, lies_inside_01, extreme_point)
        double precision, intent(IN) :: c0, c1, c2
        logical, intent(OUT) :: lies_inside_01
        double precision, intent(OUT) :: extreme_point
        double precision :: numer, denom
        ! If the spline has c0=c2 but not c0=c1=c2, then treat it as having
        ! an extreme point at 0.5.
        if (c0 == c2 .and. c0 /= c1) then
            lies_inside_01 = .true.
            extreme_point = 0.5
        else
            ! Find the root of the derivative of the spline.
            lies_inside_01 = .false.
            numer = c0 - c1
            denom = c2 - c1 - c1 + c0
            if (denom /= 0.0 .and. numer * denom >= 0.0 .and. numer <= denom) then
                lies_inside_01 = .true.
                extreme_point = numer / denom
            end if
        end if
    end subroutine find_extreme_point

    ! Insert extreme point into start intervals if it lies in (0,1)
    subroutine possibly_insert_extreme_point(c0, c1, c2, num_start_interv, start_interv)
        double precision, intent(IN) :: c0, c1, c2
        integer, intent(INOUT) :: num_start_interv
        double precision, intent(INOUT) :: start_interv(max_start_interv)
        logical :: lies_inside_01
        double precision :: extreme_pt
        call find_extreme_point(c0, c1, c2, lies_inside_01, extreme_pt)
        if (lies_inside_01 .and. extreme_pt > 0.0 .and. extreme_pt < 1.0) then
            if (num_start_interv == 2) then
                start_interv(3) = 1.0
                start_interv(2) = extreme_pt
                num_start_interv = 3
            else if (extreme_pt < start_interv(2)) then
                start_interv(4) = 1.0
                start_interv(3) = start_interv(2)
                start_interv(2) = extreme_pt
                num_start_interv = 4
            else if (extreme_pt > start_interv(2)) then
                start_interv(4) = 1.0
                start_interv(3) = extreme_pt
                num_start_interv = 4
            end if
        end if
    end subroutine possibly_insert_extreme_point

    ! Minimum of two values
    double precision function minimum2(x, y)
        double precision, intent(IN) :: x, y
        minimum2 = min(x, y)
    end function minimum2

    ! Maximum of two values
    double precision function maximum2(x, y)
        double precision, intent(IN) :: x, y
        maximum2 = max(x, y)
    end function maximum2

    ! Check if two rectangles overlap
    logical function rectangles_overlap(xa0, ya0, xa1, ya1, xb0, yb0, xb1, yb1)
        double precision, intent(IN) :: xa0, ya0, xa1, ya1, xb0, yb0, xb1, yb1
        ! It is assumed that xa0<=xa1, ya0<=ya1, xb0<=xb1, and yb0<=yb1.
        rectangles_overlap = (xb0 <= xa1 .and. xa0 <= xb1 .and. yb0 <= ya1 .and. ya0 <= yb1)
    end function rectangles_overlap

    ! Test for intersection between two line segments
    subroutine test_intersection(xp0, xp1, yp0, yp1, xq0, xq1, yq0, yq1, tol, exclude, accept, x, y)
        double precision, intent(IN) :: xp0, xp1, yp0, yp1, xq0, xq1, yq0, yq1, tol
        logical, intent(OUT) :: exclude, accept
        double precision, intent(OUT) :: x, y
        double precision :: xpmin, ypmin, xpmax, ypmax
        double precision :: xqmin, yqmin, xqmax, yqmax
        double precision :: xmin, xmax, ymin, ymax
        xpmin = minimum2(xp0, xp1)
        ypmin = minimum2(yp0, yp1)
        xpmax = maximum2(xp0, xp1)
        ypmax = maximum2(yp0, yp1)
        xqmin = minimum2(xq0, xq1)
        yqmin = minimum2(yq0, yq1)
        xqmax = maximum2(xq0, xq1)
        yqmax = maximum2(yq0, yq1)
        exclude = .true.
        accept = .false.
        if (rectangles_overlap(xpmin, ypmin, xpmax, ypmax, xqmin, yqmin, xqmax, yqmax)) then
            exclude = .false.
            xmin = maximum2(xpmin, xqmin)
            xmax = minimum2(xpmax, xqmax)
            if (xmax < xmin) stop 'Assertion failed: xmax >= xmin'
            if (xmax - xmin <= tol) then
                ymin = maximum2(ypmin, yqmin)
                ymax = minimum2(ypmax, yqmax)
                if (ymax < ymin) stop 'Assertion failed: ymax >= ymin'
                if (ymax - ymin <= tol) then
                    accept = .true.
                    x = 0.5 * (xmin + xmax)
                    y = 0.5 * (ymin + ymax)
                end if
            end if
        end if
    end subroutine test_intersection

    ! Check if workload is empty
    logical function work_is_done()
        work_is_done = (workload_size == 0)
    end function work_is_done

    ! Add work to the workload stack
    subroutine defer_work(tp0, tp1, tq0, tq1)
        double precision, intent(IN) :: tp0, tp1, tq0, tq1
        if (workload_size >= max_workload) stop 'Error: Workload stack overflow'
        workload_size = workload_size + 1
        workload(1, workload_size) = tp0
        workload(2, workload_size) = tp1
        workload(3, workload_size) = tq0
        workload(4, workload_size) = tq1
    end subroutine defer_work

    ! Remove and return work from the workload stack
    subroutine do_some_work(tp0, tp1, tq0, tq1)
        double precision, intent(OUT) :: tp0, tp1, tq0, tq1
        if (work_is_done()) stop 'Assertion failed: Workload is empty'
        tp0 = workload(1, workload_size)
        tp1 = workload(2, workload_size)
        tq0 = workload(3, workload_size)
        tq1 = workload(4, workload_size)
        workload_size = workload_size - 1
    end subroutine do_some_work

    ! Add intersection point if it's not too close to existing ones
    subroutine maybe_add_intersection(x, y, spacing)
        double precision, intent(IN) :: x, y, spacing
        integer :: i
        logical :: too_close
        if (num_intersections == 0) then
            intersections_x(1) = x
            intersections_y(1) = y
            num_intersections = 1
        else
            too_close = .false.
            do i = 1, num_intersections
                if (abs(x - intersections_x(i)) < spacing .and. &
                    abs(y - intersections_y(i)) < spacing) then
                    too_close = .true.
                    exit
                end if
            end do
            if (.not. too_close) then
                if (num_intersections >= max_intersections) stop 'Too many intersections'
                num_intersections = num_intersections + 1
                intersections_x(num_intersections) = x
                intersections_y(num_intersections) = y
            end if
        end if
    end subroutine maybe_add_intersection

end program bezier_intersections
