with Ada.Containers.Indefinite_Vectors;
private with Ada.Containers.Indefinite_Hashed_Maps;

generic
   type Source_Type (<>) is private;
   type Item_Type (<>) is private;
   with function Hash(Item: Item_Type) return Ada.Containers.Hash_Type is <>;
package Generic_Inverted_Index is

   type Storage_Type is tagged private;

   package Source_Vecs is new Ada.Containers.Indefinite_Vectors
     (Index_Type   => Positive,
      Element_Type => Source_Type);

   procedure Store(Storage: in out Storage_Type;
                   Source: Source_Type;
                   Item: Item_Type);
   -- stores Source in a table, indexed by Item
   -- if there is already an Item/Source entry, the Table isn_t changed

   function Find(Storage: Storage_Type; Item: Item_Type)
                return Source_Vecs.Vector;
   -- Generates a vector of all Sources for the given Item

   function "and"(Left, Right: Source_Vecs.Vector) return Source_Vecs.Vector;
   -- returns a vector of all sources, which are both in Left and in Right

   function "or"(Left, Right: Source_Vecs.Vector) return Source_Vecs.Vector;
   -- returns a vector of all sources, which are in Left, Right, or both

   function Empty(Vec: Source_Vecs.Vector) return Boolean;
   -- returns true if Vec is empty

   function First_Source(The_Sources: Source_Vecs.Vector) return Source_Type;
   -- returns the first enty in The_Sources; pre: The_Sourses is not empty

   procedure Delete_First_Source(The_Sources: in out Source_Vecs.Vector;
                                 Count: Ada.Containers.Count_Type := 1);
   -- Removes the first Count entries; pre: The_Sourses has that many entries

   type Process_Source is not null access procedure (Source: Source_Type);

   generic
      with procedure Do_Something(Source: Source_Type);
   procedure Iterate(The_Sources: Source_Vecs.Vector);
   -- calls Do_Something(Source) for all sources in The_Sources;

private

   function Same_Vector(U,V: Source_Vecs.Vector) return Boolean;

   package Maps is new Ada.Containers.Indefinite_Hashed_Maps
     -- for each item (=key) we store a vector with sources
     (Key_Type         => Item_Type,
      Element_Type     => Source_Vecs.Vector,
      Hash             => Hash,
      Equivalent_Keys  => "=",
      "="              => Same_Vector);

   type Storage_Type is new Maps.Map with null record;

end Generic_Inverted_Index;
