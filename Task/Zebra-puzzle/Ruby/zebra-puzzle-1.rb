CONTENT = { House:       '',
            Nationality: %i[English Swedish Danish Norwegian German],
            Colour:      %i[Red Green White Blue Yellow],
            Pet:         %i[Dog Birds Cats Horse Zebra],
            Drink:       %i[Tea Coffee Milk Beer Water],
            Smoke:       %i[PallMall Dunhill BlueMaster Prince Blend] }

def adjacent? (n,i,g,e)
  (0..3).any?{|x| (n[x]==i and g[x+1]==e) or (n[x+1]==i and g[x]==e)}
end

def leftof? (n,i,g,e)
  (0..3).any?{|x| n[x]==i and g[x+1]==e}
end

def coincident? (n,i,g,e)
  n.each_index.any?{|x| n[x]==i and g[x]==e}
end

def solve_zebra_puzzle
  CONTENT[:Nationality].permutation{|nation|
    next unless nation.first == :Norwegian                              # 10
    CONTENT[:Colour].permutation{|colour|
      next unless leftof?(colour, :Green, colour, :White)               # 5
      next unless coincident?(nation, :English, colour, :Red)           # 2
      next unless adjacent?(nation, :Norwegian, colour, :Blue)          # 15
      CONTENT[:Pet].permutation{|pet|
        next unless coincident?(nation, :Swedish, pet, :Dog)            # 3
        CONTENT[:Drink].permutation{|drink|
          next unless drink[2] == :Milk                                 # 9
          next unless coincident?(nation, :Danish, drink, :Tea)         # 4
          next unless coincident?(colour, :Green, drink, :Coffee)       # 6
          CONTENT[:Smoke].permutation{|smoke|
            next unless coincident?(smoke, :PallMall, pet, :Birds)      # 7
            next unless coincident?(smoke, :Dunhill, colour, :Yellow)   # 8
            next unless coincident?(smoke, :BlueMaster, drink, :Beer)   # 13
            next unless coincident?(smoke, :Prince, nation, :German)    # 14
            next unless adjacent?(smoke, :Blend, pet, :Cats)            # 11
            next unless adjacent?(smoke, :Blend, drink, :Water)         # 16
            next unless adjacent?(smoke, :Dunhill,pet, :Horse)          # 12
            print_out(nation, colour, pet, drink, smoke)
  } } } } }
end

def print_out (nation, colour, pet, drink, smoke)
  width = CONTENT.map{|x| x.flatten.map{|y|y.size}.max}
  fmt = width.map{|w| "%-#{w}s"}.join(" ")
  national = nation[ pet.find_index(:Zebra) ]
  puts "The Zebra is owned by the man who is #{national}",""
  puts fmt % CONTENT.keys, fmt % width.map{|w| "-"*w}
  [nation,colour,pet,drink,smoke].transpose.each.with_index(1){|x,n| puts fmt % [n,*x]}
end

solve_zebra_puzzle
