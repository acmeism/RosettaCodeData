if empty then 2 else 3 end          # produces no value
if 1 then 2 else 3 end              # produces 2
if [false, false] then 2 else 3 end # produces 2
if (true, true) then 2 else 3 end   # produces a stream: 2, 2
