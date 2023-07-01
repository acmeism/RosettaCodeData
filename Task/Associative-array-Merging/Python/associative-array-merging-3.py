Python 3.9.0 (tags/v3.9.0:9cf6752, Oct  5 2020, 15:34:40) [MSC v.1927 64 bit (AMD64)] on win32
Type "help", "copyright", "credits" or "license()" for more information.
>>> base = {"name":"Rocket Skates", "price":12.75, "color":"yellow"}
>>> update = {"price":15.25, "color":"red", "year":1974}
>>> result = base | update
>>> result
{'name': 'Rocket Skates', 'price': 15.25, 'color': 'red', 'year': 1974}
>>>
