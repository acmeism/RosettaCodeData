# We could cheat and count the bits, but let's keep this general.
# . = dead, # = alive, middle cells survives iff one of the configurations
# below is satisified.
survival_scenarios = [
  '.##' # happy neighbors
  '#.#' # birth
  '##.' # happy neighbors
]

b2c = (b) -> if b then '#' else '.'

cell_next_gen = (left_alive, me_alive, right_alive) ->
  fingerprint = b2c(left_alive) + b2c(me_alive) + b2c(right_alive)
  fingerprint in survival_scenarios

cells_for_next_gen = (cells) ->
  # This function assumes a finite array, i.e. cells can't be born outside
  # the original array.
  (cell_next_gen(cells[i-1], cells[i], cells[i+1]) for i in [0...cells.length])

display = (cells) ->
  (b2c(is_alive) for is_alive in cells).join ''

simulate = (cells) ->
  while true
    console.log display cells
    new_cells = cells_for_next_gen cells
    break if display(cells) == display(new_cells)
    cells = new_cells
  console.log "equilibrium achieved"

simulate (c == '#' for c in ".###.##.#.#.#.#..#..")
