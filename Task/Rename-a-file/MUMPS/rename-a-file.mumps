 ;Local
 S X=$ZF(-1,"rename input.txt output.txt")
 S X=$ZF(-1,"rename docs.dir mydocs.dir")
  ;Root of current device
 S X=$ZF(-1,"rename [000000]input.txt [000000]output.txt")
 S X=$ZF(-1,"rename [000000]docs.dir [000000]mydocs.dir")
