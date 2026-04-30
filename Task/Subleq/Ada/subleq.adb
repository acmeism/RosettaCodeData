with Ada.Text_IO;

procedure Subleq is

   Storage_Size: constant Positive := 2**8; -- increase or decrease memory
   Steps: Natural := 999; -- "emergency exit" to stop endless loops

   subtype Address is Integer range -1 .. (Storage_Size-1);
   subtype Memory_Location is Address range 0 .. Address'Last;

   type Storage is array(Memory_Location) of Integer;

   package TIO renames Ada.Text_IO;
   package IIO is new TIO.Integer_IO(Integer);

   procedure Read_Program(Mem: out Storage) is
      Idx: Memory_Location := 0;
   begin
      while not TIO.End_Of_Line loop
	 IIO.Get(Mem(Idx));
 	 Idx := Idx + 1;
      end loop;
   exception
      when others => TIO.Put_Line("Reading program: Something went wrong!");
   end Read_Program;

   procedure Execute_Program(Mem: in out Storage) is
      PC: Integer := 0; -- program counter
      function Source return Integer is (Mem(PC));
      function Dest return Integer is (Mem(PC+1));
      function Branch return Integer is (Mem(PC+2));
      function Next return Integer is (PC+3);
   begin
      while PC >= 0 and Steps >= 0 loop
	 Steps := Steps -1;
	 if Source = -1 then -- read input
            declare
               Char: Character;
            begin
               TIO.Get (Char);
               Mem(Dest) := Character'Pos (Char);
            end;
	    PC := Next;
	 elsif Dest = -1 then -- write output
	    TIO.Put(Character'Val(Mem(Source)));
	    PC := Next;
	 else -- subtract and branch if less or equal
	    Mem(Dest) := Mem(Dest) - Mem(Source);
	    if Mem(Dest) <= 0 then
	       PC := Branch;
	    else
	       PC := Next;
	    end if;
	 end if;
      end loop;
      TIO.Put_Line(if PC >= 0 then "Emergency exit: program stopped!" else "");
    exception
      when others => TIO.Put_Line("Failure when executing Program");
   end Execute_Program;

   Memory: Storage := (others => 0); -- no initial "junk" in memory!

begin

   Read_Program(Memory);
   Execute_Program(Memory);

end Subleq;
