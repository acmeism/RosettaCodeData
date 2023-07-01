base = {"name":"Rocket Skates", "price":12.75, "color":"yellow"}
update = {"price":15.25, "color":"red", "year":1974}

result = base.copy()
result.update(update)

print(result)
