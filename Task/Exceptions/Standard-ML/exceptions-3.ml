val x = f() handle MyException => 22;
val y = f() handle MyDataException x => x;
