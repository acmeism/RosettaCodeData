class Hanoi {
    construct new(disks) {
        _moves = 0
        System.print("Towers of Hanoi with %(disks) disks:\n")
        move(disks, "L", "C", "R")
        System.print("\nCompleted in %(_moves) moves\n")
    }

    move(n, from, to, via) {
        if (n > 0) {
            move(n - 1, from, via, to)
            _moves = _moves + 1
            System.print("Move disk %(n) from %(from) to %(to)")
            move(n - 1, via, to, from)
        }
    }
}

Hanoi.new(3)
Hanoi.new(4)
