module hash_map_module

    use iso_fortran_env
    use qdmodule

    implicit none
    private
    public :: HashEntry, HashMap

    type HashEntry
        integer(int64) :: key, value
        type(HashEntry), pointer :: sgte => null()
    end type HashEntry

! Container for pointer to HashEntry
    type HashEntryContainer
        type(HashEntry), pointer :: ptr => null()
    end type HashEntryContainer

    type HashMap
        type(HashEntryContainer), allocatable :: buckets(:)
    contains
        procedure :: put => hash_map_put
        procedure :: get => hash_map_get
        procedure :: contains => hash_map_contains
    end type HashMap

contains

    subroutine hash_map_put(this, key, value)
        class(HashMap), intent(inout) :: this
        integer(int64), intent(in) :: key, value
        integer(int64) :: bucket
        type(HashEntry), pointer :: entry

        bucket = iand(key, int(255, int64))
        entry => this % buckets(bucket) % ptr

        ! Check for existing key
        do while (associated(entry))
            if (entry % key == key) then
                entry % value = value
                return
            end if
            entry => entry % sgte
        end do

        ! Insert new entry at head
        allocate (entry)
        entry % key = key
        entry % value = value
        entry % sgte => this % buckets(bucket) % ptr  ! Correct pointer assignment
        this % buckets(bucket) % ptr => entry       ! Update head pointer
    end subroutine hash_map_put

    function hash_map_get(this, key, defaultValue) result(res)
        class(HashMap), intent(in) :: this
        integer(int64), intent(in) :: key
        integer(int64), optional, intent(in) :: defaultValue
        integer(int64) :: res, bucket
        type(HashEntry), pointer :: entry

        res = 0
        if (present(defaultValue)) res = defaultValue
        bucket = iand(key, int(255, int64))
        entry => this % buckets(bucket) % ptr

        do while (associated(entry))
            if (entry % key == key) then
                res = entry % value
                return
            end if
            entry => entry % sgte
        end do
    end function hash_map_get

    function hash_map_contains(this, key) result(res)
        class(HashMap), intent(in) :: this
        integer(int64), intent(in) :: key
        logical :: res
        integer(int64) :: bucket
        type(HashEntry), pointer :: entry

        bucket = iand(key, int(255, int64))
        entry => this % buckets(bucket) % ptr

        res = .false.
        do while (associated(entry))
            if (entry % key == key) then
                res = .true.
                return
            end if
            entry => entry % sgte
        end do
    end function hash_map_contains

end module hash_map_module

module int_array_module
    use iso_fortran_env
    implicit none
    private
    public :: IntArray

    type IntArray
        integer(int64), allocatable :: dato(:)
        integer(int64) :: size = 0
    contains
        procedure :: add => int_array_add
        procedure :: get => int_array_get
        procedure :: getSize => int_array_size
        procedure :: clear => int_array_clear
    end type

contains
    subroutine int_array_add(this, value)
        use iso_fortran_env
        class(IntArray), intent(inout) :: this
        integer(int64), intent(in) :: value
        integer(int64), allocatable :: temp(:)
        integer(int64) :: current_capacity

        if (.not. allocated(this % dato)) then
            allocate (this % dato(30))
            current_capacity = 30_8
        else
            current_capacity = size(this % dato)
        end if

        if (this % size >= current_capacity) then
            call move_alloc(this % dato, temp)
            allocate (this % dato(2 * current_capacity))
            this % dato(1:this % size) = temp(1:this % size)
        end if

        this % size = this % size + 1
        this % dato(this % size) = value
    end subroutine int_array_add

    function int_array_get(this, index) result(res)
        class(IntArray), intent(in) :: this
        integer(int64), intent(in) :: index
        integer(int64) :: res

        res = 0
        if (index >= 1 .and. index <= this % size) res = this % dato(index)
    end function

    function int_array_size(this) result(res)
        use iso_fortran_env
        class(IntArray), intent(in) :: this
        integer(int64) :: res
        res = this % size
    end function

    subroutine int_array_clear(this)
        class(IntArray), intent(inout) :: this
        this % size = 0
    end subroutine
end module

module power_module
    use iso_fortran_env
    use hash_map_module
    use int_array_module
    implicit none
    private
    public :: showPow, initialize_power  ! Add initialization routine

    type(HashMap) :: p
    type(IntArray) :: levels(1)

contains

    subroutine initialize_power
        integer :: i
        if (allocated(p % buckets)) deallocate (p % buckets)
        allocate (p % buckets(0:255))
        do i = 0, 255
            nullify (p % buckets(i) % ptr)  ! Explicitly nullify all bucket pointers
        end do
        call levels(1) % clear()
        call p % put(1_8, 0_8)
        call levels(1) % add(1_8)
    end subroutine

    recursive function path(n) result(res)
        use iso_fortran_env
        use hash_map_module
        use int_array_module
        implicit none
        integer(int64), intent(in) :: n
        type(IntArray) :: res
        integer(int64) :: i, j, x, y, sum, curr
        type(IntArray) :: q, tempPath
        integer(int64) :: max_iter, iter

        ! Safety limit to prevent infinite loops
        max_iter = 100000000
        iter = 0

        if (n == 0) return
        do while (.not. p % contains(n))
            q = IntArray()

            do i = 1, levels(1) % getSize()
                x = levels(1) % get(i)
                associate (xPath => path(x))
                    do j = 1, xPath % getSize()
                        y = xPath % get(j)
                        sum = x + y
                        if (p % contains(sum)) cycle
                        call p % put(sum, x)
                        call q % add(sum)
                    end do
                end associate
            end do
            call levels(1) % clear()
            do i = 1, q % getSize()
                call levels(1) % add(q % get(i))
            end do

            if (q % getSize() == 0) exit

            iter = iter + 1
            if (iter > max_iter) then
                print *, "Path search exceeded maximum iterations for n=", n
                exit
            end if
        end do

        curr = n
        tempPath = IntArray()

        do while (curr /= 0)
            call tempPath % add(curr)
            curr = p % get(curr, 0_8)
        end do

        do i = tempPath % getSize(), 1, -1
            call res % add(tempPath % get(i))
        end do

        return
    end function path

    function treePowBig(x, n) result(res)
        use iso_fortran_env
        integer(int64), intent(in) :: x, n
        integer(kind=16) :: res
        integer(kind=16), allocatable :: r(:)
        integer(int64) :: i, curr, p
        type(IntArray) :: pathToN

        ! Allocate array to hold intermediate results
        allocate (r(0:n))
        r(0) = 1_16
        if (n >= 1) r(1) = x

        p = 0
        pathToN = path(n)

        do i = 1, pathToN % getSize()
            curr = pathToN % get(i)
            r(curr) = r(curr - p) * r(p)
            p = curr
        end do

        res = r(n)
        deallocate (r)
    end function treePowBig

    function treePowDecimal(x, n) result(res)
        use qdmodule
        type(qd_real), intent(in) :: x
        integer(int64), intent(in) :: n
        type(qd_real) :: res
        type(qd_real), allocatable :: r(:)
        integer(int64) :: i, curr, p
        type(IntArray) :: pathToN

        allocate (r(0:n))
        r(0) = "1.0"  ! r(0) = 1.0 in quad-double
        if (n >= 1) r(1) = x

        p = 0
        pathToN = path(n)
        do i = 1, pathToN % getSize()
            curr = pathToN % get(i)
            r(curr) = r(curr - p) * r(p)
            p = curr
        end do

        res = r(n)
        deallocate (r)
    end function treePowDecimal

    subroutine showPow(x, n, xx)
        use iso_fortran_env
        use qdmodule
        use int_array_module
        implicit none
        character(len=*) :: xx
        type(qd_real), intent(in) :: x
        integer(int64), intent(in) :: n
        type(IntArray) :: pathToN
        character(len=1024) :: pathStr
        integer(int64) :: i
        type(qd_real) :: result
        character(len=1024) :: str
        character(len=5) :: str2
        double precision :: try
        integer :: unit
!
        pathToN = path(n)
        pathStr = ""
        do i = 1, pathToN % getSize()
            if (i > 1) pathStr = trim(pathStr)//", "
            write (pathStr(len_trim(pathStr) + 1:), '(I0)') pathToN % get(i)
        end do

        print '(I0,": [",A,"]" )', n, trim(pathStr)

        result = treePowDecimal(x, n)
!    call qdwrite(6, result)  ! Writes result to stdout (unit 6)

        ! Create a temporary internal file (string)
        open (newunit=unit, status='scratch', action='readwrite', form='formatted')

        ! Write qd_real to the internal file
        call qdwrite(unit, result)

        ! Read back into the string
        rewind (unit)
        read (unit, '(A)') str
        close (unit)
        write (str2, '(i0)') n
        write (*, '(a)', advance="no") 'Result: '//xx//'^'//trim(adjustl(str2))//' = '
        read (str, *) try
        if ((mod(try, 1.0) == 0.0) .and. (try < real(huge(1_16), kind=real64))) then
            write (str, '(I0)') int(try, kind=16)
            write (*, '(A)') trim(adjustl(str))
        else
            if (try < 1.0d10) then
                write (str, '(f20.13)') try
                write (*, '(a)') trim(adjustl(str))
            else
                write (*, '(a)') trim(adjustl(str))
            end if
        end if
        print *
    end subroutine showPow

end module

program main
    use iso_fortran_env
    use qdmodule
    use power_module
    implicit none
    integer(int64) :: i
    type(qd_real) :: x

    call initialize_power()

    x = "2.0"
    do i = 0, 17
        call showPow(x, i, "2.0")
    end do

    x = "1.1"
    call showPow(x, 81_8, "1.1")
    call initialize_power()

    x = "3.0"
    call showPow(x, 191_8, "3.0")

    stop 'Normal Finish'
end program
