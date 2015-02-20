# Solve Zebra Puzzle.
#
#  Nigel_Galloway
#  August 31st., 2014.
CONTENT = { :House       => nil,
            :Nationality => [:English, :Swedish, :Danish, :Norwegian, :German],
            :Colour      => [:Red, :Green, :White, :Blue, :Yellow],
            :Pet         => [:Dog, :Birds, :Cats, :Horse, :Zebra],
            :Drink       => [:Tea, :Coffee, :Milk, :Beer, :Water],
            :Smoke       => [:PallMall, :Dunhill, :BlueMaster, :Prince, :Blend] }

def adjacent? (n,i,g,e)
  (0..3).any?{|x| (n[x]==i and g[x+1]==e) or (n[x+1]==i and g[x]==e)}
end

def leftof? (n,i,g,e)
  (0..3).any?{|x| n[x]==i and g[x+1]==e}
end

def coincident? (n,i,g,e)
  n.each_index.any?{|x| n[x]==i and g[x]==e}
end

def solve
  CONTENT[:Nationality].permutation{|nation|
    next if nation.first != :Norwegian                              # 10
    CONTENT[:Colour].permutation{|colour|
      next unless leftof?(colour,:Green,colour,:White)              # 5
      next unless coincident?(nation,:English,colour,:Red)          # 2
      next unless adjacent?(nation,:Norwegian,colour,:Blue)         # 15
      CONTENT[:Pet].permutation{|pet|
        next unless coincident?(nation,:Swedish,pet,:Dog)           # 3
        CONTENT[:Drink].permutation{|drink|
          next if drink[2] != :Milk                                 # 9
          next unless coincident?(nation,:Danish,drink,:Tea)        # 4
          next unless coincident?(colour,:Green,drink,:Coffee)      # 6
          CONTENT[:Smoke].permutation{|smoke|
            next unless coincident?(smoke,:PallMall,pet,:Birds)     # 7
            next unless coincident?(smoke,:Dunhill,colour,:Yellow)  # 8
            next unless coincident?(smoke,:BlueMaster,drink,:Beer)  # 13
            next unless coincident?(smoke,:Prince,nation,:German)   # 14
            next unless adjacent?(smoke,:Blend,pet,:Cats)           # 11
            next unless adjacent?(smoke,:Blend,drink,:Water)        # 16
            next unless adjacent?(smoke,:Dunhill,pet,:Horse)        # 12
            return [nation,colour,pet,drink,smoke]
  } } } } }
end
res = solve
width = CONTENT.map{|x| x.flatten.map{|y|y.to_s.size}.max}
fmt = width.map{|w| "%-#{w}s"}.join(" ")
puts "The Zebra is owned by the man who is #{res[0][res[2].find_index(:Zebra)]}",""
puts fmt % CONTENT.keys, fmt % width.map{|w| "-"*w}
res.transpose.each.with_index(1){|x,n| puts fmt % [n,*x]}
