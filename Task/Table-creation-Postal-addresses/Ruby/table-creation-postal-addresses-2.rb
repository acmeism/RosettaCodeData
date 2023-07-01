db.transaction do
  id = (db[:next] += 1)
  db[id] = Address.new(id,
                       "1600 Pennsylvania Avenue NW",
                       "Washington", "DC", 20500)
  db[:ids].add id
end
