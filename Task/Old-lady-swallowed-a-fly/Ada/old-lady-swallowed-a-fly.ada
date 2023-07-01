with Ada.Text_IO, Ada.Containers.Indefinite_Doubly_Linked_Lists; use Ada.Text_IO;

procedure Swallow_Fly is

   package Strings is new Ada.Containers.Indefinite_Doubly_Linked_Lists(String);

   Lines, Animals: Strings.List;

   procedure Swallow(Animal: String;
                     Second_Line: String;
                     Permanent_Second_Line: Boolean := True) is

      procedure Print(C: Strings.Cursor) is
      begin
         Put_Line(Strings.Element(C));
      end Print;

   begin
      Put_Line("There was an old lady who swallowed a " & Animal & ",");
      Put_Line(Second_Line);
      if not Animals.Is_Empty then
         Lines.Prepend("She swallowed the " & Animal & " to catch the " &
			 Animals.Last_Element & ",");
      end if;
      Lines.Iterate(Print'Access);
      New_Line;
      if Permanent_Second_Line then
         Lines.Prepend(Second_Line);
      end if;
      Animals.Append(Animal); -- you need "to catch the " most recent animal
   end Swallow;

   procedure Swallow_TSA(Animal: String; Part_Of_Line_2: String) is
   begin
      Swallow(Animal, Part_Of_Line_2 &", to swallow a " & Animal & ";", False);
   end Swallow_TSA;

   procedure Swallow_SSA(Animal: String; Part_Of_Line_2: String) is
   begin
      Swallow(Animal, Part_Of_Line_2 &" she swallowed a " & Animal & ";", False);
   end Swallow_SSA;

begin
   Lines.Append("Perhaps she'll die!");

   Swallow("fly", "But I don't know why she swallowed the fly,");
   Swallow("spider",  "That wriggled and jiggled and tickled inside her;");
   Swallow_TSA("bird", "Quite absurd");
   Swallow_TSA("cat", "Fancy that");
   Swallow_TSA("dog", "What a hog");
   Swallow_TSA("pig", "Her mouth was so big");
   Swallow_TSA("goat","She just opened her throat");
   Swallow_SSA("cow", "I don't know how");
   Swallow_TSA("donkey", "It was rather wonky");

   Put_Line("There was an old lady who swallowed a horse ...");
   Put_Line("She's dead, of course!");
end Swallow_Fly;
