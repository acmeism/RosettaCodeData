import "random" for Random

var montyHall = Fn.new { |games|
    var rand = Random.new()
    var switchWins = 0
    var stayWins = 0
    for (i in 1..games) {
        var doors = [0] * 3       // all zero (goats) by default
        doors[rand.int(3)] = 1    // put car in a random door
        var choice = rand.int(3)  // choose a door at random
        var shown = 0
        while (true) {
            shown = rand.int(3)   // the shown door
            if (doors[shown] != 1 && shown != choice) break
        }
        stayWins = stayWins + doors[choice]
        switchWins = switchWins + doors[3-choice-shown]
    }
    System.print("Simulating %(games) games:")
    System.print("Staying   wins %(stayWins) times")
    System.print("Switching wins %(switchWins) times")
}

montyHall.call(1e6)
