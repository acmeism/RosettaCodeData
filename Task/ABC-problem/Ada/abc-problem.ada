with Ada.Characters.Handling;
use Ada.Characters.Handling;


package Abc is
    type Block_Faces is array(1..2) of Character;
    type Block_List is array(positive range <>) of Block_Faces;
    function Can_Make_Word(W: String; Blocks: Block_List) return Boolean;
end Abc;


package body Abc is

function Can_Make_Word(W: String; Blocks: Block_List) return Boolean is
    Used : array(Blocks'Range) of Boolean := (Others => False);
    subtype wIndex is Integer range W'First..W'Last;
    wPos : wIndex;
begin
    if W'Length = 0 then
        return True;
    end if;
    wPos := W'First;
    while True loop
        declare
            C : Character := To_Upper(W(wPos));
            X : constant wIndex := wPos;
        begin
            for I in Blocks'Range loop
                if (not Used(I)) then
                    if C = To_Upper(Blocks(I)(1)) or C = To_Upper(Blocks(I)(2)) then
                        Used(I) := True;
                        if wPos = W'Last then
                            return True;
                        end if;
                        wPos := wIndex'Succ(wPos);
                        exit;
                    end if;
                end if;
            end loop;
            if X = wPos then
                return False;
            end if;
        end;
    end loop;
    return False;
end Can_Make_Word;

end Abc;

with Ada.Text_IO, Ada.Strings.Unbounded, Abc;
use Ada.Text_IO, Ada.Strings.Unbounded, Abc;

procedure Abc_Problem is
    Blocks : Block_List := (
          ('B','O'), ('X','K'), ('D','Q'), ('C','P')
        , ('N','A'), ('G','T'), ('R','E'), ('T','G')
        , ('Q','D'), ('F','S'), ('J','W'), ('H','U')
        , ('V','I'), ('A','N'), ('O','B'), ('E','R')
        , ('F','S'), ('L','Y'), ('P','C'), ('Z','M')
    );
    function "+" (S : String) return Unbounded_String renames To_Unbounded_String;
    words : array(positive range <>) of Unbounded_String := (
          +"A"
        , +"BARK"
        , +"BOOK"
        , +"TREAT"
        , +"COMMON"
        , +"SQUAD"
        , +"CONFUSE"
        -- Border cases:
        -- , +"CONFUSE2"
        -- , +""
    );
begin
    for I in words'Range loop
        Put_Line ( To_String(words(I)) & ": " & Boolean'Image(Can_Make_Word(To_String(words(I)),Blocks)) );
    end loop;
end Abc_Problem;
