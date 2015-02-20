Function Connection_Combinations return Partial_Board is

begin
   Return Result : Board do
      declare

         -- The Generate task takes two parameters
         --   (1) a list of pegs already in use, and
         --   (2) a partial-board
         -- and, if the state given is a viable yet incomplete solution, it
         -- takes a peg and adds it to the state creating a new task with
         -- that peg in its used list.
         --
         -- When a complete solution is found it is copied into result.
         task type Generate(
                            Pegs	: not null access Used_Peg:= new Used_Peg'(others => False);
                            State	: not null access Partial_Board:= new Partial_Board'(Node'Last..Node'First => <>)
                           ) is
         end Generate;

         -- An access to Generate and array thereof, for creating the
         -- children tasks.
         type Generator  is access all Generate;
         type Generators is array(Peg range <>) of Generator;

         -- Gen handles the actual creation of a new task and state.
         Function Gen(P : Peg; G : not null access Generate) return Generator is
         begin
            return (if G.Pegs(P) then null
                    else new Generate(
                      Pegs     => new Used_Peg'(G.Pegs.all & P),
                      State    => New Partial_Board'(G.All.State.All & P)
                     )
                   );
         end;

         task body Generate is
         begin
            if Is_Solution(State.All) then
               -- If the state is a partial board, we make children to
               -- complete the calculations.
               if State'Length <= Node'Pos(Node'Last) then
                  declare
                     Subtasks : Constant Generators:=
                       (
                        Gen(1, Generate'Access),
                        Gen(2, Generate'Access),
                        Gen(3, Generate'Access),
                        Gen(4, Generate'Access),
                        Gen(5, Generate'Access),
                        Gen(6, Generate'Access),
                        Gen(7, Generate'Access),
                        Gen(8, Generate'Access)
                       );
                  begin
                     null;
                  end;
               else
                  Result:= State.All;
               end if;
            else
               -- The current state is not a solution, so we do not continue it.
               Null;
            end if;

         end Generate;

         Master : Generate;
      begin
         null;
      end;
   End return;
End Connection_Combinations;
