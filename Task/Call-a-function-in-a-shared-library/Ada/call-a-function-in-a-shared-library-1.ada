with Ada.Text_IO;   use Ada.Text_IO;
with Interfaces;    use Interfaces;
with Interfaces.C;  use Interfaces.C;
with System;        use System;

with Ada.Unchecked_Conversion;

procedure Shared_Library_Call is
   --
   -- Interface to kernel32.dll which is resposible for loading DLLs under Windows.
   -- There are ready to use Win32 binding. We don't want to use them here.
   --
   type HANDLE is new Unsigned_32;
   function LoadLibrary (lpFileName : char_array) return HANDLE;
   pragma Import (stdcall, LoadLibrary, "LoadLibrary", "_LoadLibraryA@4");

   function GetProcAddress (hModule : HANDLE; lpProcName : char_array)
      return Address;
   pragma Import (stdcall, GetProcAddress, "GetProcAddress", "_GetProcAddress@8");
   --
   -- The interface of the function we want to call. It is a pointer (access type)
   -- because we will link it dynamically. The function is from User32.dll
   --
   type MessageBox is access function
        (  hWnd      : Address     := Null_Address;
           lpText    : char_array;
           lpCaption : char_array  := To_C ("Greeting");
           uType     : Unsigned_16 := 0
        )  return Integer_16;
   pragma Convention (Stdcall, MessageBox);
   function To_MessageBox is new Ada.Unchecked_Conversion (Address, MessageBox);

   Library : HANDLE  := LoadLibrary (To_C ("user32.dll"));
   Pointer : Address := GetProcAddress (Library, To_C ("MessageBoxA"));
begin
   if Pointer /= Null_Address then
      declare
         Result : Integer_16;
      begin
         Result := To_MessageBox (Pointer) (lpText => To_C ("Hello!"));
      end;
   else
      Put_Line ("Unable to load the library " & HANDLE'Image (Library));
   end if;
end Shared_Library_Call;
