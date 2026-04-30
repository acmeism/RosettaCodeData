with Ada.Containers.Indefinite_Vectors;

package Nutrition is
   type Food is interface;
   procedure Eat (Object : in out Food) is abstract;

end Nutrition;

with Ada.Containers;
with Nutrition;

generic
   type New_Food is new Nutrition.Food;
package Food_Boxes is

  package Food_Vectors is
      new Ada.Containers.Indefinite_Vectors
          (  Index_Type   => Positive,
             Element_Type => New_Food
          );

   subtype Food_Box is Food_Vectors.Vector;

end Food_Boxes;
