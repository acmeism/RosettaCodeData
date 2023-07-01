import subprocess
# if the exit code was non-zero these commands raise a CalledProcessError
exit_code = subprocess.check_call(['ls', '-l'])   # Python 2.5+
assert exit_code == 0
output    = subprocess.check_output(['ls', '-l']) # Python 2.7+
