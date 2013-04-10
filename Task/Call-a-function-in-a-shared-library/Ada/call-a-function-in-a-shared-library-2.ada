with Ada.Environment_Variables;  use Ada.Environment_Variables;
with Ada.Text_IO;                use Ada.Text_IO;
with Interfaces;                 use Interfaces;
with Interfaces.C;               use Interfaces.C;
with System;                     use System;

with Ada.Unchecked_Conversion;

procedure Shared_Library_Call is
   --
   -- Interface to libdl to load dynamically linked libraries
   --
   function dlopen (FileName : char_array; Flag : int) return Address;
   pragma Import (C, dlopen);

   function dlsym (Handle : address; Symbol : char_array) return Address;
   pragma Import (C, dlsym);
   --
   -- The interfaces of the functions we want to call. These are pointers
   -- (access type) because we will link it dynamically. The functions
   -- come from libX11.so.
   --
   type XOpenDisplay is access function (Display_Name : char_array) return Address;
   pragma Convention (C, XOpenDisplay);
   function To_Ptr is new Ada.Unchecked_Conversion (Address, XOpenDisplay);

   type XDisplayWidth is access function (Display : Address; Screen : int) return int;
   pragma Convention (C, XDisplayWidth);
   function To_Ptr is new Ada.Unchecked_Conversion (Address, XDisplayWidth);

   Library : Address := dlopen (To_C ("libX11.so"), 1);
   OpenDisplay  : XOpenDisplay  := To_Ptr (dlsym (Library, To_C ("XOpenDisplay")));
   DisplayWidth : XDisplayWidth := To_Ptr (dlsym (Library, To_C ("XDisplayWidth")));
begin
   if OpenDisplay /= null and then DisplayWidth /= null then
      declare
         Display : Address;
      begin
         Display := OpenDisplay (To_C (Value ("DISPLAY")));
         if Display = Null_Address then
            Put_Line ("Unable to open display " & Value ("DISPLAY"));
         else
            Put_Line (Value ("DISPLAY") & " width is" & int'image (DisplayWidth (Display, 0)));
         end if;
      end;
   else
      Put_Line ("Unable to load the library");
   end if;
end Shared_Library_Call;
