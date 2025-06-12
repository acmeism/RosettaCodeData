--  cistercian-ascii_requirements.ads
--
--  have to separate this because gnat requires only one compilation unit
--  per file

package Cistercian.Ascii_Requirements is
   subtype Valid_Dimension is Positive
   with Static_Predicate => Valid_Dimension > 5;
end Cistercian.Ascii_Requirements;
