BEGIN {

         # For Windows
         out = system2var("dir")
         print out

         # Non-Windows
         out = getline2var("ls -l")
         print out
}

# For a Windows environment using system() method
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

# If command returns an ERRNO function returns null string
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
