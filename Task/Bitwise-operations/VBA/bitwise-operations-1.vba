Debug.Print Hex(&HF0F0 And &HFF00)  'F000
Debug.Print Hex(&HF0F0 Or &HFF00)   'FFF0
Debug.Print Hex(&HF0F0 Xor &HFF00)  'FF0
Debug.Print Hex(Not &HF0F0)         'F0F
Debug.Print Hex(&HF0F0 Eqv &HFF00)  'F00F
Debug.Print Hex(&HF0F0 Imp &HFF00)  'FF0F
