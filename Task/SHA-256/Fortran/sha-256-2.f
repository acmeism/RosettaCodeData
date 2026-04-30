! Version translated to Fortran on 2025-11-02
! Based on FIPS PUB 180-4 SHA-256 implementation

PROGRAM sha256_test
  IMPLICIT NONE
  CHARACTER(LEN=*), PARAMETER :: test = "Rosetta code"
  CHARACTER(LEN=64) :: sha256
  WRITE(*,*) TRIM(test), " => ", sha256(test)
END PROGRAM sha256_test

FUNCTION sha256(input_message)
  IMPLICIT NONE
  CHARACTER(LEN=*), INTENT(IN) :: input_message
  CHARACTER(LEN=64) :: sha256

  INTEGER, PARAMETER :: wp = 4  ! 32-bit integers
  INTEGER, PARAMETER :: bits = 32
  INTEGER(wp), DIMENSION(0:63) :: k, w
  INTEGER(wp) :: h0, h1, h2, h3, h4, h5, h6, h7
  INTEGER(wp) :: a, b, c, d, e, f, g, h
  INTEGER(wp) :: t1, t2
  CHARACTER(LEN=:), ALLOCATABLE :: msg
  INTEGER(8) :: bitlen
  INTEGER :: msglen, padlen, num_blocks, i, j, block_start
  CHARACTER(LEN=1), DIMENSION(8) :: lenbytes
  INTEGER(8) :: temp

  ! Constants (K)
  k = [ int(z'428a2f98'), int(z'71374491'), int(z'b5c0fbcf'), int(z'e9b5dba5'), int(z'3956c25b'), int(z'59f111f1'), &
         int(z'923f82a4'), int(z'ab1c5ed5'), int(z'd807aa98'), int(z'12835b01'), int(z'243185be'), int(z'550c7dc3'), &
         int(z'72be5d74'), int(z'80deb1fe'), int(z'9bdc06a7'), int(z'c19bf174'), int(z'e49b69c1'), int(z'efbe4786'), &
         int(z'0fc19dc6'), int(z'240ca1cc'), int(z'2de92c6f'), int(z'4a7484aa'), int(z'5cb0a9dc'), int(z'76f988da'), &
         int(z'983e5152'), int(z'a831c66d'), int(z'b00327c8'), int(z'bf597fc7'), int(z'c6e00bf3'), int(z'd5a79147'), &
         int(z'06ca6351'), int(z'14292967'), int(z'27b70a85'), int(z'2e1b2138'), int(z'4d2c6dfc'), int(z'53380d13'), &
         int(z'650a7354'), int(z'766a0abb'), int(z'81c2c92e'), int(z'92722c85'), int(z'a2bfe8a1'), int(z'a81a664b'), &
         int(z'c24b8b70'), int(z'c76c51a3'), int(z'd192e819'), int(z'd6990624'), int(z'f40e3585'), int(z'106aa070'), &
         int(z'19a4c116'), int(z'1e376c08'), int(z'2748774c'), int(z'34b0bcb5'), int(z'391c0cb3'), int(z'4ed8aa4a'), &
         int(z'5b9cca4f'), int(z'682e6ff3'), int(z'748f82ee'), int(z'78a5636f'), int(z'84c87814'), int(z'8cc70208'), &
         int(z'90befffa'), int(z'a4506ceb'), int(z'bef9a3f7'), int(z'c67178f2') ]

  ! Initial hash values
  h0 = int(z'6a09e667')
  h1 = int(z'bb67ae85')
  h2 = int(z'3c6ef372')
  h3 = int(z'a54ff53a')
  h4 = int(z'510e527f')
  h5 = int(z'9b05688c')
  h6 = int(z'1f83d9ab')
  h7 = int(z'5be0cd19')

  ! Pre-processing: padding the message
  bitlen = LEN(input_message) * 8_8
  msg = input_message // CHAR(128)
  msglen = LEN(msg)
  padlen = 64 - MOD(msglen, 64)
  IF (padlen < 8) padlen = padlen + 64
  msg = msg // REPEAT(CHAR(0), padlen)
  msglen = LEN(msg)

  ! Append the bit length as big-endian 64-bit integer
  temp = bitlen
  DO i = 1, 8
    lenbytes(i) = CHAR(IAND(temp, 255_8))
    temp = ISHFT(temp, -8)
  END DO
  DO i = 0, 7
    msg(msglen - 7 + i : msglen - 7 + i) = lenbytes(8 - i)
  END DO

  ! Number of 64-byte blocks
  num_blocks = msglen / 64

  ! Process each block
  DO j = 0, num_blocks - 1
    block_start = j * 64 + 1

    ! Break block into sixteen 32-bit big-endian words w(0:15)
    DO i = 0, 15
      w(i) = IOR( IOR(ISHFT(ICHAR(msg(block_start + i*4 :)), 24), &
                      ISHFT(ICHAR(msg(block_start + i*4 + 1 :)), 16)), &
                  IOR(ISHFT(ICHAR(msg(block_start + i*4 + 2 :)), 8), &
                      ICHAR(msg(block_start + i*4 + 3 :))))
    END DO

    ! Extend to w(16:63)
    DO i = 16, 63
      w(i) = sigma3(w(i-2)) + w(i-7) + sigma2(w(i-15)) + w(i-16)
    END DO

    ! Initialize working variables
    a = h0
    b = h1
    c = h2
    d = h3
    e = h4
    f = h5
    g = h6
    h = h7

    ! Compression
    DO i = 0, 63
      t1 = h + sigma1(e) + ch(e, f, g) + k(i) + w(i)
      t2 = sigma0(a) + maj(a, b, c)
      h = g
      g = f
      f = e
      e = d + t1
      d = c
      c = b
      b = a
      a = t1 + t2
    END DO

    ! Add to current hash
    h0 = h0 + a
    h1 = h1 + b
    h2 = h2 + c
    h3 = h3 + d
    h4 = h4 + e
    h5 = h5 + f
    h6 = h6 + g
    h7 = h7 + h
  END DO

  ! Produce the final hash as hex string
  sha256 = to_hex(h0) // to_hex(h1) // to_hex(h2) // to_hex(h3) // &
           to_hex(h4) // to_hex(h5) // to_hex(h6) // to_hex(h7)
CONTAINS

  FUNCTION ch(x, y, z)
    INTEGER(wp), INTENT(IN) :: x, y, z
    INTEGER(wp) :: ch
    ch = IEOR(IAND(x, y), IAND(NOT(x), z))
  END FUNCTION ch

  FUNCTION maj(x, y, z)
    INTEGER(wp), INTENT(IN) :: x, y, z
    INTEGER(wp) :: maj
    maj = IEOR(IEOR(IAND(x, y), IAND(x, z)), IAND(y, z))
  END FUNCTION maj

  FUNCTION sigma0(x)
    INTEGER(wp), INTENT(IN) :: x
    INTEGER(wp) :: sigma0
    sigma0 = IEOR(IEOR(rotr(x, 2), rotr(x, 13)), rotr(x, 22))
  END FUNCTION sigma0

  FUNCTION sigma1(x)
    INTEGER(wp), INTENT(IN) :: x
    INTEGER(wp) :: sigma1
    sigma1 = IEOR(IEOR(rotr(x, 6), rotr(x, 11)), rotr(x, 25))
  END FUNCTION sigma1

  FUNCTION sigma2(x)
    INTEGER(wp), INTENT(IN) :: x
    INTEGER(wp) :: sigma2
    sigma2 = IEOR(IEOR(rotr(x, 7), rotr(x, 18)), shr(x, 3))
  END FUNCTION sigma2

  FUNCTION sigma3(x)
    INTEGER(wp), INTENT(IN) :: x
    INTEGER(wp) :: sigma3
    sigma3 = IEOR(IEOR(rotr(x, 17), rotr(x, 19)), shr(x, 10))
  END FUNCTION sigma3

  FUNCTION rotr(x, n)
    INTEGER(wp), INTENT(IN) :: x
    INTEGER, INTENT(IN) :: n
    INTEGER(wp) :: rotr
    rotr = ISHFTC(x, -n, bits)
  END FUNCTION rotr

  FUNCTION shr(x, n)
    INTEGER(wp), INTENT(IN) :: x
    INTEGER, INTENT(IN) :: n
    INTEGER(wp) :: shr
    shr = ISHFT(x, -n)
  END FUNCTION shr

  FUNCTION to_hex(val)
    INTEGER(wp), INTENT(IN) :: val
    CHARACTER(LEN=8) :: to_hex
    CHARACTER(LEN=16), PARAMETER :: digits = '0123456789abcdef'
    INTEGER(8) :: uval, rem
    INTEGER :: pos
    uval = IAND(INT(val, 8), int(z'00000000FFFFFFFF',8))
    DO pos = 8, 1, -1
      rem = MOD(uval, 16_8)
      to_hex(pos:pos) = digits(INT(rem)+1:INT(rem)+1)
      uval = uval / 16
    END DO
  END FUNCTION to_hex

END FUNCTION sha256
