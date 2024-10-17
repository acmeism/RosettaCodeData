Tbl = Table(16,2,16,3, 2,3)     # construct table
Tbl.CH[1,:] = string.(0:15,base=16) # Column headers
Tbl.RH[:,2] = string.(0:15,base=16) # Row headers
for i = 0:255                   # populate table, exclude special characters
  Tbl.T[i>>4+1,i&15+1,1:2]=["$i",i∈(0,7,8,9,10,13,27,155) ? "" : "$(Char(i))"]
end
prt(Tbl)                        # format and print table on console
