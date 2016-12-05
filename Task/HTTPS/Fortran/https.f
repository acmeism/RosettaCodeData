program https_example
   implicit none
   character (len=:), allocatable :: code
   character (len=:), allocatable :: command
   logical:: waitForProcess

   ! execute Node.js code
   code = "var https = require('https'); &
   https.get('https://sourceforge.net/', function(res) {&
   console.log('statusCode: ', res.statusCode);&
   console.log('Is authorized:' + res.socket.authorized);&
   console.log(res.socket.getPeerCertificate());&
   res.on('data', function(d) {process.stdout.write(d);});});"

   command = 'node -e "' // code // '"'
   call execute_command_line (command, wait=waitForProcess)
end program https_example
