with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters; use Ada.Characters;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings; use Ada.Strings;

-- procedure main - begins program execution
procedure main is
    type Sketch_Pad is array(1 .. 50, 1 .. 50) of Character;
    thePen : Boolean := True; -- pen raised by default
    sketch : Sketch_Pad;
    ycorr, xcorr : Integer := 25;

    -- specifications
    function penPosition(thePen : in out Boolean) return String;
    procedure initGrid(sketch : in out Sketch_Pad);
    procedure commandMenu(thePen : in out Boolean; xcorr : in out Integer;
                          ycorr : in out Integer);
    procedure showMenu(xcorr : in out Integer; ycorr : in out Integer;
                       thePen : in out Boolean; sketch : in Sketch_Pad);
    procedure moveCursor(thePen : in Boolean; sketch : in out Sketch_Pad;
                         xcorr : in out Integer; ycorr : in out Integer;
                         ch : in Integer);
    procedure showGrid(sketch : in Sketch_Pad);

    -- procedure initGrid - creates the sketchpad and initializes elements
    procedure initGrid(sketch : in out Sketch_Pad) is
    begin
        sketch := (others => (others => ' '));
    end initGrid;

    -- procedure showMenu - displays the menu for the application
    procedure showMenu(xcorr : in out Integer; ycorr : in out Integer;
                       thePen : in out Boolean; sketch : in Sketch_Pad) is

        choice : Integer := 0;
    begin
        while choice /= 4 loop
            Set_Col(15);
            Put("TURTLE GRAPHICS APPLICATION");
            Set_Col(15);
            Put("===========================");
            New_Line(2);

            Put_Line("Enter 1 to print the grid map");
            Put_Line("Enter 2 for command menu");
            Put_Line("Enter 3 to raise pen up / down");
            Put_Line("Enter 4 to exit the application");
            choice := integer'value(Get_Line);

            exit when choice = 4;

            case choice is
                when 1 => showGrid(sketch);
                when 2 => commandMenu(thePen, xcorr, ycorr);
                when 3 => Put_Line("Pen is "
                              & penPosition(thePen));
                when others => Put_Line("Invalid input");
            end case;
        end loop;
    end showMenu;

    -- function penPosition - checks changes the state of whether the pen is
    -- raised up or down. If value is True, pen is rasied up
    function penPosition(thePen : in out Boolean) return String is
        str1 : constant String := "raised UP";
        str2 : constant String := "raised DOWN";
    begin
        if thePen = True then
            thePen := False;
            return str2;
        else
            thePen := True;
        end if;

        return str1;
    end penPosition;

    -- procedure command menu - provides a list of directions for the turtle
    -- to move along the grid
    procedure commandMenu(thePen : in out Boolean; xcorr : in out Integer;
                          ycorr : in  out Integer) is

        choice : Integer := 0;
    begin
        while choice <= 0 or choice > 5 loop
            Set_Col(15);
            Put("Command Menu");
            Set_Col(15);
            Put("============");
            New_Line(2);

            Put_Line("To move North enter 1");
            Put_Line("To move South enter 2");
            Put_Line("To move East enter 3");
            Put_Line("To move West enter 4");
            Put_Line("To return to previous menu enter 5");
            choice := integer'value(Get_Line);

            case choice is
                when 1 => moveCursor(thePen, sketch, xcorr, ycorr, choice);
                when 2 => moveCursor(thePen, sketch, xcorr, ycorr, choice);
                when 3 => moveCursor(thePen, sketch, xcorr, ycorr, choice);
                when 4 => moveCursor(thePen, sketch, xcorr, ycorr, choice);
                when 5 => showMenu(xcorr, ycorr, thePen, sketch);
                when others => Put_Line("Invalid choice");
            end case;
        end loop;
    end commandMenu;


    -- procedure moveCursor - moves the cursor around the board by taking the
    -- x and y coordinates from the user. If the pen is down, a character is
    -- printed at that location. If the pen is up, nothing is printed but the
    -- cursor still moves to that position
    procedure moveCursor(thePen : in Boolean; sketch : in out Sketch_Pad;
                         xcorr : in out Integer; ycorr : in out Integer;
                         ch : in Integer) is

    begin
        if thePen = True then -- pen up so move cursor but do not draw
            case ch is
                when 1 => xcorr := xcorr - 1; ycorr := ycorr;
                    sketch(xcorr, ycorr) := ' ';
                when 2 => xcorr := xcorr + 1; ycorr := ycorr;
                    sketch(xcorr, ycorr) := ' ';
                when 3 => xcorr := xcorr; ycorr := ycorr + 1;
                    sketch(xcorr, ycorr) := ' ';
                when 4 => xcorr := xcorr; ycorr := ycorr - 1;
                    sketch(xcorr, ycorr) := ' ';
                when others => Put("Unreachable Code");
            end case;

        else -- pen is down so move cursor and draw
            case ch is
                when 1 => xcorr := xcorr - 1; ycorr := ycorr;
                    sketch(xcorr, ycorr) := '#';
                when 2 => xcorr := xcorr + 1; ycorr := ycorr;
                    sketch(xcorr, ycorr) := '#';
                when 3 => xcorr := xcorr; ycorr := ycorr + 1;
                    sketch(xcorr, ycorr) := '#';
                when 4 => xcorr := xcorr; ycorr := ycorr - 1;
                    sketch(xcorr, ycorr) := '#';
                when others => Put("Unreachable Code");
            end case;
        end if;
    end moveCursor;

    -- procedure showGrid - prints the sketchpad showing the plotted moves
    procedure showGrid(sketch : in Sketch_Pad) is
    begin
        New_Line;

        for I in sketch'Range(1) loop
            for J in sketch'Range(2) loop
                Put(character'image(sketch(I,J)));
            end loop;
            New_Line;
        end loop;
        New_Line;
    end showGrid;

begin
    New_Line;

    initGrid(sketch);
    showMenu(xcorr, ycorr, thePen, sketch);

   New_Line;
end main;
