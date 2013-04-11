require 'pp'
# solve(source, via, target)
# Example:
# solve([5, 4, 3, 2, 1], [], [])
# Note this will also solve randomly placed disks,
# "place all disk in target with legal moves only".
def solve(*towers)
  # total number of disks
  disks = towers.inject(0){|sum, tower| sum+tower.length}
  x=0 # sequence number
  pp towers # initial trace
  # have we solved the puzzle yet?
  while towers.last.length < disks do
    x+=1 # assume the next step
    from = (x&x-1)%3
    to = ((x|(x-1))+1)%3
    # can we actually take from tower?
    if top = towers[from].last
      bottom = towers[to].last
      # is the move legal?
      if !bottom || bottom > top
        # ok, do it!
        towers[to].push(towers[from].pop)
        pp towers # trace
      end
    end
  end
end
