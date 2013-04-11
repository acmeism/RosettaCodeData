class Maze
  # Solve via breadth-first algorithm.
  # Each queue entry is a path, that is list of coordinates with the
  # last coordinate being the one that shall be visited next.
  def solve
    queue = []
    path = nil

    # Enqueue start position.
    enqueue_cell queue, [], @start_x, @start_y

    # Loop as long as there are cells to visit and no solution has
    # been found yet.
    while !queue.empty? && !path
      path = solve_visit_cell queue
    end

    # Clean up.
    reset_visiting_state

    puts "No solution found?!" unless path

    # Mark the cells that make up the shortest path.
    for x, y in path
      @path[y][x] = true
    end
  end

  private

  # Maze solving visiting method.
  def solve_visit_cell(queue)
    # Get the next path.
    path = queue.shift
    # The cell to visit is the last entry in the path.
    x, y = path.last

    # Have we reached the end yet?
    if x == @end_x && y == @end_y
      # Yes, we have!
      return path
    end

    # Mark cell as visited.
    @visited[y][x] = true

    # Left
    new_x = x - 1
    if move_valid?(new_x, y) && !@vertical_walls[y][new_x]
      enqueue_cell queue, path, new_x, y
    end

    # Right
    new_x = x + 1
    if move_valid?(new_x, y) && !@vertical_walls[y][x]
      enqueue_cell queue, path, new_x, y
    end

    # Top
    new_y = y - 1
    if move_valid?(x, new_y) && !@horizontal_walls[new_y][x]
      enqueue_cell queue, path, x, new_y
    end

    # Bottom
    new_y = y + 1
    if move_valid?(x, new_y) && !@horizontal_walls[y][x]
      enqueue_cell queue, path, x, new_y
    end

    # No solution yet.
    return nil
  end

  # Enqueue a new coordinate to visit.
  def enqueue_cell(queue, path, x, y)
    # Copy the current path, add the new coordinates and enqueue
    # the new path.
    path = path.dup
    path << [x, y]
    queue << path
  end
end

# Demonstration:
maze = Maze.new 20, 10
maze.solve
maze.print
