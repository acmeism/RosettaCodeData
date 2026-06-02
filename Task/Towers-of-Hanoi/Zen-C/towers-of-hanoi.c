fn hanoi(disk: int, from: string, to: string, via: string, pmoves: int*) {
    if disk > 0 {
        hanoi(disk - 1, from, via, to, pmoves);
        *pmoves += 1;
        println "Move disk {disk} from {from} to {to}";
        hanoi(disk - 1, via, to, from, pmoves);
    }
}

fn main() {
    let disks = [3, 4];
    for disk in disks {
        println "Towers of Hanoi with {disk} disks:\n";
        let moves = 0;
        hanoi(disk, "L", "C", "R", &moves);
        println "\nCompleted in {moves} moves.\n";
    }
}
