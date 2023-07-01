% create an empty dict call 'point'
D1 = point{},

% add a value	
D2 = D1.put(x, 20).put(y, 30).put(z, 20),

% update a value
D3 = D2.put([x=25]),

% remove a value
del_dict(z, D3, _, D4),

% access a value randomly
format('x = ~w, y = ~w~n', [D4.x, D4.y]).
