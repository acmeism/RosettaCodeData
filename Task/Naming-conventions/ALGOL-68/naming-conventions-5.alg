.PR POINT .PR
.MODE .XINT = .INT;
.XINT SUM SQ:=0;
.FOR I .WHILE
  SUM SQ .NE 70*70
.DO
  SUM SQ .PLUSAB I .UP 2
.OD
