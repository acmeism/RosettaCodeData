#!/usr/bin/python3
import posix
import os
import sys

pid = posix.fork()
if pid != 0:
    print("Child process detached with pid %s" % pid)
    sys.exit(0)

old_stdin = sys.stdin
old_stdout = sys.stdout
old_stderr = sys.stderr

sys.stdin = open('/dev/null', 'rt')
sys.stdout = open('/tmp/dmn.log', 'wt')
sys.stderr = sys.stdout

old_stdin.close()
old_stdout.close()
old_stderr.close()

posix.setsid()

import time
t = time.time()
while time.time() < t + 10:
    print("timer running, %s seconds" % str(time.time() - t))
    time.sleep(1)
