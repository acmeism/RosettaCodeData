with Ada.Characters.Handling;
with Ada.Containers.Vectors;
with Ada.Strings.Fixed;
with Ada.Strings.Maps.Constants;
with Ada.Strings.Unbounded;
with Ada.Text_IO;

procedure Abbreviations_Simple is

   use Ada.Strings.Unbounded;
   subtype Ustring is Unbounded_String;

   type Word_Entry is record
      Word : Ustring;
      Min  : Natural;
   end record;

   package Command_Vectors
   is new Ada.Containers.Vectors (Index_Type   => Positive,
                                  Element_Type => Word_Entry);

   Commands      : Command_Vectors.Vector;
   Last_Word     : Ustring;
   Last_Was_Word : Boolean := False;

   procedure Append (Word_List : String) is
      use Ada.Strings;

      function Is_Word (Item : String) return Boolean
      is (Fixed.Count (Item, Maps.Constants.Letter_Set) /= 0);

      procedure Process (Token : String) is
      begin
         if Is_Word (Token) then
            if Last_Was_Word then
               Commands.Append ((Word => Last_Word,
                                 Min  => Length (Last_Word)));
            end if;
            Last_Word     := To_Unbounded_String (Token);
            Last_Was_Word := True;

         else  -- Token is expected to be decimal
            Commands.Append ((Word => Last_Word,
                              Min  => Natural'Value (Token)));
            Last_Was_Word := False;
         end if;
      end Process;

      Token_First : Positive := Word_List'First;
      Token_Last  : Natural;
   begin
      while Token_First in Word_List'Range loop

         Fixed.Find_Token (Word_List, Maps.Constants.Alphanumeric_Set,
                           Token_First, Inside,
                           Token_First, Token_Last);
         exit when Token_Last = 0;

         Process (Word_List (Token_First .. Token_Last));

         Token_First := Token_Last + 1;
      end loop;
   end Append;

   function Match (Word : String) return String is
      use Ada.Characters.Handling;
      use Ada.Strings.Fixed;
      Result : Ustring := To_Unbounded_String ("*error*");
      Min    : Natural := 0;
      Upper_Word : constant String := To_Upper (Word);
   begin
      if Upper_Word = "" then
         return "";
      end if;

      for Candidate of Commands loop
         declare
            Upper_Cand : constant String  := To_Upper (To_String (Candidate.Word));
            Length     : constant Natural := Natural'Max (Candidate.Min,
                                                          Upper_Word'Length);
            Upper_Abbrev_Cand : constant String := Head (Upper_Cand, Length);
            Upper_Abbrev_Word : constant String := Head (Upper_Word, Length);
         begin
            if Upper_Word = Upper_Cand
              and then Upper_Word'Length > Min
            then
               Result := To_Unbounded_String (Upper_Cand);
               Min    := Upper_Word'Length;
            elsif Upper_Abbrev_Word = Upper_Abbrev_Cand
              and then Upper_Abbrev_Word'Length > Min
            then
               Result := To_Unbounded_String (Upper_Cand);
               Min    := Upper_Abbrev_Word'Length;
            end if;
         end;
      end loop;
      return To_String (Result);
   end Match;

   procedure Put_Match (To : String) is
      use Ada.Text_IO;
   begin
      Put ("Match to '");  Put (To);
      Put ("' is '");      Put (Match (To));
      Put_Line ("'");
   end Put_Match;

   procedure A (Item : String) renames Append;
begin
   A ("add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3");
   A ("compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate");
   A ("3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2");
   A ("forward 2  get  help 1 hexType 4  input 1 powerInput 3  join 1 split 2 spltJOIN load");
   A ("locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2");
   A ("msg  next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit  read recover 3");
   A ("refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left");
   A ("2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1");

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
end Abbreviations_Simple;
