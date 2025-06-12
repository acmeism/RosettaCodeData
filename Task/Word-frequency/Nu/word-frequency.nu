def lesm [] {
  let corp = open --raw 'LES_MISÉRABLES.txt' | str downcase | split words | wrap corp
  let stop = [i a an and are as at be by for from how in is it of on or that the this to was what when where who will with the] | wrap stop
  let tidy = $corp | where corp in $stop.stop == false
  $tidy | histogram value
}

lesm | first 20
