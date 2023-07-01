import os
exit_code = os.system('ls')       # Just execute the command, return a success/fail code
output    = os.popen('ls').read() # If you want to get the output data. Deprecated.
