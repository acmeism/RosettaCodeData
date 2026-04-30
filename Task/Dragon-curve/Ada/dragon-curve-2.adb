-- FILE: dragon_curve.adb --
with Ada.Text_IO; use Ada.Text_IO;
with Events; use Events;
with GLib.Main; use GLib.Main;
with GTK;
with GTK.Drawing_Area; use GTK.Drawing_Area;
with GTK.Main;
with GTK.Window; use GTK.Window;

procedure Dragon_Curve is
   Window : GTK_Window;
begin
   GTK.Main.Init;
   GTK_New (Window);
   GTK_New (Drawing_Area);
   Window.Add (Drawing_Area);
   Drawing_Area.On_Draw (Events.Draw'Access, Drawing_Area);
   Show_All (Window);
   Resize (Window, 800, 800);
   GTK.Main.Main;
end Dragon_Curve;
