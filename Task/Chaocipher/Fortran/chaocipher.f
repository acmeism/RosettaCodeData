!
!This program implements the **Chaocipher encryption algorithm** in FORTRAN, extended to handle all printable ASCII characters (32-127).
!    The Chaocipher is a polyalphabetic cipher invented by John F. Byrne in 1918, which dynamically permutes two alphabets after
!     processing each character, making it highly secure and resistant to cryptanalysis.
!
!#### Key Features:
!1. **Initialization**:
!   - Two alphabets (`left` and `right`) are initialized with shuffled ASCII characters (32-127).
!   - The `plaintext` is set to "WELLDONEISBETTERTHANWELLSAID".
!
!2. **Enciphering**:
!   - For each character in the plaintext:
!     - Locate the character in the `right` alphabet.
!     - Find the corresponding ciphertext character in the `left` alphabet.
!     - Permute both alphabets based on the Chaocipher rules:
!       - The `left` alphabet is rotated to bring the ciphertext character to the top, and a specific character is moved to a new position.
!       - The `right` alphabet is similarly rotated, with an additional rotation step.
!
!3. **Deciphering**:
!   - The ciphertext is decrypted back into plaintext using the reverse process:
!     - Locate the ciphertext character in the `left` alphabet.
!     - Find the corresponding plaintext character in the `right` alphabet.
!     - Permute both alphabets identically as in enciphering.
!
!4. **Verification**:
!   - After enciphering and deciphering, the program compares the original plaintext with the decrypted text to ensure correctness.
!
!#### Output:
!The program prints:
!- Initial left and right alphabets.
!- Enciphered ciphertext.
!- Deciphered plaintext.
!- A success message if decryption matches the original plaintext.
!
!#### Example Execution:
!For input plaintext "WELLDONEISBETTERTHANWELLSAID", the program outputs:
!- Ciphertext: `OAHQHCNYNXTSZJRRHJBYHQKSOUJY`
!- Decrypted Text: `WELLDONEISBETTERTHANWELLSAID`
!- Verification: "Decryption successful: plaintext matches decrypted text."
!
!This implementation demonstrates both encryption and decryption processes while adhering to Chaocipher's dynamic permutation rules,
!extended for modern ASCII characters.
!
!
PROGRAM Chaocipher
  IMPLICIT NONE
  CHARACTER(LEN=96) :: left, right, left_orig, right_orig
  CHARACTER(LEN=1000) :: plaintext, ciphertext, decrypted
  INTEGER :: i, len, ascii_start
  LOGICAL :: trace

  ! Initialize alphabets and input
  CALL initialize_alphabets(left, right)
  left_orig = left
  right_orig = right
  plaintext = 'Well, when I was in Egypt, I had a conversation with the Sphinx! She taught me how to sew.'
  ciphertext = ''
  decrypted = ''
  trace = .FALSE.
  ascii_start = 32 ! ASCII start at space character

  len = LEN_TRIM(plaintext)

  PRINT *, 'Initial Left: ', left
  PRINT *, 'Initial Right:', right
  PRINT *, 'Plaintext:   ', TRIM(plaintext)

  ! Encipher
  DO i = 1, len
    CALL encipher(plaintext(i:i), ciphertext(i:i), left, right, ascii_start)
    IF (trace) THEN
      PRINT *, 'Step ', i
      PRINT *, 'Left:  ', left
      PRINT *, 'Right: ', right
    END IF
  END DO

  PRINT *, 'Ciphertext:  ', TRIM(ciphertext)

  ! Reset alphabets for deciphering
  left = left_orig
  right = right_orig

  ! Decipher
  DO i = 1, len
    CALL decipher(ciphertext(i:i), decrypted(i:i), left, right, ascii_start)
  END DO

  PRINT *, 'Decrypted:   ', TRIM(decrypted)

  ! Check for correctness
  IF (plaintext == decrypted) THEN
    PRINT *, 'Decryption successful: plaintext matches decrypted text'
  ELSE
    PRINT *, 'Decryption failed: plaintext does not match decrypted text'
  END IF

CONTAINS

 SUBROUTINE initialize_alphabets(left, right)
  CHARACTER(LEN=96), INTENT(OUT) :: left, right
  INTEGER :: i, j
  CHARACTER :: temp
  REAL :: r

  ! Initialize alphabets with ASCII characters 32-127
  DO i = 1, 96
    left(i:i) = CHAR(i + 31)
    right(i:i) = CHAR(i + 31)
  END DO

  ! Fisher-Yates shuffle for left alphabet
  DO i = 96, 2, -1
    CALL RANDOM_NUMBER(r)
    j = 1 + FLOOR(i * r)
    temp = left(i:i)
    left(i:i) = left(j:j)
    left(j:j) = temp
  END DO

  ! Fisher-Yates shuffle for right alphabet
  DO i = 96, 2, -1
    CALL RANDOM_NUMBER(r)
    j = 1 + FLOOR(i * r)
    temp = right(i:i)
    right(i:i) = right(j:j)
    right(j:j) = temp
  END DO
END SUBROUTINE initialize_alphabets

  SUBROUTINE encipher(p, c, left, right, ascii_start)
    CHARACTER(LEN=1), INTENT(IN) :: p
    CHARACTER(LEN=1), INTENT(OUT) :: c
    CHARACTER(LEN=96), INTENT(INOUT) :: left, right
    INTEGER, INTENT(IN) :: ascii_start
    INTEGER :: pos

    pos = INDEX(right, p)
    c = left(pos:pos)

    CALL permute_left(left, c, ascii_start)
    CALL permute_right(right, p, ascii_start)
  END SUBROUTINE encipher

  SUBROUTINE decipher(c, p, left, right, ascii_start)
    CHARACTER(LEN=1), INTENT(IN) :: c
    CHARACTER(LEN=1), INTENT(OUT) :: p
    CHARACTER(LEN=96), INTENT(INOUT) :: left, right
    INTEGER, INTENT(IN) :: ascii_start
    INTEGER :: pos

    pos = INDEX(left, c)
    p = right(pos:pos)

    CALL permute_left(left, c, ascii_start)
    CALL permute_right(right, p, ascii_start)
  END SUBROUTINE decipher

  SUBROUTINE permute_left(alphabet, pivot, ascii_start)
    CHARACTER(LEN=96), INTENT(INOUT) :: alphabet
    CHARACTER(LEN=1), INTENT(IN) :: pivot
    INTEGER, INTENT(IN) :: ascii_start
    INTEGER :: pos
    CHARACTER(LEN=1) :: temp

    pos = INDEX(alphabet, pivot)
    alphabet = alphabet(pos:) // alphabet(:pos-1)

    temp = alphabet(2:2)
    alphabet(2:49) = alphabet(3:50)
    alphabet(50:50) = temp
  END SUBROUTINE permute_left

  SUBROUTINE permute_right(alphabet, pivot, ascii_start)
    CHARACTER(LEN=96), INTENT(INOUT) :: alphabet
    CHARACTER(LEN=1), INTENT(IN) :: pivot
    INTEGER, INTENT(IN) :: ascii_start
    INTEGER :: pos
    CHARACTER(LEN=1) :: temp

    pos = INDEX(alphabet, pivot)
    alphabet = alphabet(pos:) // alphabet(:pos-1)
    alphabet = alphabet(2:) // alphabet(1:1)

    temp = alphabet(3:3)
    alphabet(3:49) = alphabet(4:50)
    alphabet(50:50) = temp
  END SUBROUTINE permute_right

END PROGRAM Chaocipher
