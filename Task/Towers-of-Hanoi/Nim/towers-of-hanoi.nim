proc hanoi(disks: int; fromTower, toTower, viaTower: string) =
  if disks != 0:
    hanoi(disks - 1, fromTower, viaTower, toTower)
    echo("Move disk ", disks, " from ", fromTower, " to ", toTower)
    hanoi(disks - 1, viaTower, toTower, fromTower)

hanoi(4, "1", "2", "3")
