-- Instantiate the generic package Ada.Strings.Bounded.Generic_Bounded_Length with a maximum length of 80 characters
package Flexible_String is new Ada.Strings.Bounded.Generic_Bounded_Length(80);
use Flexible_String;

Src : Bounded_String := To_Bounded_String("Hello");
Dest : Bounded_String := Src;
