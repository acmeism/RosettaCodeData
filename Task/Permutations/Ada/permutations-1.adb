generic
   N: positive;
package Generic_Perm is
   subtype Element is Positive range 1 .. N;
   type Permutation is array(Element) of Element;

   procedure Set_To_First(P: out Permutation; Is_Last: out Boolean);
   procedure Go_To_Next(P: in out Permutation; Is_Last: out Boolean);
end Generic_Perm;
