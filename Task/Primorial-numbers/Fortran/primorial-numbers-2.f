      INTEGER*4 D              !A 32-bit product.
      INTEGER*2 II(2),C,R      !Some 16-bit variables.
      EQUIVALENCE (D,II)       !Align.
      EQUIVALENCE (II(1),C),(II(2),R) !Carry in the high order half of D, Result in the low.
