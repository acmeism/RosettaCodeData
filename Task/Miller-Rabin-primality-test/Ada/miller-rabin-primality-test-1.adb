generic
   type Number is range <>;
package Miller_Rabin is

   type Result_Type is (Composite, Probably_Prime);

   function Is_Prime (N : Number; K : Positive := 10) return Result_Type;

end Miller_Rabin;
