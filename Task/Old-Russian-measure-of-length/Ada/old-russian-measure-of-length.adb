with Ada.Wide_Text_IO;          use Ada.Wide_Text_IO;
with Float_Measures;            use Float_Measures;
with Float_Measures_UTF8_Edit;  use Float_Measures_UTF8_Edit;
with Float_Measures_Irregular;  use Float_Measures_Irregular;
with Strings_Edit.Floats;       use Strings_Edit.Floats;
with Strings_Edit.UTF8.Handling;

procedure Old_Russian_Measure_of_Length is
   function "&" (Left : Wide_String; Right : String) return Wide_String is
   begin
      return Left & Strings_Edit.UTF8.Handling.To_Wide_String (Right);
   end "&";
   Аршин  : constant Measure := 0.7112 * m;
   Линия  : constant Measure := 0.00254 * m;
   Миля   : constant Measure := 7467.6 * m;
   Пядь   : constant Measure := 0.1778 * m;
   Сажень : constant Measure := 2.1336 * m;
   Точка  : constant Measure := 0.000254 * m;
   Вершок : constant Measure := 0.04445 * m;
   Верста : constant Measure := 1066.8 * m;
begin
   Put_Line ("Аршинов в метре     " & Image (Get_Value_As (m, Аршин)));
   Put_Line ("Сантиметроы в метре " & Image (Get_Value_As (m, 0.01 * m)));
   Put_Line ("Дюймов в метре      " & Image (Get_Value_As (m, inch)));
   Put_Line ("Футов в метре       " & Image (Get_Value_As (m, ft)));
   Put_Line ("Линий в метре       " & Image (Get_Value_As (m, Линия)));
   Put_Line ("Миль в метре        " & Image (Get_Value_As (m, Миля)));
   Put_Line ("Пядей в метре       " & Image (Get_Value_As (m, Пядь)));
   Put_Line ("Метров в метре      " & Image (Get_Value_As (m, m)));
   Put_Line ("Саженей в метре     " & Image (Get_Value_As (m, Сажень)));
   Put_Line ("Точек в метре       " & Image (Get_Value_As (m, Точка)));
   Put_Line ("Вершков в метре     " & Image (Get_Value_As (m, Вершок)));
   Put_Line ("Вёрст в метре       " & Image (Get_Value_As (m, Верста)));
   Put_Line ("Аршинн на пядь      " & Image (Аршин * Пядь));
   Put_Line ("Кубическая сажень   " & Image (Сажень ** 3));
end Old_Russian_Measure_of_Length;
