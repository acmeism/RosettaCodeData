class Josephus {

    class func lineUp(#numberOfPeople:Int) -> [Int] {
        var people = [Int]()
        for (var i = 0; i < numberOfPeople; i++) {
            people.append(i)
        }
        return people
    }

    class func execute(#numberOfPeople:Int, spacing:Int) -> Int {
        var killIndex = 0
        var people = self.lineUp(numberOfPeople: numberOfPeople)

        println("Prisoners executed in order:")
        while (people.count > 1) {
            killIndex = (killIndex + spacing - 1) % people.count
            executeAndRemove(&people, killIndex: killIndex)
        }
        println()
        return people[0]
    }

    class func executeAndRemove(inout people:[Int], killIndex:Int) {
        print("\(people[killIndex]) ")
        people.removeAtIndex(killIndex)
    }

    class func execucteAllButM(#numberOfPeople:Int, spacing:Int, save:Int) -> [Int] {
        var killIndex = 0
        var people = self.lineUp(numberOfPeople: numberOfPeople)

        println("Prisoners executed in order:")
        while (people.count > save) {
            killIndex = (killIndex + spacing - 1) % people.count
            executeAndRemove(&people, killIndex: killIndex)
        }
        println()
        return people
    }
}

println("Josephus is number: \(Josephus.execute(numberOfPeople: 41, spacing: 3))")
println()
println("Survivors: \(Josephus.execucteAllButM(numberOfPeople: 41, spacing: 3, save: 3))")
