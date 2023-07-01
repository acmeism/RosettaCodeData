module sha1_mod
    use kernel32
    use advapi32
    implicit none
    integer, parameter :: SHA1LEN = 20
contains
    subroutine sha1hash(name, hash, dwStatus, filesize)
        implicit none
        character(*) :: name
        integer, parameter :: BUFLEN = 32768
        integer(HANDLE) :: hFile, hProv, hHash
        integer(DWORD) :: dwStatus, nRead
        integer(BOOL) :: status
        integer(BYTE) :: buffer(BUFLEN)
        integer(BYTE) :: hash(SHA1LEN)
        integer(UINT64) :: filesize

        dwStatus = 0
        filesize = 0
        hFile = CreateFile(trim(name) // char(0), GENERIC_READ, FILE_SHARE_READ, NULL, &
                           OPEN_EXISTING, FILE_FLAG_SEQUENTIAL_SCAN, NULL)

        if (hFile == INVALID_HANDLE_VALUE) then
            dwStatus = GetLastError()
            print *, "CreateFile failed."
            return
        end if

        if (CryptAcquireContext(hProv, NULL, NULL, PROV_RSA_FULL, &
                                CRYPT_VERIFYCONTEXT) == FALSE) then

            dwStatus = GetLastError()
            print *, "CryptAcquireContext failed."
            goto 3
        end if

        if (CryptCreateHash(hProv, CALG_SHA1, 0_ULONG_PTR, 0_DWORD, hHash) == FALSE) then

            dwStatus = GetLastError()
            print *, "CryptCreateHash failed."
            go to 2
        end if

        do
            status = ReadFile(hFile, loc(buffer), BUFLEN, nRead, NULL)
            if (status == FALSE .or. nRead == 0) exit
            filesize = filesize + nRead
            if (CryptHashData(hHash, buffer, nRead, 0) == FALSE) then
                dwStatus = GetLastError()
                print *, "CryptHashData failed."
                go to 1
            end if
        end do

        if (status == FALSE) then
            dwStatus = GetLastError()
            print *, "ReadFile failed."
            go to 1
        end if

        nRead = SHA1LEN
        if (CryptGetHashParam(hHash, HP_HASHVAL, hash, nRead, 0) == FALSE) then
            dwStatus = GetLastError()
            print *, "CryptGetHashParam failed.", status, nRead, dwStatus
        end if

      1 status = CryptDestroyHash(hHash)
      2 status = CryptReleaseContext(hProv, 0)
      3 status = CloseHandle(hFile)
    end subroutine
end module

program sha1
    use sha1_mod
    implicit none
    integer :: n, m, i, j
    character(:), allocatable :: name
    integer(DWORD) :: dwStatus
    integer(BYTE) :: hash(SHA1LEN)
    integer(UINT64) :: filesize

    n = command_argument_count()
    do i = 1, n
        call get_command_argument(i, length=m)
        allocate(character(m) :: name)
        call get_command_argument(i, name)
        call sha1hash(name, hash, dwStatus, filesize)
        if (dwStatus == 0) then
            do j = 1, SHA1LEN
                write(*, "(Z2.2)", advance="NO") hash(j)
            end do
            write(*, "(' ',A,' (',G0,' bytes)')") name, filesize
        end if
        deallocate(name)
    end do
end program
