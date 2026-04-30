package Multiplicative_Order is

   type Positive_Array is array (Positive range <>) of Positive;

   function Find_Order(Element, Modulus: Positive) return Positive;
   -- naive algorithm
   -- returns the smallest I such that (Element**I) mod Modulus = 1

   function Find_Order(Element: Positive;
                       Coprime_Factors: Positive_Array) return Positive;
   -- faster algorithm for the same task
   -- computes the order of all Coprime_Factors(I)
   -- and returns their least common multiple
   -- this gives the same result as Find_Order(Element, Modulus)
   -- with Modulus being the product of all the Coprime_Factors(I)
   --
   -- preconditions: (1) 1 = GCD(Coprime_Factors(I), Coprime_Factors(J))
   --                    for all pairs I, J with I /= J
   --                (2) 1 < Coprime_Factors(I)   for all I

end Multiplicative_Order;
