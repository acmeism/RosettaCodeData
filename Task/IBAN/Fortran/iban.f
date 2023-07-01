program ibancheck

   use ISO_FORTRAN_ENV

   implicit none

   character(4), dimension(75) :: cc = (/ &
            "AD24","AE23","AL28","AT20","AZ28","BA20","BE16","BG22","BH22","BR29", &
            "BY28","CH21","CR22","CY28","CZ24","DE22","DK18","DO28","EE20","ES24", &
            "FI18","FO18","FR27","GB22","GE22","GI23","GL18","GR27","GT28","HR21", &
            "HU28","IE22","IL23","IQ23","IS26","IT27","JO30","KW30","KZ20","LB28", &
            "LC32","LI21","LT20","LU20","LV21","MC27","MD24","ME22","MK19","MR27", &
            "MT31","MU30","NL18","NO15","PK24","PL28","PS29","PT25","QA29","RO24", &
            "RS22","SA24","SC31","SE24","SI19","SK24","SM27","ST25","SV28","TL23", &
            "TN24","TR26","UA29","VG24","XK20" /)

    character(34), dimension(12) :: ibans = (/ "GB82 WEST 1234 5698 7654 32       ", &
                                               "GB82WEST12345698765432            ", &
                                               "gb82 west 1234 5698 7654 32       ", &
                                               "GB82 TEST 1234 5698 7654 32       ", &
                                               "GR16 0110 1250 0000 0001 2300 695 ", &
                                               "GB29 NWBK 6016 1331 9268 19       ", &
                                               "SA03 8000 0000 6080 1016 7519     ", &
                                               "CH93 0076 2011 6238 5295 7        ", &
                                               "IL62 0108 0000 0009 9999 999      ", &
                                               "IL62-0108-0000-0009-9999-999      ", &
                                               "US12 3456 7890 0987 6543 210      ", &
                                               "GR16 0110 1250 0000 0001 2300 695X" /)

    integer :: i

    do i=1, size(ibans)
        if (checkIBAN(trim(ibans(i)))) then
            print *, "  valid IBAN: ", trim(ibans(i))
        else
            print *, "invalid IBAN: ", trim(ibans(i))
        end if
    end do

    return

contains

    function checkIBAN(ibancode) result(valid)
        character(len=*), intent(in) :: ibancode
        character(len=len(ibancode)) :: iban
        logical :: valid
        integer(int32) :: j, ascii, ibanSize
        character(100) :: ibanRearrange, ibantoint
        character(2) :: temp
        valid = .false.

        iban = remove_blanks(ibancode)
        ibanSize = checkCountryCode(iban)
        if (ibanSize == len(trim(iban))) then
            ibanRearrange = iban(5:ibanSize)//iban(1:4)
            ibantoint = ""
            do j=1, ibanSize
                ascii = ichar(ibanRearrange(j:j))
                if ((ascii >= 65) .and. (ascii<=90)) then
                    write (temp,fmt='(I2)') ascii-55
                    ibantoint = trim(ibantoint) // temp
                else
                    ibantoint = trim(ibantoint) // ibanRearrange(j:j)
                end if
            end do
            if (mod97(ibantoint) == 1) then
                valid = .true.
            end if
        end if
    end function checkIBAN

    function mod97(strint) result(res)
        character(len=*), intent(in) :: strint
        integer :: i, num, res
        res = 0
        do  i=1, len(trim(strint))
            read(strint(i:i),*) num
            res = mod((res*10 + num),97);
        end do
    end function mod97

    function checkCountryCode(iban) result(ibanlength)
        character(len=*), intent(in) :: iban
        integer(int16) :: ibanlength, i
        ibanlength = 0
        do i=1, size(cc)
            if (iban(1:2) == cc(i)(1:2)) then
                read(cc(i)(3:4),*) ibanlength
                exit
            end if
        end do
    end function checkCountryCode

    Recursive Function Stripper(string,ch) Result(stripped)
        Implicit None
        character(len=*), intent(in) :: string
        character, intent(in) :: ch
        character(:), allocatable :: stripped

        IF (LEN(string)==1) THEN
           IF (string==ch) THEN
              stripped = ''
           ELSE
              stripped = string
           END IF
        ELSE
           IF (string(1:1)==ch) THEN
              stripped = stripper(string(2:),ch)
           ELSE
              stripped = string(1:1)//stripper(string(2:),ch)
           END IF
        END IF
    END Function stripper

    Function Remove_Blanks(string) Result(stripped)
        Implicit None
        character(len=*), intent(in) ::   string
        character(:), allocatable :: stripped

        stripped = trim(Stripper(trim(Stripper(string,' ')),achar(9)))
    END Function Remove_Blanks

end program ibancheck
