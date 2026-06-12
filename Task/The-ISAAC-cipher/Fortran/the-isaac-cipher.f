module isaac_cipher
    implicit none
    integer, parameter :: iEncrypt = 0, iDecrypt = 1
    integer, parameter :: n = 256
    character(len=*), parameter :: msg = 'a Top Secret secret'
    character(len=*), parameter :: key = 'this is my secret key'

    integer :: randcnt
    integer :: aa, bb, cc
    integer, dimension(0:n-1) :: randrsl, mm

contains

subroutine isaac()
    integer :: i, x, y
    cc = cc + 1
    bb = bb + cc

    do i = 0, n-1
        x = mm(i)
        select case(mod(i, 4))
        case(0)
            aa = ieor(aa, ishft(aa, 13))
        case(1)
            aa = ieor(aa, ishft(aa, -6))
        case(2)
            aa = ieor(aa, ishft(aa, 2))
        case(3)
            aa = ieor(aa, ishft(aa, -16))
        end select
        aa = mm(iand(i + 128, 255)) + aa
        y = mm(iand(ishft(x, -2), 255)) + aa + bb
        mm(i) = y
        bb = mm(iand(ishft(y, -10), 255)) + x
        randrsl(i) = bb
    end do
    randcnt = 0
end subroutine isaac

subroutine mix(a, b, c, d, e, f, g, h)
    integer, intent(inout) :: a, b, c, d, e, f, g, h
    a = ieor(a, ishft(b, 11)); d = d + a; b = b + c
    b = ieor(b, ishft(c, -2)); e = e + b; c = c + d
    c = ieor(c, ishft(d, 8)); f = f + c; d = d + e
    d = ieor(d, ishft(e, -16)); g = g + d; e = e + f
    e = ieor(e, ishft(f, 10)); h = h + e; f = f + g
    f = ieor(f, ishft(g, -4)); a = a + f; g = g + h
    g = ieor(g, ishft(h, 8)); b = b + g; h = h + a
    h = ieor(h, ishft(a, -9)); c = c + h; a = a + b
end subroutine mix

subroutine irandinit(flag)
    logical, intent(in) :: flag
    integer :: i, a, b, c, d, e, f, g, h
    aa = 0; bb = 0; cc = 0
    a = int(z'9e3779b9')
    b = a; c = a; d = a; e = a; f = a; g = a; h = a

    do i = 1, 4
        call mix(a, b, c, d, e, f, g, h)
    end do

    i = 0
    do while(i < n)
        if (flag) then
            a = a + randrsl(i);   b = b + randrsl(i+1)
            c = c + randrsl(i+2); d = d + randrsl(i+3)
            e = e + randrsl(i+4); f = f + randrsl(i+5)
            g = g + randrsl(i+6); h = h + randrsl(i+7)
        endif
        call mix(a, b, c, d, e, f, g, h)
        mm(i:i+7) = [a, b, c, d, e, f, g, h]
        i = i + 8
    end do

    if (flag) then
        i = 0
        do while(i < n)
            a = a + mm(i);   b = b + mm(i+1)
            c = c + mm(i+2); d = d + mm(i+3)
            e = e + mm(i+4); f = f + mm(i+5)
            g = g + mm(i+6); h = h + mm(i+7)
            call mix(a, b, c, d, e, f, g, h)
            mm(i:i+7) = [a, b, c, d, e, f, g, h]
            i = i + 8
        end do
    endif
    call isaac()
end subroutine irandinit

subroutine iseed(seed, flag)
    character(len=*), intent(in) :: seed
    logical, intent(in) :: flag
    integer :: i, m

    mm = 0
    m = len(seed)
    do i = 0, n-1
        if (i < m) then
            randrsl(i) = ichar(seed(i+1:i+1))
        else
            randrsl(i) = 0
        endif
    end do
    call irandinit(flag)
end subroutine iseed

function irandom() result(res)
    integer :: res
    res = randrsl(randcnt)
    randcnt = randcnt + 1
    if (randcnt >= n) then
        call isaac()
        randcnt = 0
    endif
end function irandom

function iranda() result(res)
    integer :: res
    res = mod(irandom(), 95) + 32
end function iranda

function ascii2hex(s) result(res)
    character(len=*), intent(in) :: s
    character(len=2*len(s)) :: res
    integer :: i, val

    res = ''
    do i = 1, len(s)
        val = ichar(s(i:i))
        write(res(2*i-1:2*i), '(Z2.2)') val
    end do
end function ascii2hex

function vernam(msg) result(res)
    character(len=*), intent(in) :: msg
    character(len=len(msg)) :: res
    integer :: i, c

    res = ''
    do i = 1, len(msg)
        c = ieor(iranda(), ichar(msg(i:i)))
        res(i:i) = char(c)
    end do
end function vernam

function caesar(m, ch, shift, modulo, start) result(res)
    integer, intent(in) :: m, shift, modulo
    character, intent(in) :: ch, start
    character :: res
    integer :: n, s

    s = shift
    if (m == iDecrypt) s = -s
    n = mod(ichar(ch) - ichar(start) + s, modulo)
    if (n < 0) n = n + modulo
    res = char(ichar(start) + n)
end function caesar

function vigenere(msg, m) result(res)
    character(len=*), intent(in) :: msg
    integer, intent(in) :: m
    character(len=len(msg)) :: res
    integer :: i

    res = ''
    do i = 1, len(msg)
        res(i:i) = caesar(m, msg(i:i), iranda(), 95, ' ')
    end do
end function vigenere

end module isaac_cipher

program rosetta_isaac
    use isaac_cipher
    implicit none
    character(len=len(msg)) :: xctx, mctx, xptx, mptx

    call iseed(key, .true.)
    xctx = vernam(msg)
    mctx = vigenere(msg, iEncrypt)

    call iseed(key, .true.)
    xptx = vernam(xctx)
    mptx = vigenere(mctx, iDecrypt)

    print '(A)', 'Message: '//msg
    print '(A)', 'Key    : '//key
    print '(A)', 'XOR    : '//ascii2hex(xctx)
    print '(A)', 'MOD    : '//ascii2hex(mctx)
    print '(A)', 'XOR dcr: '//xptx
    print '(A)', 'MOD dcr: '//mptx
end program rosetta_isaac

