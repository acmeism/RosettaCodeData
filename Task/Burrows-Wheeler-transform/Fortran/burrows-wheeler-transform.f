program BurrowsWheeler
  implicit none

  ! Main program
  call Test("BANANA")
  call Test("CANAAN")
  call Test("CANCAN")
  call Test("appellee")
  call Test("dogwood")
  call Test("TO BE OR NOT TO BE OR WANT TO BE OR NOT?")
  call Test("SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES")
  call Test("Four score and 7 years ago, our forefathers set forth on this continent to establish a new nation "//&
  "conceived in liberty and dedicated to he proposition that all men were created equal")
  contains
  ! Function to compare rotations
  integer function CompareRotations(input, n, a, b)
    character(len=*), intent(in) :: input
    integer, intent(in) :: n, a, b
    integer :: p, q, nrNotTested
    integer :: i ,k

    CompareRotations = 0
    p = a
    q = b
    nrNotTested = n
    do
      p = p + 1
      if (p == n) p = 0
      q = q + 1
      if (q == n) q = 0
      i = p + 1
      k = q + 1
      if (input(i:i) == input(k:k)) then
        nrNotTested = nrNotTested - 1
      else if (input(i:i) > input(k:k)) then
        CompareRotations = 1
        exit
      else
        CompareRotations = -1
        exit
      end if
      if (nrNotTested == 0) exit
    end do
  end function CompareRotations

  ! Subroutine to encode the input string
  subroutine Encode(input, encoded, index)
    character(len=*), intent(in) :: input
    character(len=*), intent(out) :: encoded
    integer, intent(out) :: index
    integer :: n, i, j, k, incr, v
    integer, allocatable :: perm(:)

    n = len(input)
    allocate(perm(0:n-1))
    do j = 0, n - 1
      perm(j) = j
    end do

    ! Shell sort
    incr = 1
    do
      incr = 3 * incr + 1
      if (incr >= n) exit
    end do
    do
      incr = incr / 3
      do i = incr, n - 1
        v = perm(i)
        j = i
        do while (j >= incr)
          if(CompareRotations(input, n, perm(j - incr), v) /= 1)exit
          perm(j) = perm(j - incr)
          j = j - incr
        end do
        perm(j) = v
      end do
      if (incr == 1) exit
    end do

    ! Create the output
    do j = 0, n - 1
      k = perm(j)
      encoded(j + 1:j + 1) = input(k + 1:k + 1)
      if (k == n - 1) index = j
    end do

    deallocate(perm)
  end subroutine Encode

  ! Function to decode the encoded string
  function Decode(encoded, index) result(decoded)
    character(len=*), intent(in) :: encoded
    integer, intent(in) :: index
    character(len=:), allocatable :: decoded
    integer :: charInfo(0:255)
    integer, allocatable :: perm(:)
    integer :: n, j, k, total, prev
    character :: c

    n = len(encoded)
    if (n == 0) then
      decoded = ""
      return
    end if

    charInfo = 0
    do j = 0, n - 1
      c = encoded(j + 1:j + 1)
      charInfo(ichar(c)) = charInfo(ichar(c)) + 1
    end do

    total = 0
    prev = 0
    do k = 0, 255
      total = total + prev
      prev = charInfo(k)
      charInfo(k) = total
    end do

    allocate(perm(0:n-1))
    do j = 0, n - 1
      c = encoded(j + 1:j + 1)
      k = charInfo(ichar(c))
      perm(k) = j
      charInfo(ichar(c)) = charInfo(ichar(c)) + 1
    end do

    allocate(character(len=n) :: decoded)
    k = 0
    j = index
    do
      j = perm(j)
      decoded(k + 1:k + 1) = encoded(j + 1:j + 1)
      k = k + 1
      if (j == index) exit
    end do

    if (k < n) then
      do j = k, n - 1
        decoded(j + 1:j + 1) = decoded(j - k + 1:j - k + 1)
      end do
    end if
  end function Decode

  ! Subroutine to test the encoding and decoding
  subroutine Test(s)
    character(len=*), intent(in) :: s
    character(len=:), allocatable :: encoded, decoded
    integer :: index

    print *, ""
    print *, "     ", s
    allocate(character(len=len(s)) :: encoded)
    call Encode(s, encoded, index)
    print *, "---> ", encoded
    print *, "       index = ", index
    decoded = Decode(encoded, index)
    print *, "---> ", decoded
    deallocate(encoded)
  end subroutine Test

end program BurrowsWheeler
