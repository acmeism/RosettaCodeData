Object Class new: Employee(name, id, salary, dep)

Employee method: initialize  := dep  := salary := id := name ;
Employee method: salary  @salary ;
Employee method: dep     @dep ;
Employee method: <<      "[" << @dep << "," << @name << "," << @salary << "]" << ;

: topRank(n)
| employees |
   ListBuffer new ->employees

   Employee new("Tyler Bennett",   "E10297", 32000, "D101") employees add
   Employee new("John Rappl",      "E21437", 47000, "D050") employees add
   Employee new("George Woltman",  "E00127", 53500, "D101") employees add
   Employee new("Adam Smith",      "E63535", 18000, "D202") employees add
   Employee new("Claire Buckman",  "E39876", 27800, "D202") employees add
   Employee new("David McClellan", "E04242", 41500, "D101") employees add
   Employee new("Rich Holcomb",    "E01234", 49500, "D202") employees add
   Employee new("Nathan Adams",    "E41298", 21900, "D050") employees add
   Employee new("Richard Potter",  "E43128", 15900, "D101") employees add
   Employee new("David Motsinger", "E27002", 19250, "D202") employees add
   Employee new("Tim Sampair",     "E03033", 27000, "D101") employees add
   Employee new("Kim Arlich",      "E10001", 57000, "D190") employees add
   Employee new("Timothy Grove",   "E16398", 29900, "D190") employees add

   #dep employees sortBy groupWith( #dep )
   map(#[ sortBy(#[ salary neg ]) left(n) ]) apply(#println) ;
