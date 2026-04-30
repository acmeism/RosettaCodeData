with Ada.Text_IO;  use Ada.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Numerics.Discrete_Random;


procedure Main is


   --Creation of type with all the possible answers
   --
   type Possible_Answers_Type is (It_Is_Certain, It_Is_Decidedly_So, Without_A_Doubt,
				  Yes_Definitely, You_May_Rely_On_It, As_I_See_It, Yes_Most_Likely,
				  Outlook_Good, Signs_Point_To_Yes, Yes_Reply_Hazy,
				  Try_Again, Ask_Again_Later, Better_Not_Tell_You_Now,
				  Cannot_Predict_Now, Concentrate_And_Ask_Again,
				  Dont_Bet_On_It, My_Reply_Is_No, My_Sources_Say_No,
				  Outlook_Not_So_Good, Very_Doubtful);
   ---------------------------------------------------------------------


   -- Variable declaration
   Answer           : Possible_Answers_Type := Possible_Answers_Type'First;
   User_Question : String := " ";

   -----------------------------------------------------------------------------


   --Randomizer
   --
   package Random_Answer is new Ada.Numerics.Discrete_Random (Possible_Answers_Type);
   use Random_Answer;
   G : Generator;

begin

   Reset (G); -- Starts the generator in a unique state in each run

   --User get provides question
   Put_Line ("Welcome."); New_Line;

   Put_Line ("WARNING!!!  Please remember that there's no need to shake your device for this program to work, and shaking your device could damage it");
   New_Line;

   Put_Line ("What's your question? ");
   Get (Item => User_Question); New_Line;


   --Output Answer
   Answer := (Random (G)); --Assigns random answer to variable Answer

   Put (Answer'Image); --Prints Answer

end Main;
