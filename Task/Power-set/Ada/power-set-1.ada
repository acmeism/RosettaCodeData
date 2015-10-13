package Power_Set is

   type Set is array  (Positive range <>) of Positive;
   Empty_Set: Set(1 .. 0);

   generic
      with procedure Visit(S: Set);
   procedure All_Subsets(S: Set); -- calles Visit once for each subset of S

end Power_Set;
