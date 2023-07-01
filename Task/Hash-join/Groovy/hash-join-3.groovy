def s = [[age: 27, name: 'Jonah'],
         [age: 18, name: 'Alan'],
         [age: 28, name: 'Glory'],
         [age: 18, name: 'Popeye'],
         [age: 28, name: 'Alan']]

def r = [[name: 'Jonah', nemesis: 'Whales'],
         [name: 'Jonah', nemesis: 'Spiders'],
         [name: 'Alan', nemesis: 'Ghosts'],
         [name: 'Alan', nemesis: 'Zombies'],
         [name: 'Glory', nemesis: 'Buffy']]

hashJoin(s, "name", r, "name").sort {it.name}.each { println it }
