s = '123'
try:
    i = float(s)
except (ValueError, TypeError):
    print 'not numeric'
