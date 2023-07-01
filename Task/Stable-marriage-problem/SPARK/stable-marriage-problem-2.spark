with Preferences;
--# inherit Preferences;
package Propose
is

   type Engagements is array (Preferences.Girl) of Preferences.Guy_X;

   procedure Engage (Pairs :    out Engagements);
   --# derives Pairs from ;

   procedure Check_Stable (Pairs      : in     Engagements;
                           OK         :    out Boolean;
                           Other_Girl :    out Preferences.Girl_X;
                           Other_Guy  :    out Preferences.Guy_X);
   --# derives OK,
   --#         Other_Girl,
   --#         Other_Guy from Pairs;

end Propose;
