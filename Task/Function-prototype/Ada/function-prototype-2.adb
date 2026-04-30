type Box; --  tell Ada a box exists (undefined yet)
type accBox is access Box; --  define a pointer to a box
type Box is record --  later define what a box is
   next : accBox; --  including that a box holds access to other boxes
end record;
