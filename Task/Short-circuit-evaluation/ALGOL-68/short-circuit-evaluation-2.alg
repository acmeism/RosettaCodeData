test:(

  PROC a = (BOOL a)BOOL: ( print(("a=",a,", ")); a),
       b = (BOOL b)BOOL: ( print(("b=",b,", ")); b);

# Valid for Algol 68G and 68RS using non standard operators #
  print(("T OREL F = ",  a(TRUE) OREL  b(FALSE), new line));
  print(("T OREL T = ",  a(TRUE) OREL  b(TRUE), new line));

  print(("F ANDTH F = ", a(FALSE) ANDTH b(FALSE), new line));
  print(("F ANDTH T = ", a(FALSE) ANDTH b(TRUE), new line));

  print(("F OREL F = ",  a(FALSE) OREL  b(FALSE), new line));
  print(("F OREL T = ",  a(FALSE) OREL  b(TRUE), new line));

  print(("T ANDTH F = ", a(TRUE) ANDTH b(FALSE), new line));
  print(("T ANDTH T = ", a(TRUE) ANDTH b(TRUE), new line))

CO;
# Valid for Algol 68G and 68C using non standard operators #
  print(("T ORF F = ", a(TRUE) ORF b(FALSE), new line));
  print(("F ANDF T = ", a(FALSE) ANDF b(TRUE), new line))
END CO

)
