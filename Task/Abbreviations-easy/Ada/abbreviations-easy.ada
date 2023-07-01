with Ada.Characters.Handling;
with Ada.Containers.Indefinite_Vectors;
with Ada.Strings.Fixed;
with Ada.Strings.Maps.Constants;
with Ada.Text_IO;

procedure Abbreviations_Easy is

   package Command_Vectors
   is new Ada.Containers.Indefinite_Vectors (Index_Type   => Positive,
                                             Element_Type => String);
   use Command_Vectors;

   Commands : Vector;

   procedure Append (Word_List : String) is
      use Ada.Strings;
      First : Positive := Word_List'First;
      Last  : Natural;
   begin
      loop
         Fixed.Find_Token (Word_List,
                           Set   => Maps.Constants.Letter_Set,
                           From  => First,
                           Test  => Inside,
                           First => First,
                           Last  => Last);
         exit when Last = 0;
         Commands.Append (Word_List (First .. Last));
         exit when Last = Word_List'Last;
         First := Last + 1;
      end loop;
   end Append;

   function Match (Word : String) return String is
      use Ada.Strings;
      use Ada.Characters.Handling;
      Upper_Word   : constant String := To_Upper (Word);
      Prefix_First : Positive;
      Prefix_Last  : Natural;
   begin
      if Word = "" then
         return "";
      end if;

      for Command of Commands loop
         Fixed.Find_Token (Command, Maps.Constants.Upper_Set, Inside,
                           Prefix_First, Prefix_Last);
         declare
            Upper_Prefix  : constant String  := Command (Prefix_First .. Prefix_Last);
            Upper_Command : constant String  := To_Upper (Command);
            Valid_Length  : constant Boolean := Word'Length >= Upper_Prefix'Length;
            Match_Length  : constant Natural := Natural'Min (Word'Length,
                                                             Command'Length);
            Valid_Match   : constant Boolean
              := Fixed.Head (Upper_Word, Upper_Word'Length)
                = Fixed.Head (Upper_Command, Upper_Word'Length);
         begin
            if Valid_Length and Valid_Match then
               return Upper_Command;
            end if;
         end;
      end loop;
      return "*error*";
   end Match;

   procedure Put_Match (To : String) is
      use Ada.Text_IO;
      M : constant String := Match (To);
   begin
      Put ("Match to '");  Put (To);
      Put ("' is '");      Put (M);
      Put_Line ("'");
   end Put_Match;

   procedure A (Item : String) renames Append;
begin
   A ("Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy");
   A ("COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find");
   A ("NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput");
   A ("Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO");
   A ("MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT");
   A ("READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT");
   A ("RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up");

   Put_Match ("riG");
   Put_Match ("rePEAT");
   Put_Match ("copies");
   Put_Match ("put");
   Put_Match ("mo");
   Put_Match ("rest");
   Put_Match ("types");
   Put_Match ("fup.");
   Put_Match ("6");
   Put_Match ("poweRin");
   Put_Match ("");
   Put_Match ("o");
end Abbreviations_Easy;
