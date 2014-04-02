with Glib;                use Glib;
with Cairo;               use Cairo;
with Cairo.Png;           use Cairo.Png;
with Cairo.Pattern;       use Cairo.Pattern;
with Cairo.Image_Surface; use Cairo.Image_Surface;
with Ada.Numerics;

procedure Sphere is
   subtype Dub is Glib.Gdouble;

   Surface    : Cairo_Surface;
   Cr         : Cairo_Context;
   Pat        : Cairo_Pattern;
   Status_Out : Cairo_Status;
   M_Pi       : constant Dub := Dub (Ada.Numerics.Pi);

begin
   Surface := Create (Cairo_Format_ARGB32, 512, 512);
   Cr      := Create (Surface);
   Pat     :=
      Cairo.Pattern.Create_Radial (230.4, 204.8, 51.1, 204.8, 204.8, 256.0);
   Cairo.Pattern.Add_Color_Stop_Rgba (Pat, 0.0, 1.0, 1.0, 1.0, 1.0);
   Cairo.Pattern.Add_Color_Stop_Rgba (Pat, 1.0, 0.0, 0.0, 0.0, 1.0);
   Cairo.Set_Source (Cr, Pat);
   Cairo.Arc (Cr, 256.0, 256.0, 153.6, 0.0, 2.0 * M_Pi);
   Cairo.Fill (Cr);
   Cairo.Pattern.Destroy (Pat);
   Status_Out := Write_To_Png (Surface, "SphereAda.png");
   pragma Assert (Status_Out = Cairo_Status_Success);
end Sphere;
