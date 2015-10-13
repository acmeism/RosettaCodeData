BEGIN {

         # Windows
          out = system2var("for %I in (input.txt) do @echo %~zI")
          printf("input.txt\t%s\n", out)
          out = system2var("for %I in (\input.txt) do @echo %~zI")
          printf("\input.txt\t%s\n", out)

         # Non-Windows
          out = getline2var("ls -l input.txt")
          split(out, size, " ")
          printf("input.txt\t%s\n", size[5])
          out = getline2var("ls -l /input.txt")
          split(out, size, " ")
          printf("/input.txt\t%s\n", size[5])
}

# Windows system() method
function system2var(command    ,tempfile, cmd, out, rec, data, i) {
         tempfile = "C:\\TEMP\\TMP.TMP"
         cmd = command " > " tempfile
         system(cmd)
         close(cmd)
         while (getline rec < tempfile > 0) {
             if ( ++i == 1 )
                 data = rec
             else
                 data = data "\n" rec
         }
         return(data)
}

# Non-windows getline method
function getline2var(command        ,fish, scale, ship) {
         command = command " 2>/dev/null"
         while ( (command | getline fish) > 0 ) {
             if ( ++scale == 1 )
                 ship = fish
             else
                 ship = ship "\n" fish
         }
         close(command)
         return ship
}
