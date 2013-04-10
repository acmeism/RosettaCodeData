main:(
  PROC echo = (STRING string)VOID:
      printf(($gl$,string));
  PAR(
    echo("Enjoy"),
    echo("Rosetta"),
    echo("Code")
  )
)
