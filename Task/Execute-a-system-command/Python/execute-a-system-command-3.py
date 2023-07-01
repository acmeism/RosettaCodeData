from subprocess import PIPE, Popen, STDOUT
p = Popen('ls', stdout=PIPE, stderr=STDOUT)
print p.communicate()[0]
