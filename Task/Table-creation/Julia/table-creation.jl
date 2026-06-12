using SQLite

conn = SQLite.DB() # in-memory
SQLite.execute!(conn, """
    create table stocks
    (date text, trans text, symbol text,
    qty real, price real)
    """)

# Insert a row of data
SQLite.execute!(conn, """
    insert into stocks
        values ('2006-01-05','BUY','RHAT',100,35.14)
    """)

for v in [["2006-03-28", "BUY",  "IBM",   1000, 45.00],
          ["2006-04-05", "BUY",  "MSOFT", 1000, 72.00],
          ["2006-04-06", "SELL", "IBM",   500,  53.00]]
    SQLite.query(conn, "insert into stocks values (?,?,?,?,?)", values = v)
end

df = SQLite.query(conn, "select * from stocks order by price")
println(df)
