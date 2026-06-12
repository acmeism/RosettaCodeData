declare
  [Sqlite] = {Module.link ['x-ozlib:/sqlite/Sqlite.ozf']}

  DB = {Sqlite.open 'test.db'}
in
  try
     %% show strings as text, not as number lists
     {Inspector.configure widgetShowStrings true}

     %% create table
     {Sqlite.exec DB
      "create table stocks(date text, trans text, symbol test,"
      #"qty real, price real)" _}

     %% insert using a SQL string
     {Sqlite.exec DB "insert into stocks values "
      #"('2006-01-05','BUY','RHAT',100,35.14)" _}

     %% insert with insert procedure
     for T in
	[r(date:"2006-03-28" trans:"BUY" symbol:"IBM" qty:1000 price:45.00)
	 r(date:"2006-04-05" trans:"BUY" symbol:"MSOFT" qty:1000 price:72.00)
	 r(date:"2006-04-06" trans:"SELL" symbol:"IBM" qty:500 price:53.00)]
     do
	{Sqlite.insert DB stocks T}
     end

     %% read table and show rows in Inspector
     for R in {Sqlite.exec DB "select * from stocks order by price"} do
	{Inspect R}
     end

  catch E then
     {Inspect E}
  finally
     {Sqlite.close DB}
  end
