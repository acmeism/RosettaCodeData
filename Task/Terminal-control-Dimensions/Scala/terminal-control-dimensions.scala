  /*
     First execute the terminal command: 'export COLUMNS LINES'
     before running this program for it to work (returned 'null' sizes otherwise).
 */

    val (lines, columns)  = (System.getenv("LINES"), System.getenv("COLUMNS"))
    println(s"Lines   = $lines, Columns = $columns")
