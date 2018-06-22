import subprocess
px = subprocess.Popen(['python', '-c', 'import calendar; calendar.prcal(1969)'],
                      stdout=subprocess.PIPE)
cal = px.communicate()[0]
print (cal.upper())
