Pragma Ada_2012;

Package Body Connection_Types is

   New_Line : Constant String := ASCII.CR & ASCII.LF;

   ---------------------
   --  Solution Test  --
   ---------------------

   Function Is_Solution( Input : Partial_Board ) return Boolean is
     (for all Index in Input'Range =>
        (for all Connection in Node'Range =>
             (if Network(Index)(Connection) and Connection in Input'Range
              then abs (Input(Index) - Input(Connection)) > 1
             )
        )
     );

   ------------------------
   --  Concat Operators  --
   ------------------------

   Function "&"( Left : Used_Peg; Right : Peg ) return Used_Peg is
   begin
      return Result : Used_Peg := Left do
         Result(Right):= True;
      end return;
   end "&";

   Function "&"(Left : Connection_List; Right : Node) return Connection_List is
   begin
      Return Result : Connection_List := Left do
         Result(Right):= True;
      end return;
   end "&";

   -----------------------
   --  IMAGE FUNCTIONS  --
   -----------------------

   Function Image(Input : Peg) Return Character is
     ( Peg'Image(Input)(2) );

   Function Image(Input : Peg) Return String is
     ( 1 => Image(Input) );

   Function Image(Input : Partial_Board; Item : Node) Return String is
     ( 1 => (if Item not in Input'Range then '*' else Image(Input(Item)) ));

   Function Image( Input : Partial_Board ) Return String is
      A : String renames Image(Input, Connection_Types.A);
      B : String renames Image(Input, Connection_Types.B);
      C : String renames Image(Input, Connection_Types.C);
      D : String renames Image(Input, Connection_Types.D);
      E : String renames Image(Input, Connection_Types.E);
      F : String renames Image(Input, Connection_Types.F);
      G : String renames Image(Input, Connection_Types.G);
      H : String renames Image(Input, Connection_Types.H);
   begin
      return
	"        "&A&"   "&B			& New_Line &
	"       /|\ /|\"			& New_Line &
	"      / | X | \"			& New_Line &
	"     /  |/ \|  \"			& New_Line &
	"    "&C&" - "&D&" - "&E&" - "&F	& New_Line &
	"     \  |\ /|  /"			& New_Line &
	"      \ | X | /"			& New_Line &
	"       \|/ \|/"			& New_Line &
	"        "&G&"   "&H			& New_Line;
   end Image;

End Connection_Types;
