program word_search_rosetta_complete
    implicit none

    integer, parameter :: GRID_SIZE = 10
    integer, parameter :: MAX_WORDS = 5000
    integer, parameter :: MAX_WORD_LEN = 20
    integer, parameter :: MIN_PLACED = 25

    character(len=1) :: grid(GRID_SIZE, GRID_SIZE)
    character(len=MAX_WORD_LEN) :: words(MAX_WORDS), original_words(MAX_WORDS)
    integer :: word_lens(MAX_WORDS), original_lens(MAX_WORDS)
    integer :: num_words
    integer :: length_limits(3:10)

    type :: word_placement
        character(len=MAX_WORD_LEN) :: word
        integer :: row, col
        integer :: dx, dy
    end type

    type(word_placement) :: placed(200), all_found(500)
    integer :: num_placed, num_found

    integer :: attempt

    call init_random_seed()
    call load_words(original_words, original_lens, num_words)
    print '(A,I0,A)', "Loaded ", num_words, " valid words"

    ! Try to create puzzle
    do attempt = 1, 10
        words = original_words
        word_lens = original_lens

        call create_puzzle(words, word_lens, num_words, grid, placed, num_placed)

        ! VB stops when we have 25+ words (success!)
        if (num_placed >= MIN_PLACED) then
            print '(A,I0)', "Success on attempt ", attempt

            ! Find ALL words embedded in the final grid
            call find_all_words(original_words, original_lens, num_words, grid, all_found, num_found)

            call print_results(grid, placed, num_placed, all_found, num_found)
            exit
        end if

        print '(A,I0,A,I0,A)', "Attempt ", attempt, " placed ", num_placed, " words, retrying..."
    end do

contains

    subroutine init_random_seed()
        integer :: seed_size, clock, i
        integer, allocatable :: seed(:)

        call random_seed(size=seed_size)
        allocate(seed(seed_size))
        call system_clock(count=clock)
        seed = clock + 37 * [(i, i=1, seed_size)]
        call random_seed(put=seed)
        deallocate(seed)
    end subroutine

    subroutine load_words(words, word_lens, num_words)
        character(len=*), intent(out) :: words(:)
        integer, intent(out) :: word_lens(:)
        integer, intent(out) :: num_words
        character(len=MAX_WORD_LEN) :: word
        integer :: ios, i
        logical :: valid

        num_words = 0

        open(10, file='unixdict.txt', status='old', action='read', iostat=ios)
        if (ios /= 0) then
            print *, "Error opening unixdict.txt"
            stop
        end if

        do
            read(10, '(A)', iostat=ios) word
            if (ios /= 0) exit

            word = trim(word)
            if (len_trim(word) <= 2 .or. len_trim(word) > 10) cycle

            valid = .true.
            do i = 1, len_trim(word)
                if (word(i:i) < 'a' .or. word(i:i) > 'z') then
                    valid = .false.
                    exit
                end if
            end do

            if (valid) then
                num_words = num_words + 1
                if (num_words > MAX_WORDS) exit
                words(num_words) = trim(word)
                word_lens(num_words) = len_trim(word)
            end if
        end do

        close(10)
    end subroutine

    subroutine shuffle_words(words, word_lens, num_words)
        character(len=*), intent(inout) :: words(:)
        integer, intent(inout) :: word_lens(:)
        integer, intent(in) :: num_words
        integer :: i, r, temp_len
        character(len=MAX_WORD_LEN) :: temp_word
        real :: rr

        do i = num_words, 2, -1
            call random_number(rr)
            r = int(rr * i) + 1

            temp_word = words(i)
            words(i) = words(r)
            words(r) = temp_word

            temp_len = word_lens(i)
            word_lens(i) = word_lens(r)
            word_lens(r) = temp_len
        end do
    end subroutine

    function count_spaces(grid) result(count)
        character(len=1), intent(in) :: grid(:,:)
        integer :: count, i, j

        count = 0
        do i = 1, GRID_SIZE
            do j = 1, GRID_SIZE
                if (grid(j, i) == ' ') count = count + 1
            end do
        end do
    end function

    subroutine create_puzzle(words, word_lens, num_words, grid, placed, num_placed)
        character(len=*), intent(inout) :: words(:)
        integer, intent(inout) :: word_lens(:)
        integer, intent(in) :: num_words
        character(len=1), intent(out) :: grid(:,:)
        type(word_placement), intent(out) :: placed(:)
        integer, intent(out) :: num_placed

        integer :: i
        real :: r

        ! Initialize grid
        grid = ' '
        num_placed = 0

        ! Pre-seed ROSETTACODE letters (VB strategy)
        call random_number(r)
        grid(int(r * 5) + 6, 1) = 'R'

        call random_number(r)
        grid(int(r * 9) + 2, 2) = 'O'

        call random_number(r)
        grid(int(r * 9) + 2, 3) = 'S'

        call random_number(r)
        grid(int(r * 9) + 2, 4) = 'E'

        grid(2, 5) = 'T'
        grid(10, 5) = 'T'

        call random_number(r)
        grid(int(r * 10) + 1, 6) = 'A'

        call random_number(r)
        grid(int(r * 10) + 1, 7) = 'C'

        call random_number(r)
        grid(int(r * 10) + 1, 8) = 'O'

        call random_number(r)
        grid(int(r * 10) + 1, 9) = 'D'

        call random_number(r)
        grid(int(r * 10) + 1, 10) = 'E'

        ! Set length limits (pack the grid EXTREMELY full like VB)
        length_limits(3) = 500   ! VB had 200 - go even higher
        length_limits(4) = 100
        length_limits(5) = 50
        length_limits(6) = 30
        length_limits(7) = 20
        length_limits(8) = 10
        length_limits(9) = 5
        length_limits(10) = 3

        ! Shuffle words
        call shuffle_words(words, word_lens, num_words)

        ! Place words systematically (VB strategy - FILL THE GRID!)
        do i = 1, num_words
            ! VB stops when grid is completely full
            if (count_spaces(grid) == 0) exit

            ! Check length limit
            if (word_lens(i) >= 3 .and. word_lens(i) <= 10) then
                if (length_limits(word_lens(i)) > 0) then
                    if (place_word_systematic(words(i), word_lens(i), grid, placed, num_placed)) then
                        length_limits(word_lens(i)) = length_limits(word_lens(i)) - 1
                    end if
                end if
            end if
        end do

        ! Fill remaining spaces with random lowercase
        call fill_remaining(grid)
    end subroutine

    logical function place_word_systematic(word, word_len, grid, placed, num_placed)
        character(len=*), intent(in) :: word
        integer, intent(in) :: word_len
        character(len=1), intent(inout) :: grid(:,:)
        type(word_placement), intent(inout) :: placed(:)
        integer, intent(inout) :: num_placed

        integer :: start_pos, test_num, spot, x, y, d, dir_test
        integer :: dx(0:7), dy(0:7)
        integer :: rdir, rdd
        real :: r

        ! Direction arrays
        dx = [1, 1, 0, -1, -1, -1, 0, 1]
        dy = [0, 1, 1, 1, 0, -1, -1, -1]

        place_word_systematic = .false.

        ! Random starting position
        call random_number(r)
        start_pos = int(r * 100)

        ! Random direction to traverse grid
        call random_number(r)
        if (r < 0.5) then
            rdir = -1
        else
            rdir = 1
        end if

        ! Try all 100 positions
        do test_num = 0, 99
            spot = mod(start_pos + test_num * rdir + 100, 100)
            y = spot / 10 + 1
            x = mod(spot, 10) + 1

            ! If first letter matches or space is empty
            if (grid(x, y) == word(1:1) .or. grid(x, y) == ' ' .or. &
                (grid(x, y) >= 'A' .and. grid(x, y) <= 'Z' .and. &
                 char(ichar(grid(x, y)) + 32) == word(1:1))) then

                ! Try all 8 directions
                call random_number(r)
                d = int(r * 8)
                call random_number(r)
                if (r < 0.5) then
                    rdd = -1
                else
                    rdd = 1
                end if

                do dir_test = 0, 7
                    d = mod(d + dir_test * rdd + 8, 8)

                    if (can_place_vb(word, word_len, x, y, dx(d), dy(d), grid)) then
                        call place_word_vb(word, word_len, x, y, dx(d), dy(d), grid)
                        num_placed = num_placed + 1
                        placed(num_placed)%word = trim(word)
                        placed(num_placed)%col = x
                        placed(num_placed)%row = y
                        placed(num_placed)%dx = dx(d)
                        placed(num_placed)%dy = dy(d)
                        place_word_systematic = .true.
                        return
                    end if
                end do
            end if
        end do
    end function

    logical function can_place_vb(word, word_len, x, y, dx, dy, grid)
        character(len=*), intent(in) :: word
        integer, intent(in) :: word_len, x, y, dx, dy
        character(len=1), intent(in) :: grid(:,:)

        integer :: i, cx, cy
        logical :: fills_something
        character(len=1) :: grid_char

        can_place_vb = .false.
        fills_something = .false.

        ! Check bounds
        do i = 0, word_len - 1
            cx = x + i * dx
            cy = y + i * dy
            if (cx < 1 .or. cx > GRID_SIZE .or. cy < 1 .or. cy > GRID_SIZE) return
        end do

        ! Check if can place and if fills at least one space
        do i = 0, word_len - 1
            cx = x + i * dx
            cy = y + i * dy
            grid_char = grid(cx, cy)

            if (grid_char == ' ') then
                fills_something = .true.
            else if (grid_char /= word(i+1:i+1)) then
                ! Allow uppercase match
                if (grid_char >= 'A' .and. grid_char <= 'Z') then
                    if (char(ichar(grid_char) + 32) /= word(i+1:i+1)) return
                else
                    return
                end if
            end if
        end do

        can_place_vb = fills_something
    end function

    subroutine place_word_vb(word, word_len, x, y, dx, dy, grid)
        character(len=*), intent(in) :: word
        integer, intent(in) :: word_len, x, y, dx, dy
        character(len=1), intent(inout) :: grid(:,:)

        integer :: i, cx, cy

        do i = 0, word_len - 1
            cx = x + i * dx
            cy = y + i * dy
            ! Only place lowercase if empty or already matches
            if (grid(cx, cy) == ' ' .or. grid(cx, cy) == word(i+1:i+1)) then
                grid(cx, cy) = word(i+1:i+1)
            end if
        end do
    end subroutine

    subroutine fill_remaining(grid)
        character(len=1), intent(inout) :: grid(:,:)
        integer :: i, j
        real :: r

        do i = 1, GRID_SIZE
            do j = 1, GRID_SIZE
                if (grid(j, i) == ' ') then
                    call random_number(r)
                    grid(j, i) = char(int(r * 26) + ichar('a'))
                end if
            end do
        end do
    end subroutine

    subroutine find_all_words(words, word_lens, num_words, grid, all_found, num_found)
        character(len=*), intent(in) :: words(:)
        integer, intent(in) :: word_lens(:)
        integer, intent(in) :: num_words
        character(len=1), intent(in) :: grid(:,:)
        type(word_placement), intent(out) :: all_found(:)
        integer, intent(out) :: num_found

        integer :: i, x, y, d, j, cx, cy
        integer :: dx(0:7), dy(0:7)
        character(len=MAX_WORD_LEN) :: template
        logical :: matches

        dx = [1, 1, 0, -1, -1, -1, 0, 1]
        dy = [0, 1, 1, 1, 0, -1, -1, -1]

        num_found = 0

        do i = 1, num_words
            do y = 1, GRID_SIZE
                do x = 1, GRID_SIZE
                    ! Check if first letter matches (case-insensitive)
                    if (grid(x, y) /= words(i)(1:1) .and. &
                        char(ichar(grid(x, y)) - 32) /= char(ichar(words(i)(1:1)) - 32)) cycle

                    do d = 0, 7
                        ! Check bounds
                        cx = x + (word_lens(i) - 1) * dx(d)
                        cy = y + (word_lens(i) - 1) * dy(d)
                        if (cx < 1 .or. cx > GRID_SIZE .or. cy < 1 .or. cy > GRID_SIZE) cycle

                        ! Build template
                        template = ''
                        do j = 0, word_lens(i) - 1
                            cx = x + j * dx(d)
                            cy = y + j * dy(d)
                            template(j+1:j+1) = grid(cx, cy)
                        end do

                        ! Check match (case-insensitive)
                        matches = .true.
                        do j = 1, word_lens(i)
                            if (template(j:j) /= words(i)(j:j) .and. &
                                char(ichar(template(j:j)) - 32) /= char(ichar(words(i)(j:j)) - 32)) then
                                matches = .false.
                                exit
                            end if
                        end do

                        if (matches) then
                            num_found = num_found + 1
                            if (num_found > 500) return
                            all_found(num_found)%word = trim(words(i))
                            all_found(num_found)%col = x
                            all_found(num_found)%row = y
                            all_found(num_found)%dx = dx(d)
                            all_found(num_found)%dy = dy(d)
                        end if
                    end do
                end do
            end do
        end do
    end subroutine

    subroutine print_results(grid, placed, num_placed, all_found, num_found)
        character(len=1), intent(in) :: grid(:,:)
        type(word_placement), intent(in) :: placed(:), all_found(:)
        integer, intent(in) :: num_placed, num_found

        integer :: i, j, uppercase_count
        character(len=20) :: dir_name

        print *
        print *, "Word Search Puzzle (10x10)"
        print *, "=========================="
        print *

        write(*, '(A)', advance='no') "    "
        do j = 0, 9
            write(*, '(I2)', advance='no') j
        end do
        print *
        print *

        do i = 1, GRID_SIZE
            write(*, '(I3,A)', advance='no') i-1, "  "
            do j = 1, GRID_SIZE
                write(*, '(A2)', advance='no') grid(j, i)
            end do
            print *
        end do

        uppercase_count = 0
        do i = 1, GRID_SIZE
            do j = 1, GRID_SIZE
                if (grid(j, i) >= 'A' .and. grid(j, i) <= 'Z') uppercase_count = uppercase_count + 1
            end do
        end do

        print *
        print '(A,I0)', "ROSETTACODE letters: ", uppercase_count
        print *
        print '(A,I0,A)', "Words placed: ", num_placed
        print '(A,I0,A)', "Total words found embedded: ", num_found, " (including overlaps)"
        print *, "=========================="
        print *

        print *, "Placed words:"
        do i = 1, min(num_placed, 50)
            dir_name = get_direction_name(placed(i)%dx, placed(i)%dy)
            write(*, '(I3,A,A12,A,I2,A,I2,A,A)') &
                i, '. ', trim(placed(i)%word), &
                ' (', placed(i)%col-1, ',', placed(i)%row-1, ') ', trim(dir_name)
        end do

        print *
        print *, "All words found in grid:"
        do i = 1, min(num_found, 100)
            dir_name = get_direction_name(all_found(i)%dx, all_found(i)%dy)
            write(*, '(I3,A,A12,A,I2,A,I2,A,A)') &
                i, '. ', trim(all_found(i)%word), &
                ' (', all_found(i)%col-1, ',', all_found(i)%row-1, ') ', trim(dir_name)
        end do
    end subroutine

    function get_direction_name(dx, dy) result(name)
        integer, intent(in) :: dx, dy
        character(len=20) :: name

        if (dy == 0 .and. dx > 0) then
            name = "E"
        else if (dy == 0 .and. dx < 0) then
            name = "W"
        else if (dx == 0 .and. dy > 0) then
            name = "S"
        else if (dx == 0 .and. dy < 0) then
            name = "N"
        else if (dx > 0 .and. dy > 0) then
            name = "SE"
        else if (dx > 0 .and. dy < 0) then
            name = "NE"
        else if (dx < 0 .and. dy > 0) then
            name = "SW"
        else if (dx < 0 .and. dy < 0) then
            name = "NW"
        end if
    end function

end program word_search_rosetta_complete
