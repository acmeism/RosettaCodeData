with Ada.Containers.Indefinite_Ordered_Sets;
with Ada.Containers.Ordered_Sets;
package Partitions is
   -- Argument type for Create_Partitions: Array of Numbers
   type Arguments is array (Positive range <>) of Natural;
   package Number_Sets is new Ada.Containers.Ordered_Sets
     (Natural);
   type Partition is array (Positive range <>) of Number_Sets.Set;
   function "<" (Left, Right : Partition) return Boolean;
   package Partition_Sets is new Ada.Containers.Indefinite_Ordered_Sets
     (Partition);
   function Create_Partitions (Args : Arguments) return Partition_Sets.Set;
end Partitions;
