package Binary_Searches is

   subtype Item_Type is Integer; -- From specs.
   subtype Index_Type is Integer range 1 .. 100;
   type Array_Type is array (Index_Type range <>) of Item_Type;

   --  Ordered_Between is a 'proof function'.  It does not have a code
   --  body, but its meaning is defined by a proof rule:
   --
   --    Ordered_Between (Source, Low_Bound, High_Bound)
   --      <->
   --    for all I in Index_Type range Low_Bound .. High_Bound - 1 =>
   --             (Source(I) < Source(I + 1)) ;
   --
   --# function Ordered_Between (Source               : Array_Type;
   --#                           Range_From, Range_To : Index_Type)
   --#    return Boolean;

   procedure Search (Source   : in     Array_Type;
                     Item     : in     Item_Type;
                     Found    :     out Boolean;
                     Position :     out Index_Type);
   --# derives Found,
   --#         Position from
   --#            Source,
   --#            Item;
   --# pre  Ordered_Between (Source, Source'First, Source'Last);
   --# post (Found -> (Source (Position) = Item))
   --#  and (not Found ->
   --#         (for all I in Index_Type range Source'Range
   --#                                  => (Source(I) /= Item)));

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
      --# assert not Terminated
      --#   and  not Found
      --#   and  Lower >= Source'First
      --#   and  Upper <= Source'Last
      --#   and  Position in Lower .. Upper
      --#   and  (Lower = Source'First or
      --#         (Lower > Source'First and Source(Lower - 1) < Item))
      --#   and  (Upper = Source'Last or
      --#         (Upper < Source'Last and Source(Upper + 1) > Item));
         if Item < Source (Position) then
            if Position = Lower then
               -- No lower subrange.
               Terminated := True;
            else
               -- Switch to lower half subrange.
               Upper := Position - 1;
               Position := (Lower + Upper) / 2;
            end if;
         elsif Item > Source (Position) then
            if Position = Upper then
               -- No upper subrange.
               Terminated := True;
            else
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
