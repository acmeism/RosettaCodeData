var arena = List.filled(5, 0)  // allocate memory for 5 integers
for (i in 0..4) arena[i] = i   // insert some integers
System.print(arena)            // print them
arena = null                   // make arena eligible for garbage collection
System.gc()                    // request immediate garbage collection
