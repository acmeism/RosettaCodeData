import "./perm" for Powerset

var sets  = [ [1, 2, 3, 4], [], [[]] ]
for (set in sets) {
    System.print("The power set of %(set) is:")
    System.print(Powerset.list(set))
    System.print()
}
