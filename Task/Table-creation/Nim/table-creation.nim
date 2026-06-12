import db_sqlite

let dbc = open(":memory:", "", "", "")
dbc.exec(sql"create table stocks(date text, trans text, symbol text, qty real, price real)")

# Insert a row of data.
dbc.exec(sql"insert into stocks values ('2006-01-05', 'BUY', 'RHAT', 100, 35.14)")

for v in [("2006-03-28", "BUY",  "IBM",   1000, 45.00),
          ("2006-04-05", "BUY",  "MSOFT", 1000, 72.00),
          ("2006-04-06", "SELL", "IBM",   500,  53.00)]:
  dbc.exec(sql"insert into stocks values (?, ?, ?, ?, ?)", v[0], v[1], v[2], v[3], v[4])

# Data retrieval.
for row in dbc.fastRows(sql"select * from stocks order by price"):
  echo row
