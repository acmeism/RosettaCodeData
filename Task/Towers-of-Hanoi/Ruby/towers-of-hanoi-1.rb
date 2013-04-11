def move(num_disks, starting_stick, target_stick, using_stick)
  if num_disks == 1
    target_stick << starting_stick.shift
    status
  else
    move(num_disks-1, starting_stick, using_stick, target_stick)
    move(1, starting_stick, target_stick, using_stick)
    move(num_disks-1, using_stick, target_stick, starting_stick)
  end
end
