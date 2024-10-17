-- Rosetta Code Task written in Ada
-- Determine sentence type
-- https://rosettacode.org/wiki/Determine_sentence_type
-- July 2024, R. B. E.

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

procedure Determine_Sentence_Type is
  S1 : String := "hi there, how are you today?";
  S2 : String := "I'd like to present to you the washing machine 9001.";
  S3 : String := "You have been nominated to win one of these!";
  S4 : String := "Just make sure you don't break it";

  procedure Just_Do_It (S: String) is
  begin
    if (S'Last = 0) then
      Put_Line ("Error: The provided sentence was empty.");
    else
      case S (S'Last) is
        when '?' => Put ("Q: ");
        when '.' => Put ("S: ");
        when '!' => Put ("E: ");
        when others => Put ("N: ");
      end case;
      Put_Line (S);
    end if;
  end Just_Do_It;

begin
  Just_Do_It (S1);
  Just_Do_It (S2);
  Just_Do_It (S3);
  Just_Do_It (S4);
end Determine_Sentence_Type;
