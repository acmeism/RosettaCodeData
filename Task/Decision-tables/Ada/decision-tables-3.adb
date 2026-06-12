with Generic_Decision_Table, Ada.Text_IO;

procedure Printer_Decision_Table is

   type Condition is (Does_Not_Print, Red_Light_Flashing, Unrecognised);
   type Action is (Power_Cable, Printer_Computer_Cable, Software_Installed,
                   New_Ink, Paper_Jam);

   function Question(Cond: Condition) return Boolean is
      use Ada.Text_IO;
      Ch: Character;
   begin
      case Cond is
         when Does_Not_Print =>
            Put("Printer does not print?");
         when Red_Light_Flashing =>
            Put("A red light is flashing?");
         when Unrecognised =>
            Put("Printer is unrecognised?");
      end case;
      Put_Line (" y/Y => 'yes', any other input: 'no'");
      Get(Ch);
      return (Ch='y') or (Ch='Y');
   end Question;

   procedure Answer(Act: Action) is
      use Ada.Text_IO;
   begin
      case Act is
         when Power_Cable =>
            Put_Line("Check the power cable!");
         when Printer_Computer_Cable =>
            Put_Line("Check the printer-computer cable!");
         when Software_Installed =>
            Put_Line("Ensure the printer software is installed!");
         when New_Ink =>
            Put_Line("Check/replace ink!");
         when Paper_Jam =>
            Put_Line("Check for paper jam!");
      end case;
   end Answer;

   procedure No_Answer is
   begin
      Ada.Text_IO.Put_Line("Sorry! I have no idea what to do now!");
   end No_Answer;

   package DT is new Generic_Decision_Table
     (Condition, Action, Question, Answer, No_Answer);

   R: DT.Rule_A := (((True,  False, True),  Power_Cable),
                    ((True,  True,  True),  Printer_Computer_Cable),
                    ((True,  False, True),  Printer_Computer_Cable),
                    ((True,  True,  True),  Software_Installed),
                    ((True,  False, True),  Software_Installed),
                    ((False, True,  True),  Software_Installed),
                    ((False, False, True),  Software_Installed),
                    ((True,  True,  True),  New_Ink),
                    ((True,  True,  False), New_Ink),
                    ((False, True,  True),  New_Ink),
                    ((False, True,  False), New_Ink),
                    ((True,  True,  False), Paper_Jam),
                    ((True,  False, False), Paper_Jam)
                   );

begin
   DT.React(R);
end Printer_Decision_Table;
