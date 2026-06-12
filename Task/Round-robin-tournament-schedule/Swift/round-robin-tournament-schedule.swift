import Foundation

func roundRobin(teamCount: Int) {
    if teamCount < 2 {
        fatalError("Number of teams must be greater than 2: \(teamCount)")
    }

    var rotatingList = Array(2...teamCount)
    var effectiveTeamCount = teamCount

    if teamCount % 2 == 1 {
        rotatingList.append(0) // Adding a 'bye' in case of odd number of teams
        effectiveTeamCount += 1
    }

    for round in 1..<effectiveTeamCount {
        print("Round \(round):", terminator: "")
        let fixedList = [1] + rotatingList
        for i in 0..<(effectiveTeamCount / 2) {
            print(" (\(fixedList[i]) vs \(fixedList[effectiveTeamCount - 1 - i]))", terminator: "")
        }
        print()
        rotatingList.rotate(shift: 1)
    }
}

extension Array {
    mutating func rotate(shift: Int) {
        let index = shift >= 0 ?
            self.index(self.startIndex, offsetBy: self.count - shift, limitedBy: self.endIndex) :
            self.index(self.startIndex, offsetBy: -shift, limitedBy: self.endIndex)

        guard let validIndex = index else { return }
        self = Array(self[validIndex..<self.endIndex] + self[self.startIndex..<validIndex])
    }
}

// Example usage
print("Round robin for 12 players:")
roundRobin(teamCount: 12)
print("\nRound robin for 5 players, 0 denotes a bye:")
roundRobin(teamCount: 5)
