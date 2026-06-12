from __future__ import print_function
from time import sleep


last_idle = last_total = 0
while True:
    with open('/proc/stat') as f:
        fields = [float(column) for column in f.readline().strip().split()[1:]]
    idle, total = fields[3], sum(fields)
    idle_delta, total_delta = idle - last_idle, total - last_total
    last_idle, last_total = idle, total
    utilisation = 100.0 * (1.0 - idle_delta / total_delta)
    print('%5.1f%%' % utilisation, end='\r')
    sleep(5)
