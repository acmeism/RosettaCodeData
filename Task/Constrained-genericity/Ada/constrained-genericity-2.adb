type Banana is new Food with null record;
overriding procedure Eat (Object : in out Banana) is null;
package Banana_Box is new Food_Boxes (Banana);

type Tomato is new Food with null record;
overriding procedure Eat (Object : in out Tomato) is null;
package Tomato_Box is new Food_Boxes (Tomato);
-- We have declared Banana and Tomato as a Food.
