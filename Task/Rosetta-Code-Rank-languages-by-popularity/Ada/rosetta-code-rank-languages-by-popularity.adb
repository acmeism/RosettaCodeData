pragma Ada_2022;

with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Fixed;     use Ada.Strings.Fixed;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO;           use Ada.Text_IO;

with Ada.Containers.Ordered_Sets;
with Ada.Strings.Unbounded.Less_Case_Insensitive;
with Ada.Characters.Handling; use Ada.Characters.Handling;

with AWS.Client;            use AWS.Client;
with AWS.Messages;          use AWS.Messages;
with AWS.Response;

procedure Rank_Languages_By_Popularity is

   use Ada.Strings;

   function "+" (S : String) return Unbounded_String
                 renames To_Unbounded_String;

   type A_Language_Count is
      record
         Count    : Natural := 0;
         Language : Unbounded_String;
      end record;

   function "=" (L, R : A_Language_Count) return Boolean is
   begin
      return L.Language = R.Language;
   end "=";

   function "<" (L, R : A_Language_Count) return Boolean is
   begin
      --  Sort by 'Count' and then by Language name
      return L.Count < R.Count
        or else (L.Count = R.Count
                 and then Less_Case_Insensitive
                   (Left  => L.Language,
                    Right => R.Language));
   end "<";

   package Sets is new Ada.Containers.Ordered_Sets (A_Language_Count);
   use Sets;

   Counts : Set;

   procedure Find_Counts (S : String) is

      function Strip_Character (S : String; C : Character) return String is
         S_Copy_Str   : String (1 .. S'Length);
         S_Copy_Index : Natural := 0;
      begin
         for I in S'Range loop
            if S (I) /= C then
               S_Copy_Index := S_Copy_Index + 1;
               S_Copy_Str (S_Copy_Index) := S (I);
            end if;
         end loop;

         return S_Copy_Str (S_Copy_Str'First .. S_Copy_Index);
      end Strip_Character;

      function Ignore_Category (L : String) return Boolean is
         type Unbounded_String_Array is array (Positive range <>)
           of Unbounded_String;
         --  This list is quite comprehensive, but not complete
         Categories_To_Ignore : Unbounded_String_Array := [
               +"Pages with syntax highlighting errors",
               +"Programming",
               +"Examples needing attention",
               +"Tasks needing attention",
               +"Language users",
               +"Implementations",
               +"Solutions by ",
               +"Maintenance/OmitCategoriesCreated",
               +"Collection Members",
               +"Pages with too many expensive parser function calls",
               +"Garbage collection",
               +" User",
               +"SQL User",
               +"Typing",
               +"Parameter passing",
               +"Execution method",
               +"Unimplemented tasks by language",
               +"Wolfram Language",
               +"/Omit",
               +"Wren-",
               +"WrenGo",
               +"Phix/",
               +"PhixClass",
               +"Basic language learning",
               +"Encyclopedia",
               +"RCTemplates",
               +"SysUtils",
               +"Action! ",
               +"Text processing",
               +"Image processing",
               +"Scala Digital Signal Processing",
               +"List processing",
               +"Digital signal processing",
               +"Processing Python",
               +"Classic CS problems and programs",
               +"Brainf*** related",
               +"Data Structures",
               +"Perl modules",
               +"Perl/",
               +"Perl:LWP",
               +"Perl 6 related",
               +"Flow control",
               +"Excessively difficult task",
               +"WikiStubs",
               +"Impl needed",
               +"Recursion"
              ];
      begin
         for Category of Categories_To_Ignore loop
            declare
               Category_At : constant Natural :=
                               Index (+To_Lower (L),
                                      To_Lower (To_String (Category)));
            begin
               if Category_At /= 0 then
                  return True;
               end if;
            end;
         end loop;

         return False;
      end Ignore_Category;

      Title_Str       : constant String := "title=""Category:";
      End_A_Tag_Str   : constant String := "</a>";
      Space_Paren_Str : constant String := " (";

      Title_At        : constant Natural := Index (S, Title_Str);
   begin
      if Title_At /= 0 then
         declare
            Closing_Bracket_At : constant Natural :=
               Index (S (Title_At + Title_Str'Length .. S'Last), ">");

            End_A_Tag_At       : constant Natural :=
               Index (S (Closing_Bracket_At + 1 .. S'Last), End_A_Tag_Str);

            Language : constant String  :=
               S (Closing_Bracket_At + 1 .. End_A_Tag_At - 1);

            Space_Paren_At     : constant Natural :=
               Index (S (End_A_Tag_At + 1 .. S'Last), Space_Paren_Str);

            Space_At           : constant Natural :=
               Index (S (Space_Paren_At + Space_Paren_Str'Length + 1
                      .. S'Last),
                      " ");

            Count : constant Natural :=
                      Natural'Value (
                                     Strip_Character (
                                       S (Space_Paren_At +
                                           Space_Paren_Str'Length
                                         .. Space_At - 1),
                                      ','));
         begin
            if Closing_Bracket_At /= 0
              and then End_A_Tag_At /= 0
              and then Space_Paren_At /= 0
              and then Space_At /= 0
            then
               begin
                  if Ignore_Category (Language) = False then
                     Counts.Insert (New_Item => (Count, +Language));
                  end if;
               exception
                  when Constraint_Error =>
                     Put_Line (Standard_Error, "Warning: repeated language: " &
                                 Language);
                     --  Ignore repeated results.
                     null;
               end;
            end if;
            --  Recursively parse the string for languages and counts
            Find_Counts (S (Space_At + 1 .. S'Last));
         end;
      end if;

   end Find_Counts;

   Place : Natural := 1;

   procedure Display (C : Cursor) is
   begin
      Put (Place, Width => 1);             Put (". ");
      Put (Element (C).Count, Width => 1); Put (" - ");
      Put_Line (To_String (Element (C).Language));
      Place := Place + 1;
   end Display;

   Http_Source : constant AWS.Response.Data :=
                   AWS.Client.Get ("http://rosettacode.org/w/index.php?" &
                                   "title=Special:Categories&limit=5000",
                                   Follow_Redirection => True);
   Status      : Status_Code;
begin
   Put_Line ("Getting website data...");

   Status := AWS.Response.Status_Code (Http_Source);
   if Status not in Success then
      Put_Line ("Unable to retrieve data => Status Code :" &
                  Image (Status) &
                  " Reason :" & Reason_Phrase (Status));
      raise Connection_Error;
   end if;

   Put_Line ("Finding categories...");
   Find_Counts (AWS.Response.Message_Body (Http_Source));

   Put_Line ("Displaying categories...");
   Counts.Reverse_Iterate (Display'Access);

   Put_Line ("Process complete.");
end Rank_Languages_By_Popularity;
