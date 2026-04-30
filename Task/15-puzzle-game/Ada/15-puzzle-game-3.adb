with Generic_Puzzle, Ada.Text_IO,
     Ada.Numerics.Discrete_Random, Ada.Command_Line;

procedure Puzzle_15 is

   function Image(N: Natural) return String is
      (if N=0 then "   " elsif N < 10 then " " & Integer'Image(N)
	else Integer'Image(N));
	
   package Puzzle is new Generic_Puzzle(Rows => 4, Cols => 4, Name => Image);

   package Rnd is new Ada.Numerics.Discrete_Random(Puzzle.Moves);
   Rand_Gen: Rnd.Generator;

   Level: Natural := (if Ada.Command_Line.Argument_Count = 0 then 10
                      else Natural'Value(Ada.Command_Line.Argument(1)));
   Initial_Moves: Natural := (2**(Level/2) + 2**((1+Level)/2))/2;
   Texts: constant array(Puzzle.Moves) of String(1..9) :=
       ("u,U,^,8: ", "d,D,v,2: ", "l,L,<,4: ", "r,R,>,6: ");
   Move_Counter: Natural := 0;
   Command: Character;

 begin
    -- randomize board
    for I in 1 .. Initial_Moves loop
       declare
	  M: Puzzle.Moves := Rnd.Random(Rand_Gen);
       begin
	  if Puzzle.Possible(M) then
	     Puzzle.Move(M);
	  end if;
       end;
    end loop;

    -- read command and perform move	
    loop
      -- Print board
      for R in Puzzle.Row_Type loop
	 for C in Puzzle.Col_Type loop
	    Ada.Text_IO.Put(Puzzle.Get_Point(R, C));
	 end loop;
	 Ada.Text_IO.New_Line;
      end loop;
      Ada.Text_IO.Get(Command);
      begin
	 case Command is
	    when 'u' | 'U' | '^' | '8' =>
	       Ada.Text_IO.Put_Line("Up!"); Puzzle.Move(Puzzle.Up);
	    when 'd' | 'D' | 'v' | '2' =>
	       Ada.Text_IO.Put_Line("Down!"); Puzzle.Move(Puzzle.Down);
	    when 'l' | 'L' | '<' | '4' =>
	       Ada.Text_IO.Put_Line("Left!"); Puzzle.Move(Puzzle.Left);
	    when 'r' | 'R' | '>' | '6' =>
	       Ada.Text_IO.Put_Line("Right!"); Puzzle.Move(Puzzle.Right);
	    when '!' =>
	       Ada.Text_IO.Put_Line(Natural'Image(Move_Counter) & " moves!");
	       exit;
	    when others =>
	       raise Constraint_Error with "wrong input";
	 end case;
	 Move_Counter := Move_Counter + 1;
      exception when Constraint_Error =>
	 Ada.Text_IO.Put_Line("Possible Moves and Commands:");
	 for M in Puzzle.Moves loop
	    if Puzzle.Possible(M) then
	       Ada.Text_IO.Put(Texts(M) & Puzzle.Moves'Image(M) & "   ");
	    end if;
	 end loop;
	 Ada.Text_IO.Put_Line("!: Quit");
      end;
   end loop;
end Puzzle_15;
