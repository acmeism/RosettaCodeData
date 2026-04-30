-- FILE: events.ads --
with Ada.Numerics.Generic_Elementary_Functions;
with Cairo;
with GLib; use Glib;
with GTK.Drawing_Area; use GTK.Drawing_Area;
with GTK.Widget; use GTK.Widget;
with GLib.Object; use GLib.Object;

package Events is
   Drawing_Area : GTK_Drawing_Area;

   package GDouble_Elementary_Functions is new Ada.Numerics.Generic_Elementary_Functions (Float);
   use GDouble_Elementary_Functions;

   function Draw (Self : access GObject_Record'Class;
                  CC   : Cairo.Cairo_Context)
                  return Boolean;
end Events;
