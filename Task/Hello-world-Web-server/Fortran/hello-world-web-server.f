program http_example
   implicit none
   character (len=:), allocatable :: code
   character (len=:), allocatable :: command
   logical :: waitForProcess

   ! Execute a Node.js code
   code = "const http = require('http'); http.createServer((req, res) => &
   {res.end('Hello World from a Node.js server started from Fortran!')}).listen(8080);"

   command = 'node -e "' // code // '"'
   call execute_command_line (command, wait=waitForProcess)

end program http_example
