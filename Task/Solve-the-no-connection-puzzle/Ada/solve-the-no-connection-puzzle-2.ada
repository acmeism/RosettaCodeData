Pragma Ada_2012;

Package Connection_Types with Pure is

   -- Name of the nodes.
   Type Node is (A, B, C, D, E, F, G, H);

   -- Type for indicating if a node is connected.
   Type Connection_List is array(Node) of Boolean
     with Size => 8, Object_Size => 8, Pack;

   Function "&"( Left : Connection_List; Right : Node ) return Connection_List;

   -- The actual map of the network connections.
   Network : Constant Array (Node) of Connection_List:=
     (
      A => (C|D|E	=> True, others => False),
      B => (D|E|F	=> True, others => False),
      C => (A|D|G	=> True, others => False),
      D => (C|A|B|E|H|G	=> True, others => False),
      E => (D|A|B|F|H|G => True, others => False),
      F => (B|E|H	=> True, others => False),
      G => (C|D|E	=> True, others => False),
      H => (D|E|F	=> True, others => False)
     );

   -- Values of the nodes.
   Type Peg is range 1..8;

   -- Indicator for which values have been assigned.
   Type Used_Peg is array(Peg) of Boolean
     with Size => 8, Object_Size => 8, Pack;

   Function "&"( Left : Used_Peg; Right : Peg ) return Used_Peg;


   -- Type describing the layout of the network.
   Type Partial_Board is array(Node range <>) of Peg;
   Subtype Board is Partial_Board(Node);

   -- Determines if the given board is a solution or partial-solution.
   Function Is_Solution	( Input : Partial_Board ) return Boolean;

   -- Displays the board as text.
   Function Image	( Input : Partial_Board ) Return String;

End Connection_Types;
