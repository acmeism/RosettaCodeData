graph_tours = (graph, max_num_solutions) ->
  # graph is an array of arrays
  # graph[3] = [4, 5] means nodes 4 and 5 are reachable from node 3
  #
  # Returns an array of tours (up to max_num_solutions in size), where
  # each tour is an array of nodes visited in order, and where each
  # tour visits every node in the graph exactly once.
  #
  complete_tours = []
  visited = (false for node in graph)
  dead_ends = ({} for node in graph)
  tour = [0]

  valid_neighbors = (i) ->
    arr = []
    for neighbor in graph[i]
      continue if visited[neighbor]
      continue if dead_ends[i][neighbor]
      arr.push neighbor
    arr

  next_square_to_visit = (i) ->
    arr = valid_neighbors i
    return null if arr.length == 0

    # We traverse to our neighbor who has the fewest neighbors itself.
    fewest_neighbors = valid_neighbors(arr[0]).length
    neighbor = arr[0]
    for i in [1...arr.length]
      n = valid_neighbors(arr[i]).length
      if n < fewest_neighbors
        fewest_neighbors = n
        neighbor = arr[i]
    neighbor

  while tour.length > 0
    current_square = tour[tour.length - 1]
    visited[current_square] = true
    next_square = next_square_to_visit current_square
    if next_square?
      tour.push next_square
      if tour.length == graph.length
        complete_tours.push (n for n in tour) # clone
        break if complete_tours.length == max_num_solutions
      # pessimistically call this a dead end
      dead_ends[current_square][next_square] = true
      current_square = next_square
    else
      # we backtrack
      doomed_square = tour.pop()
      dead_ends[doomed_square] = {}
      visited[doomed_square] = false
  complete_tours


knight_graph = (board_width) ->
  # Turn the Knight's Tour into a pure graph-traversal problem
  # by precomputing all the legal moves.  Returns an array of arrays,
  # where each element in any subarray is the index of a reachable node.
  index = (i, j) ->
    # index squares from 0 to n*n - 1
    board_width * i + j

  reachable_squares = (i, j) ->
    deltas = [
      [ 1,  2]
      [ 1, -2]
      [ 2,  1]
      [ 2, -1]
      [-1,  2]
      [-1, -2]
      [-2,  1]
      [-2, -1]
    ]
    neighbors = []
    for delta in deltas
      [di, dj] = delta
      ii = i + di
      jj = j + dj
      if 0 <= ii < board_width
        if 0 <= jj < board_width
          neighbors.push index(ii, jj)
    neighbors

  graph = []
  for i in [0...board_width]
    for j in [0...board_width]
      graph[index(i, j)] = reachable_squares i, j
  graph

illustrate_knights_tour = (tour, board_width) ->
  pad = (n) ->
    return " _" if !n?
    return " " + n if n < 10
    "#{n}"

  console.log "\n------"
  moves = {}
  for square, i in tour
    moves[square] = i + 1
  for i in [0...board_width]
    s = ''
    for j in [0...board_width]
      s += "  " + pad moves[i*board_width + j]
    console.log s

BOARD_WIDTH = 8
MAX_NUM_SOLUTIONS = 100000

graph = knight_graph BOARD_WIDTH
tours = graph_tours graph, MAX_NUM_SOLUTIONS
console.log "#{tours.length} tours found (showing first and last)"
illustrate_knights_tour tours[0], BOARD_WIDTH
illustrate_knights_tour tours.pop(), BOARD_WIDTH
