>>> import sqlite3
>>> conn = sqlite3.connect(':memory:')
>>> c = conn.cursor()
>>> c.execute('''create table stocks
(date text, trans text, symbol text,
 qty real, price real)''')
<sqlite3.Cursor object at 0x013263B0>
>>> # Insert a row of data
c.execute("""insert into stocks
          values ('2006-01-05','BUY','RHAT',100,35.14)""")

<sqlite3.Cursor object at 0x013263B0>
>>> for t in [('2006-03-28', 'BUY', 'IBM', 1000, 45.00),
          ('2006-04-05', 'BUY', 'MSOFT', 1000, 72.00),
          ('2006-04-06', 'SELL', 'IBM', 500, 53.00),
         ]:
	c.execute('insert into stocks values (?,?,?,?,?)', t)

	
<sqlite3.Cursor object at 0x013263B0>
<sqlite3.Cursor object at 0x013263B0>
<sqlite3.Cursor object at 0x013263B0>
>>> # Data retrieval
>>> c = conn.cursor()
>>> c.execute('select * from stocks order by price')
<sqlite3.Cursor object at 0x01326530>
>>> for row in c:
	print row

	
(u'2006-01-05', u'BUY', u'RHAT', 100.0, 35.140000000000001)
(u'2006-03-28', u'BUY', u'IBM', 1000.0, 45.0)
(u'2006-04-06', u'SELL', u'IBM', 500.0, 53.0)
(u'2006-04-05', u'BUY', u'MSOFT', 1000.0, 72.0)
>>>
