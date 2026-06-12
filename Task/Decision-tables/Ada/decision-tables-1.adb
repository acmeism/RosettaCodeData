generic
   type Condition is (<>);
   type Action is (<>);
   with function Ask_Question (Cond: Condition) return Boolean;
   with procedure Give_Answer (Act:  Action);
   with procedure No_Answer;

package Generic_Decision_Table is

   type Answers is array(Condition) of Boolean;
   type Rule_R is record
      If_Then: Answers;
      Act:     Action;
   end record;
   type Rule_A is array(Positive range <>) of Rule_R;

   procedure React(Rules: Rule_A);

end Generic_Decision_Table;
