package body Generic_Decision_Table is
   procedure React(Rules: Rule_A) is
      A: Answers;
      Some_Answer: Boolean := False;
   begin
      for C in A'Range loop
         A(C) := Ask_Question(C);
      end loop;
      for R in Rules'Range loop
         if A = Rules(R).If_Then then
            Give_Answer(Rules(R).Act);
            Some_Answer := True;
         end if;
      end loop;
      if not Some_Answer then
         No_Answer;
      end if;
   end React;

end Generic_Decision_Table;
