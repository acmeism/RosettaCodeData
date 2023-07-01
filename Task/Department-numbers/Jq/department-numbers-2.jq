{fire: range(1;8), police: range(1;8), sanitation: range(1;8)}
| select( .fire != .police and .fire != .sanitation and .police != .sanitation
      and .fire + .police + .sanitation == 12
      and .police % 2 == 0 )
