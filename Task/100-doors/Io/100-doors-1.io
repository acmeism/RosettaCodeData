doors := List clone
100 repeat(doors append(false))
for(i,1,100,
    for(x,i,100, i, doors atPut(x - 1, doors at(x - 1) not))
)
doors foreach(i, x, if(x, "Door #{i + 1} is open" interpolate println))
