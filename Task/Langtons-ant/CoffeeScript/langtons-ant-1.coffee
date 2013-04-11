class Ant
  constructor: (@world) ->
    @location = [0, 0]
    @direction = 'E'

  move: =>
    [x, y] = @location
    if @world.is_set x, y
      @world.unset x, y
      @direction = Directions.left @direction
    else
      @world.set x, y
      @direction = Directions.right @direction
    @location = Directions.forward(x, y, @direction)

# Model a theoretically infinite 2D world with a hash, allowing squares
# to be black or white (independent of any ants.)
class BlackWhiteWorld
  constructor: ->
    @bits = {}

  set: (x, y) ->
    @bits["#{x},#{y}"] = true

  unset: (x, y) ->
    delete @bits["#{x},#{y}"]

  is_set: (x, y) ->
    @bits["#{x},#{y}"]

  draw: ->
    # Most of this code just involves finding the extent of the world.
    # Always include the origin, even if it's not set.
    @min_x = @max_x = @min_y = @max_y = 0
    for key of @bits
      [xx, yy] = (coord for coord in key.split ',')
      x = parseInt xx
      y = parseInt yy
      @min_x = x if x < @min_x
      @max_x = x if x > @max_x
      @min_y = y if y < @min_y
      @max_y = y if y > @max_y
    console.log "top left: #{@min_x}, #{@max_y}, bottom right: #{@max_x}, #{@min_y}"
    for y in [@max_y..@min_y] by -1
      s = ''
      for x in [@min_x..@max_x]
        if @bits["#{x},#{y}"]
          s += '#'
        else
          s += '_'
      console.log s

# Simple code for directions, independent of ants.
Directions =
  left: (dir) ->
    return 'W' if dir == 'N'
    return 'S' if dir == 'W'
    return 'E' if dir == 'S'
    'N'

  right: (dir) ->
    return 'E' if dir == 'N'
    return 'S' if dir == 'E'
    return 'W' if dir == 'S'
    'N'

  forward: (x, y, dir) ->
    return [x, y+1] if dir == 'N'
    return [x, y-1] if dir == 'S'
    return [x+1, y] if dir == 'E'
    return [x-1, y] if dir == 'W'


world = new BlackWhiteWorld()
ant = new Ant(world)
for i in [1..11500]
  ant.move()
console.log "Ant is at #{ant.location}, direction #{ant.direction}"
world.draw()
