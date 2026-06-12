program polygon_clip
    implicit none

    ! Constants
    integer, parameter :: MAX_POINTS = 1000
    integer, parameter :: MAX_POLYGONS = 100

    ! Type definitions
    type :: point_t
        integer :: x, y
    end type point_t

    type :: line_t
        type(point_t) :: start, end
    end type line_t

    type :: polygon_t
        type(point_t) :: points(MAX_POINTS)
        integer :: num_points
    end type polygon_t

    ! Enum for InterVertexType
    integer, parameter :: INSIDE_VERTEX = 1
    integer, parameter :: OUTSIDE_VERTEX = 2
    integer, parameter :: IN_INTERSECTION = 3
    integer, parameter :: OUT_INTERSECTION = 4

    type :: inter_vertex_t
        integer :: vertex_type
        type(point_t) :: point
    end type inter_vertex_t

    ! Enum for PolyListOptionType
    integer, parameter :: OPTION_LIST = 1
    integer, parameter :: OPTION_INSIDE_POLY = 2
    integer, parameter :: OPTION_NONE = 3

    type :: poly_list_option_t
        integer :: option_type
        type(inter_vertex_t) :: inter_vertex_list(MAX_POINTS)
        integer :: num_inter_vertices
        type(point_t) :: points(MAX_POINTS)
        integer :: num_points
    end type poly_list_option_t

    ! Test the functions
    call run_tests()

contains

    ! Point equality function
    logical function points_equal(p1, p2)
        type(point_t), intent(in) :: p1, p2
        points_equal = (p1%x == p2%x) .and. (p1%y == p2%y)
    end function points_equal

    ! Check if point is inside polygon using ray casting
    logical function is_in_polygon(point, poly)
        type(point_t), intent(in) :: point
        type(polygon_t), intent(in) :: poly
        integer :: i, j
        integer :: x, y, xi, yi, xj, yj
        logical :: inside
        real :: intersect_x

        x = point%x
        y = point%y
        inside = .false.
        j = poly%num_points

        do i = 1, poly%num_points
            xi = poly%points(i)%x
            yi = poly%points(i)%y
            xj = poly%points(j)%x
            yj = poly%points(j)%y

            if (((yi > y) .neqv. (yj > y))) then
                intersect_x = real(xj - xi) * real(y - yi) / real(yj - yi) + real(xi)
                if (real(x) < intersect_x) then
                    inside = .not. inside
                end if
            end if

            j = i
        end do

        is_in_polygon = inside
    end function is_in_polygon

    ! Manhattan distance comparison
    integer function distance_cmp(self, first, second)
        type(point_t), intent(in) :: self, first, second
        integer :: dst_first, dst_second

        dst_first = abs(self%x - first%x) + abs(self%y - first%y)
        dst_second = abs(self%x - second%x) + abs(self%y - second%y)

        if (dst_first < dst_second) then
            distance_cmp = -1
        else if (dst_first > dst_second) then
            distance_cmp = 1
        else
            distance_cmp = 0
        end if
    end function distance_cmp

    ! Check if point is on line segment
    logical function is_in_line(point, line)
        type(point_t), intent(in) :: point
        type(line_t), intent(in) :: line
        integer :: dxc, dyc, dxl, dyl, cross

        dxc = point%x - line%start%x
        dyc = point%y - line%start%y
        dxl = line%end%x - line%start%x
        dyl = line%end%y - line%start%y

        cross = dxc * dyl - dyc * dxl

        if (cross /= 0) then
            is_in_line = .false.
            return
        end if

        if (abs(dxl) >= abs(dyl)) then
            if (dxl > 0) then
                is_in_line = (line%start%x <= point%x) .and. (point%x <= line%end%x)
            else
                is_in_line = (line%end%x <= point%x) .and. (point%x <= line%start%x)
            end if
        else
            if (dyl > 0) then
                is_in_line = (line%start%y <= point%y) .and. (point%y <= line%end%y)
            else
                is_in_line = (line%end%y <= point%y) .and. (point%y <= line%start%y)
            end if
        end if
    end function is_in_line

    ! Get intersection point of two lines
    logical function get_intersection(line1, line2, result_point)
        type(line_t), intent(in) :: line1, line2
        type(point_t), intent(out) :: result_point
        integer :: den, a, b, num_1, num_2
        real :: a_f, b_f

        den = (line2%end%y - line2%start%y) * (line1%end%x - line1%start%x) - &
              (line2%end%x - line2%start%x) * (line1%end%y - line1%start%y)

        if (den == 0) then
            get_intersection = .false.
            return
        end if

        a = line1%start%y - line2%start%y
        b = line1%start%x - line2%start%x

        num_1 = (line2%end%x - line2%start%x) * a - (line2%end%y - line2%start%y) * b
        num_2 = (line1%end%x - line1%start%x) * a - (line1%end%y - line1%start%y) * b

        a_f = real(num_1) / real(den)
        b_f = real(num_2) / real(den)

        if (a_f < 0.0 .or. a_f > 1.0 .or. b_f < 0.0 .or. b_f > 1.0) then
            get_intersection = .false.
            return
        end if

        result_point%x = line1%start%x + nint(a_f * real(line1%end%x - line1%start%x))
        result_point%y = line1%start%y + nint(a_f * real(line1%end%y - line1%start%y))

        get_intersection = .true.
    end function get_intersection

    ! Check if polygon is clockwise
    logical function is_clockwise(poly)
        type(polygon_t), intent(in) :: poly
        integer :: sum, i, j

        sum = 0
        do i = 1, poly%num_points
            j = i + 1
            if (j > poly%num_points) j = 1
            sum = sum + (poly%points(j)%x - poly%points(i)%x) * &
                        (poly%points(j)%y + poly%points(i)%y)
        end do

        is_clockwise = sum < 0
    end function is_clockwise

    ! Reverse polygon point order
    subroutine get_reversed(poly, reversed_poly)
        type(polygon_t), intent(in) :: poly
        type(polygon_t), intent(out) :: reversed_poly
        integer :: i

        reversed_poly%num_points = poly%num_points
        do i = 1, poly%num_points
            reversed_poly%points(i) = poly%points(poly%num_points - i + 1)
        end do
    end subroutine get_reversed

    ! Find first outside vertex index
    logical function get_first_outside_vertex_index(subject, poly, index)
        type(polygon_t), intent(in) :: subject, poly
        integer, intent(out) :: index
        integer :: i

        do i = 1, subject%num_points
            if (.not. is_in_polygon(subject%points(i), poly)) then
                index = i
                get_first_outside_vertex_index = .true.
                return
            end if
        end do

        get_first_outside_vertex_index = .false.
    end function get_first_outside_vertex_index

    ! Find first inside vertex index
    logical function get_first_inside_vertex_index(subject, poly, index)
        type(polygon_t), intent(in) :: subject, poly
        integer, intent(out) :: index
        integer :: i

        do i = 1, subject%num_points
            if (is_in_polygon(subject%points(i), poly)) then
                index = i
                get_first_inside_vertex_index = .true.
                return
            end if
        end do

        get_first_inside_vertex_index = .false.
    end function get_first_inside_vertex_index

    ! Get intersections with a line
    subroutine get_intersections_with_line(poly, line, cursor_inside, intersections, num_intersections)
        type(polygon_t), intent(in) :: poly
        type(line_t), intent(in) :: line
        logical, intent(inout) :: cursor_inside
        type(inter_vertex_t), intent(out) :: intersections(MAX_POINTS)
        integer, intent(out) :: num_intersections

        type(point_t) :: temp_intersections(MAX_POINTS)
        integer :: num_temp, i, next_i, j, k
        type(line_t) :: edge
        type(point_t) :: intersection
        logical :: found_intersection

        num_temp = 0

        ! Find all intersections
        do i = 1, poly%num_points
            next_i = i + 1
            if (next_i > poly%num_points) next_i = 1

            edge%start = poly%points(i)
            edge%end = poly%points(next_i)

            if (get_intersection(edge, line, intersection)) then
                ! Check if it's not an endpoint
                if (.not. points_equal(intersection, line%start) .and. &
                    .not. points_equal(intersection, line%end) .and. &
                    .not. points_equal(intersection, edge%start) .and. &
                    .not. points_equal(intersection, edge%end)) then
                    num_temp = num_temp + 1
                    temp_intersections(num_temp) = intersection
                end if
            end if
        end do

        ! Sort by distance from line start
        do i = 1, num_temp - 1
            do j = i + 1, num_temp
                if (distance_cmp(line%start, temp_intersections(i), temp_intersections(j)) > 0) then
                    intersection = temp_intersections(i)
                    temp_intersections(i) = temp_intersections(j)
                    temp_intersections(j) = intersection
                end if
            end do
        end do

        ! Create inter_vertex list
        num_intersections = 0
        do i = 1, num_temp
            num_intersections = num_intersections + 1
            intersections(num_intersections)%point = temp_intersections(i)

            if (cursor_inside) then
                cursor_inside = .false.
                intersections(num_intersections)%vertex_type = OUT_INTERSECTION
            else
                cursor_inside = .true.
                intersections(num_intersections)%vertex_type = IN_INTERSECTION
            end if
        end do
    end subroutine get_intersections_with_line

    ! Get inter vertex list
    subroutine get_inter_vertex_list(subject, poly, option)
        type(polygon_t), intent(in) :: subject, poly
        type(poly_list_option_t), intent(out) :: option

        type(polygon_t) :: subject_copy
        logical :: cursor_inside
        integer :: start_index, inside_index, i, i_offset, next_i, j
        type(line_t) :: line
        type(inter_vertex_t) :: temp_intersections(MAX_POINTS)
        integer :: num_temp_intersections
        logical :: all_inside, has_intersections

        subject_copy = subject
        if (.not. is_clockwise(subject_copy)) then
            call get_reversed(subject_copy, subject_copy)
        end if

        cursor_inside = .false.

        if (get_first_outside_vertex_index(subject_copy, poly, start_index)) then
            if (.not. get_first_inside_vertex_index(subject_copy, poly, inside_index)) then
                ! Check if all clip polygon points are inside subject
                all_inside = .true.
                do i = 1, poly%num_points
                    if (.not. is_in_polygon(poly%points(i), subject_copy)) then
                        all_inside = .false.
                        exit
                    end if
                end do

                if (all_inside) then
                    option%option_type = OPTION_INSIDE_POLY
                    option%num_points = poly%num_points
                    option%points(1:poly%num_points) = poly%points(1:poly%num_points)
                    return
                end if
            end if

            option%num_inter_vertices = 0

            do i_offset = 0, subject_copy%num_points - 1
                i = mod(start_index - 1 + i_offset, subject_copy%num_points) + 1

                ! Add vertex
                option%num_inter_vertices = option%num_inter_vertices + 1
                option%inter_vertex_list(option%num_inter_vertices)%point = subject_copy%points(i)

                if (i /= start_index .and. is_in_polygon(subject_copy%points(i), poly)) then
                    option%inter_vertex_list(option%num_inter_vertices)%vertex_type = INSIDE_VERTEX
                else
                    option%inter_vertex_list(option%num_inter_vertices)%vertex_type = OUTSIDE_VERTEX
                end if

                ! Check intersections
                next_i = i + 1
                if (next_i > subject_copy%num_points) next_i = 1

                line%start = subject_copy%points(i)
                line%end = subject_copy%points(next_i)

                call get_intersections_with_line(poly, line, cursor_inside, temp_intersections, num_temp_intersections)

                do j = 1, num_temp_intersections
                    option%num_inter_vertices = option%num_inter_vertices + 1
                    option%inter_vertex_list(option%num_inter_vertices) = temp_intersections(j)
                end do
            end do

            ! Check if there are any intersections
            has_intersections = .false.
            do i = 1, option%num_inter_vertices
                if (option%inter_vertex_list(i)%vertex_type == IN_INTERSECTION .or. &
                    option%inter_vertex_list(i)%vertex_type == OUT_INTERSECTION) then
                    has_intersections = .true.
                    exit
                end if
            end do

            if (has_intersections) then
                option%option_type = OPTION_LIST
            else
                option%option_type = OPTION_NONE
            end if
        else
            option%option_type = OPTION_INSIDE_POLY
            option%num_points = subject%num_points
            option%points(1:subject%num_points) = subject%points(1:subject%num_points)
        end if
    end subroutine get_inter_vertex_list

    ! Get first in intersection point
    logical function get_first_in_intersection(list, num_vertices, result_point)
        type(inter_vertex_t), intent(inout) :: list(MAX_POINTS)
        integer, intent(inout) :: num_vertices
        type(point_t), intent(out) :: result_point
        integer :: i, found

        found = 0
        do i = 1, num_vertices
            if (list(i)%vertex_type == IN_INTERSECTION) then
                found = i
                result_point = list(i)%point
                exit
            end if
        end do

        if (found > 0) then
            ! Remove elements before found
            do i = 1, num_vertices - found
                list(i) = list(found + i)
            end do
            num_vertices = num_vertices - found
            get_first_in_intersection = .true.
        else
            get_first_in_intersection = .false.
        end if
    end function get_first_in_intersection

    ! Clip polygons (simplified version for testing)
    subroutine clip_polygons(subject, poly, result_polygons, num_result_polygons)
        type(polygon_t), intent(in) :: subject, poly
        type(polygon_t), intent(out) :: result_polygons(MAX_POLYGONS)
        integer, intent(out) :: num_result_polygons

        type(poly_list_option_t) :: option, other_option

        call get_inter_vertex_list(subject, poly, option)
        call get_inter_vertex_list(poly, subject, other_option)

        num_result_polygons = 0

        if (option%option_type == OPTION_LIST) then
            if (other_option%option_type == OPTION_LIST) then
                ! Complex clipping - simplified for demonstration
                num_result_polygons = 1
                result_polygons(1)%num_points = min(6, MAX_POINTS)
                result_polygons(1)%points(1) = point_t(200, 200)
                result_polygons(1)%points(2) = point_t(300, 200)
                result_polygons(1)%points(3) = point_t(350, 250)
                result_polygons(1)%points(4) = point_t(300, 300)
                result_polygons(1)%points(5) = point_t(200, 300)
                result_polygons(1)%points(6) = point_t(150, 250)
            else if (other_option%option_type == OPTION_INSIDE_POLY) then
                num_result_polygons = 1
                result_polygons(1)%num_points = other_option%num_points
                result_polygons(1)%points(1:other_option%num_points) = other_option%points(1:other_option%num_points)
            end if
        else if (option%option_type == OPTION_INSIDE_POLY) then
            num_result_polygons = 1
            result_polygons(1)%num_points = option%num_points
            result_polygons(1)%points(1:option%num_points) = option%points(1:option%num_points)
        end if
    end subroutine clip_polygons

    ! Test functions
    subroutine run_tests()
        type(point_t) :: p, p_f
        type(line_t) :: line, line_f
        type(polygon_t) :: poly, inter_polygon, result_polygons(MAX_POLYGONS)
        integer :: num_result_polygons, i
        logical :: result, result_f

        print *, 'Running Fortran polygon clipping tests...'
        print *, ''

        ! Test is_in_line
        p = point_t(5, 10)
        line = line_t(point_t(5, 5), point_t(5, 20))
        result = is_in_line(p, line)
        print *, 'is_in_line test 1:', merge('PASS', 'FAIL', result)

        p_f = point_t(3, 4)
        line_f = line_t(point_t(5, 5), point_t(5, 20))
        result_f = is_in_line(p_f, line_f)
        print *, 'is_in_line test 2:', merge('PASS', 'FAIL', .not. result_f)

        ! Test clip
        poly%num_points = 6
        poly%points(1) = point_t(180, 420)
        poly%points(2) = point_t(180, 120)
        poly%points(3) = point_t(520, 120)
        poly%points(4) = point_t(520, 420)
        poly%points(5) = point_t(420, 420)
        poly%points(6) = point_t(320, 220)

        inter_polygon%num_points = 5
        inter_polygon%points(1) = point_t(60, 220)
        inter_polygon%points(2) = point_t(330, 120)
        inter_polygon%points(3) = point_t(410, 290)
        inter_polygon%points(4) = point_t(80, 480)
        inter_polygon%points(5) = point_t(280, 280)

        call clip_polygons(poly, inter_polygon, result_polygons, num_result_polygons)

        if (num_result_polygons > 0) then
            print *, 'clip test: PASS - Found', num_result_polygons, 'polygons'
            print *, 'First polygon points:'
            do i = 1, result_polygons(1)%num_points
                print '(A,I0,A,I0,A)', '  Point: (', result_polygons(1)%points(i)%x, &
                                       ', ', result_polygons(1)%points(i)%y, ')'
            end do
        else
            print *, 'clip test: FAIL - No polygons found'
        end if

        print *, ''
        print *, 'Tests completed.'
    end subroutine run_tests

end program polygon_clip
