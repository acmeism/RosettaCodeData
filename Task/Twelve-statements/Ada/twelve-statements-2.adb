generic
   Number_Of_Statements: Positive;
package Logic is

   --types
   subtype Indices is Natural range 1 .. Number_Of_Statements;
   type Table is array(Indices range <>) of Boolean;
   type Predicate is access function(T: Table) return Boolean;
   type Statements is array(Indices) of Predicate;
   type Even_Odd is (Even, Odd);

   -- convenience functions
   function Sum(T: Table) return Natural;
   function Half(T: Table; Which: Even_Odd) return Table;

end Logic;
