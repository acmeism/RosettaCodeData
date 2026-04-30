with Ada.Characters.Latin_1;
with Ada.Strings;
with Ada.Strings.Fixed;
with Ada.Text_IO;

procedure Long_Literal is
   --  & is the concatenation operator
   Elements : constant String :=
     "hydrogen helium lithium beryllium boron carbon nitrogen oxygen fluorine " &
     "neon sodium magnesium aluminum silicon phosphorous sulfur chlorine argon " &
     "potassium calcium scandium titanium vanadium chromium manganese iron " &
     "cobalt nickel copper zinc gallium germanium arsenic selenium bromine " &
     "krypton rubidium strontium yttrium zirconium niobium molybdenum " &
     "technetium ruthenium rhodium palladium silver cadmium indium tin " &
     "antimony tellurium iodine xenon cesium barium lanthanum cerium " &
     "praseodymium neodymium promethium samarium europium gadolinium terbium " &
     "dysprosium holmium erbium thulium ytterbium lutetium hafnium tantalum " &
     "tungsten rhenium osmium iridium platinum gold mercury thallium lead " &
     "bismuth polonium astatine radon francium radium actinium thorium " &
     "protactinium uranium neptunium plutonium americium curium berkelium " &
     "californium einsteinium fermium mendelevium nobelium lawrencium " &
     "rutherfordium dubnium seaborgium bohrium hassium meitnerium darmstadtium " &
     "roentgenium copernicium nihonium flerovium moscovium livermorium " &
     "tennessine oganesson";
   Revision : constant String := "2025-08-02";
   Count : constant Natural := Ada.Strings.Fixed.Count (Elements, " ") + 1;
   Last_Element : constant Natural :=
     Ada.Strings.Fixed.Index (Elements, " ", Ada.Strings.Backward) + 1;
begin
   Ada.Text_IO.Put_Line ("Last Revision Date: " & Revision);
   Ada.Text_IO.Put_Line ("Number of Elements: " & Count'Image);
   Ada.Text_IO.Put_Line
     ("Last Element: " & Elements (Last_Element .. Elements'Last));
end Long_Literal;
