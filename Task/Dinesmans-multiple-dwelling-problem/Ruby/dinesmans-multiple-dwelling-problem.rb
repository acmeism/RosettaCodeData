def dinesman(floors, names, criteria)
  # the "bindVars" method returns a context where the "name" variables are bound to values
  eval "
    def bindVars(#{names.map {|n| n.downcase}.join ','})
      return binding
    end
  "
  expression = criteria.map {|c| "(#{c.downcase})"}.join " and "

  floors.permutation.each do |perm|
    b = bindVars *perm
    return b if b.eval(expression)
  end
  nil
end

floors = (1..5).to_a
names = %w(Baker Cooper Fletcher Miller Smith)
criteria = [
  "Baker != 5",
  "Cooper != 1",
  "Fletcher != 1",
  "Fletcher != 5",
  "Miller > Cooper",
  "(Smith - Fletcher).abs != 1",
  "(Fletcher - Cooper).abs != 1",
]

b = dinesman(floors, names, criteria)

if b.nil?
  puts "no solution"
else
  puts "Found a solution:"
  len = names.map {|n| n.length}.max
  residents = names.inject({}) {|r, n| r[b.eval(n.downcase)] = n; r}
  floors.each {|f| puts "  Floor #{f}: #{residents[f]}"}
end
