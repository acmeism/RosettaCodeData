ar = ["5**3**2", "(5**3)**2", "5**(3**2)", "[5,3,2].inject(:**)"]
ar.each{|exp| puts "#{exp}:\t#{eval exp}"}
