MODULE utf8_reader
  IMPLICIT NONE
  PRIVATE
  PUBLIC :: open_utf8_file, read_next_char, close_utf8_file

  ! File unit and state variables
  INTEGER, PRIVATE :: file_unit = -1
  LOGICAL, PRIVATE :: file_open = .FALSE.

CONTAINS

  SUBROUTINE open_utf8_file(filename, status)
    CHARACTER(LEN=*), INTENT(IN) :: filename
    INTEGER, INTENT(OUT) :: status
    ! Open file in stream mode for UTF-8 reading
    IF (file_open) THEN
      status = -1  ! File already open
      RETURN
    END IF
    OPEN(NEWUNIT=file_unit, FILE=filename, ACCESS='STREAM', &
         STATUS='OLD', FORM='UNFORMATTED', IOSTAT=status)
    IF (status == 0) file_open = .TRUE.
  END SUBROUTINE open_utf8_file

  SUBROUTINE read_next_char(char_out, status)
    CHARACTER(KIND=SELECTED_CHAR_KIND('ISO_10646'), LEN=1), INTENT(OUT) :: char_out
    INTEGER, INTENT(OUT) :: status
    CHARACTER(KIND=SELECTED_CHAR_KIND('DEFAULT'), LEN=1) :: byte
    INTEGER :: i, num_bytes
    INTEGER(KIND=1) :: first_byte
    INTEGER :: codepoint
    INTEGER(KIND=1), PARAMETER :: utf8_mask(0:3) = [Z'80', Z'C0', Z'E0', Z'F0']
    INTEGER(KIND=1), PARAMETER :: utf8_mark(0:3) = [Z'00', Z'80', Z'C0', Z'E0']

    IF (.NOT. file_open) THEN
      status = -1  ! File not open
      char_out = ACHAR(0)
      RETURN
    END IF

    ! Read first byte
    READ(file_unit, IOSTAT=status) byte
    IF (status /= 0) THEN
      char_out = ACHAR(0)
      RETURN
    END IF

    first_byte = ICHAR(byte, KIND=1)
    ! Determine number of bytes in UTF-8 character
    IF (IAND(first_byte, utf8_mask(0)) == utf8_mark(0)) THEN
      num_bytes = 1
      codepoint = first_byte
    ELSE IF (IAND(first_byte, utf8_mask(1)) == utf8_mark(1)) THEN
      num_bytes = 2
      codepoint = IAND(first_byte, Z'1F')
    ELSE IF (IAND(first_byte, utf8_mask(2)) == utf8_mark(2)) THEN
      num_bytes = 3
      codepoint = IAND(first_byte, Z'0F')
    ELSE IF (IAND(first_byte, utf8_mask(3)) == utf8_mark(3)) THEN
      num_bytes = 4
      codepoint = IAND(first_byte, Z'07')
    ELSE
      status = -2  ! Invalid UTF-8 start byte
      char_out = ACHAR(0)
      RETURN
    END IF

    ! Read continuation bytes
    DO i = 2, num_bytes
      READ(file_unit, IOSTAT=status) byte
      IF (status /= 0) THEN
        char_out = ACHAR(0)
        RETURN
      END IF
      IF (IAND(ICHAR(byte, KIND=1), Z'C0') /= Z'80') THEN
        status = -3  ! Invalid UTF-8 continuation byte
        char_out = ACHAR(0)
        RETURN
      END IF
      codepoint = ISHFT(codepoint, 6) + IAND(ICHAR(byte, KIND=1), Z'3F')
    END DO

    ! Convert codepoint to Unicode character
    char_out = ACHAR(codepoint, KIND=SELECTED_CHAR_KIND('ISO_10646'))
    status = 0
  END SUBROUTINE read_next_char

  SUBROUTINE close_utf8_file(status)
    INTEGER, INTENT(OUT) :: status
    IF (.NOT. file_open) THEN
      status = -1
      RETURN
    END IF
    CLOSE(file_unit, IOSTAT=status)
    file_open = .FALSE.
    file_unit = -1
  END SUBROUTINE close_utf8_file

END MODULE utf8_reader

PROGRAM test_utf8_reader
  USE utf8_reader
mu
  IMPLICIT NONE
  CHARACTER(KIND=SELECTED_CHAR_KIND('ISO_10646'), LEN=1) :: char
  INTEGER :: status
  CHARACTER(LEN=100) :: filename = 'test.txt'

  ! Create a test file with UTF-8 content
  OPEN(UNIT=10, FILE=filename, STATUS='REPLACE', ENCODING='UTF-8')
  WRITE(10, '(A)') 'Hello, 世界! 😊'  ! Includes ASCII and UTF-8 characters
  CLOSE(10)

  ! Test the UTF-8 reader
  CALL open_utf8_file(filename, status)
  IF (status /= 0) THEN
    WRITE(*,*) 'Error opening file: ', status
    STOP
  END IF

  WRITE(*,*) 'Reading file character by character:'
  DO
    CALL read_next_char(char, status)
    IF (status /= 0) EXIT
    WRITE(*, '(A)') 'Read character: ' // char
  END DO

  CALL close_utf8_file(status)
  IF (status /= 0) THEN
    WRITE(*,*) 'Error closing file: ', status
  END IF
END PROGRAM test_utf8_reader
