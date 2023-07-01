with Ada.Containers.Vectors; use Ada.Containers;

package Digraphs is

   type Node_Idx_With_Null is new Natural;
   subtype Node_Index is Node_Idx_With_Null range 1 .. Node_Idx_With_Null'Last;
   -- a Node_Index is a number from 1, 2, 3, ... and the representative of a node

   type Graph_Type is tagged private;

   -- make sure Node is in Graph (possibly without connections)
   procedure Add_Node
     (Graph: in out Graph_Type'Class; Node: Node_Index);

   -- insert an edge From->To into Graph; do nothing if already there
   procedure Add_Connection
     (Graph: in out Graph_Type'Class; From, To: Node_Index);

   -- get the largest Node_Index used in any Add_Node or Add_Connection op.
   -- iterate over all nodes of Graph: "for I in 1 .. Graph.Node_Count loop ..."
   function Node_Count(Graph: Graph_Type) return Node_Idx_With_Null;

   -- remove an edge From->To from Fraph; do nothing if not there
   -- Graph.Node_Count is not changed
   procedure Del_Connection
     (Graph: in out Graph_Type'Class; From, To: Node_Index);

   -- check if an edge From->to exists in Graph
   function Connected
     (Graph: Graph_Type; From, To: Node_Index) return Boolean;

   -- data structure to store a list of nodes
   package Node_Vec is new Vectors(Positive, Node_Index);

   -- get a list of all nodes From->Somewhere in Graph
   function All_Connections
     (Graph: Graph_Type; From: Node_Index) return Node_Vec.Vector;

   Graph_Is_Cyclic: exception;

   -- a depth-first search to find a topological sorting of the nodes
   -- raises Graph_Is_Cyclic if no topological sorting is possible
   function Top_Sort
     (Graph: Graph_Type) return Node_Vec.Vector;

private

   package Conn_Vec is new Vectors(Node_Index, Node_Vec.Vector, Node_Vec."=");

   type Graph_Type is new Conn_Vec.Vector with null record;

end Digraphs;
