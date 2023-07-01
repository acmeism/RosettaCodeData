(prinl "       Binary     Gray  Decoded")
(for I (range 0 31)
   (let G (grayEncode I)
      (tab (4 9 9 9) I (bin I) G (grayDecode G)) ) )
