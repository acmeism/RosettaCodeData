package Binary_Searches is

   subtype Item_Type is Integer; -- From specs.
   subtype Index_Type is Integer range 1 .. 100;
   type Array_Type is array (Index_Type range <>) of Item_Type;

   procedure Search (Source   : in     Array_Type;
                     Item     : in     Item_Type;
                     Found    :     out Boolean;
                     Position :     out Index_Type);
   --# derives Found,
   --#         Position from
   --#            Source,
   --#            Item;
   --# post Found -> Source (Position) = Item;
   -- If Found is False then Position is undefined.

end Binary_Searches;


package body Binary_Searches is

   procedure Search (Source   : in     Array_Type;
                     Item     : in     Item_Type;
                     Found    :     out Boolean;
                     Position :     out Index_Type)
   is
      Lower      : Index_Type; -- Lower bound of Subrange.
      Upper      : Index_Type; -- Upper bound of Subrange.
      Terminated : Boolean;
   begin
      Found := False;
      -- Default status updated on success.

      Lower      := Source'First;
      Upper      := Source'Last;
      Position   := (Lower + Upper) / 2;
      Terminated := False;

      while not Terminated loop
      --# assert Lower >= Source'First
      --#  and   Upper <= Source'Last
      --#  and   Position in Lower .. Upper
      --#  and   not Found;
         if Item < Source (Position) then
            if Position = Lower then
               -- No lower subrange.
               Terminated := True;
            else
               --# check Position > Lower;
               -- For the two following proofs.

               --# check Position - 1 >= Lower;
               --# check Lower + Position - 1 >= Lower * 2;
               --# check (Lower + Position - 1) / 2 >= Lower;
               -- For "Position >= Lower" in loop assertion.

               --# check Lower < Position;
               --# check Lower + Position - 1 <= (Position - 1) * 2;
               --# check (Lower + Position - 1) / 2 <= (Position - 1);
               -- For "Position <= Upper" in loop assertion.

               -- Switch to lower half subrange.
               Upper := Position - 1;
               Position := (Lower + Upper) / 2;
            end if;

         elsif Item > Source (Position) then
            if Position = Upper then
               -- No upper subrange.
               Terminated := True;
            else
               --# check Position < Upper;
               -- For the two following proofs.

               --# check Upper >= Position + 1;
               --# check Position + 1 + Upper >= (Position + 1) * 2;
               --# check (Position + 1 + Upper) / 2 >= (Position + 1);
               -- For "Position >= Lower" in loop assertion.

               --# check Position + 1 <= Upper;
               --# check Position + 1 + Upper <= Upper * 2;
               --# check (Position + 1 + Upper) / 2 <= Upper;
               -- For "Position <= Upper" in loop assertion.

               -- Switch to upper half subrange.
               Lower := Position + 1;
               Position := (Lower + Upper) / 2;
            end if;
         else
            Found      := True;
            Terminated := True;
         end if;
      end loop;
   end Search;

end Binary_Searches;
