integer :: i, j = -1, k = 42
logical :: a

i = bit_size(j)       ! returns the number of bits in the given INTEGER variable

! bitwise boolean operations on integers
i = iand(k, j)        ! returns bitwise AND of K and J
i = ior(k, j)         ! returns bitwise OR of K and J
i = ieor(k, j)        ! returns bitwise EXCLUSIVE OR of K and J
i = not(j)            ! returns bitwise NOT of J

! single-bit integer/logical operations (bit positions are zero-based)
a = btest(i, 4)       ! returns logical .TRUE. if bit position 4 of I is 1, .FALSE. if 0
i = ibclr(k, 8)       ! returns value of K with 8th bit position "cleared" (set to 0)
i = ibset(k, 13)      ! returns value of K with 13th bit position "set" (set to 1)

! multi-bit integer operations
i = ishft(k, j)       ! returns value of K shifted by J bit positions, with ZERO fill
                      !    (right shift if J < 0 and left shift if J > 0).
i = ishftc(k, j)      ! returns value of K shifted CIRCULARLY by J bit positions
                      !    (right circular shift if J < 0 and left if J > 0)
i = ishftc(k, j, 20)  ! returns value as before except that ONLY the 20 lowest order
                      !    (rightmost) bits are circularly shifted
i = ibits(k, 7, 8)    ! extracts 8 contiguous bits from K starting at position 7 and
                      !    returns them as the rightmost bits of an otherwise
                      !    zero-filled integer. For non-negative K this is
                      !    arithmetically equivalent to:   MOD((K / 2**7), 2**8)
