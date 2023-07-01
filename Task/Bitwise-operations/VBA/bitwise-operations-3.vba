Debug.Print Hex(MaskL(8))               'FF000000
Debug.Print Hex(MaskR(8))               'FF
Debug.Print Hex(Bit(7))                 '80
Debug.Print Hex(ShiftL(-1, 8))          'FFFFFF00
Debug.Print Hex(ShiftL(-1, -8))         'FFFFFF
Debug.Print Hex(ShiftR(-1, 8))          'FFFFFF
Debug.Print Hex(ShiftR(-1, -8))         'FFFFFF00
Debug.Print Hex(RotateL(65535, 8))      'FFFF00
Debug.Print Hex(RotateL(65535, -8))     'FF0000FF
Debug.Print Hex(RotateR(65535, 8))      'FF0000FF
Debug.Print Hex(RotateR(65535, -8))     'FFFF00
