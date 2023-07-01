module kernel32
    use iso_c_binding
    implicit none
    integer, parameter :: HANDLE = C_INTPTR_T
    integer, parameter :: PVOID = C_INTPTR_T
    integer, parameter :: BOOL = C_INT

    interface
        function LoadLibrary(lpFileName) bind(C, name="LoadLibraryA")
            import C_CHAR, HANDLE
            !GCC$ ATTRIBUTES STDCALL :: LoadLibrary
            integer(HANDLE) :: LoadLibrary
            character(C_CHAR) :: lpFileName
        end function
    end interface

    interface
        function FreeLibrary(hModule) bind(C, name="FreeLibrary")
            import HANDLE, BOOL
            !GCC$ ATTRIBUTES STDCALL :: FreeLibrary
            integer(BOOL) :: FreeLibrary
            integer(HANDLE), value :: hModule
        end function
    end interface

    interface
        function GetProcAddress(hModule, lpProcName) bind(C, name="GetProcAddress")
            import C_CHAR, PVOID, HANDLE
            !GCC$ ATTRIBUTES STDCALL :: GetProcAddress
            integer(PVOID) :: GetProcAddress
            integer(HANDLE), value :: hModule
            character(C_CHAR) :: lpProcName
        end function
    end interface
end module
