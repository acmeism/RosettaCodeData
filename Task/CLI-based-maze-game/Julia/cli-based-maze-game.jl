using Ansillary
using Crayons
using Random

const Mx = 69 # No of columns (1..Mx), must be odd.
const My = 31 # No of rows (1..My), must be odd.
const Treasure = '$'
const TreasureDb = 3 # How many $ signs will be placed.
const Way = ' '
const Wall = 'X'
const Doors = 20 # No of doors.
const DoorCenter = 'o'
const DoorWingVertical = '|'
const DoorWingHorizontal = '-'
const Hero = '@'
const DeadHero = '+'
const NumberOfBombs = 5
const Bomb = 'b'
const NumberOfMonsters = 20
const Monster = '*'
const WeakMonster = '.'
const MonsterWeaknessProbability = 25
    # The higher the above number, the lower the chance that a strong monster will become weak.
const MonsterIntensifiesProbability = 5
    # The higher the number above, the lower the chance that a weak monster will get stronger.
const HelpText = """
  Maze game.

The object of the game is to get all the treasures. The symbol of the treasure is the \$ sign.
Help (display this text): press ? or h
Exit: press Esc or q
You can detonate a bomb by pressing b, but only as long as your bomb remains.
A bomb destroys every wall around the player (the outermost, framing of the maze
except for its walls), but it won't kill monsters.
The bomb does not destroy diagonally, only vertically and horizontally.
The bomb will not destroy the doors or the treasure.
You can also find bombs in the maze, represented by the letter b. If you step on them,
you get the bomb with it, so that the number of your bombs increases for later use.
The game ends when you have acquired all the treasures.

The maze has not only walls but also revolving doors.
The revolving door, if horizontal, looks like this: -o-
If vertical, like this:
 |
 o
 |
The center of the revolving door is represented by the character o, the wings by the line.
The revolving door can be rotated if you move into a door wing in the right direction with
your character, as long as nothing stands in the way of door rotation.
The player is represented by @ in the game, and his starting point is always in the lower left corner.
There is a possibility of a little cheating in the game: each press of the letter c increases the
number of remaining bombs by one.

(This help screen closes after 10 seconds.)
"""

const Position = NamedTuple{(:x, :y)}

mutable struct Game
    grid::Matrix{Char}
    scoords::Vector{Position}
    showhelp::Bool
    terminate::Bool
    counterschanged::Bool
    treasurecounter::Int
    bombs::Int
    x::Int
    y::Int
end

const NoPosition = Position((0, 0))
const Dy = [-1, 1, 0, 0]
const Dx = [0, 0, -1, 1]
@enum Direction Left Right Up Down
const gamelock = ReentrantLock()

""" Game constructor for game initialization """
function Game()
    grid = fill(Way, My, Mx)
    grid[[begin, end], begin:end] .= Wall
    grid[begin+1:end-1, [begin, end]] .= Wall
    colflags = [isodd(n) for n in 1:Mx]
    rowflags = [isodd(n) for n in 1:My]

    while any(colflags) || any(rowflags)
        direction = rand([Left, Right, Up,  Down])
        j = rand(1:(direction in [Left, Right] ? My : Mx)) ÷ 2 * 2 + 1 # if even, add one
        if direction == Left && rowflags[j]
            for r in 1:Mx-1
                if grid[j, r] != Wall && grid[j, r+1] != Wall
                    grid[j, r] = Wall
                end
            end
            rowflags[j] = false
        elseif direction == Right && rowflags[j]
            for r in Mx:-1:3
                if grid[j, r-1] != Wall && grid[j, r-2] != Wall
                    grid[j, r-1] = Wall
                end
            end
            rowflags[j] = false
        elseif direction == Up && colflags[j]
            for c in My:-1:3
                if grid[c-1, j] != Wall && grid[c-2, j] != Wall
                    grid[c-1, j] = Wall
                end
            end
            colflags[j] = false
        elseif direction == Down && colflags[j]
            for c in 1:My-1
                if grid[c, j] != Wall && grid[c+1, j] != Wall
                    grid[c, j] = Wall
                end
            end
            colflags[j] = false
        end
    end
    doorsplaced = 0
    while doorsplaced < Doors
        x = rand(3:Mx-2)
        y = rand(3:My-2)
        if grid[y, x] != Way && grid[y-1, x-1] == Way && grid[y-1, x+1] == Way &&
           grid[y+1, x-1] == Way && grid[y+1, x+1] == Way # corners free?
            if grid[y-1, x] == Wall && grid[y-2, x] == Wall && grid[y+1, x] == Wall &&
               grid[y+2, x] == Wall && grid[y, x-1] == Way && grid[y, x+1] == Way
                grid[y, x] = DoorCenter
                grid[y-1, x] = DoorWingVertical
                grid[y+1, x] = DoorWingVertical
                doorsplaced += 1
            elseif grid[y, x-1] == Wall && grid[y, x-2] == Wall && grid[y, x+1] == Wall &&
               grid[y, x+2] == Wall && grid[y+1, x] == Way && grid[y-1, x] == Way
                grid[y, x] = DoorCenter
                grid[y, x-1] = DoorWingHorizontal
                grid[y, x+1] = DoorWingHorizontal
                doorsplaced += 1
            end
        end
    end
    # note all monsters start as weak (weak ones count == NumberofMonsters)
    scoords = Position[]
    stuff = [(TreasureDb, Treasure), (NumberOfBombs, Bomb),(NumberOfMonsters, WeakMonster)]
    for (n, what) in stuff
        iterations = 1
        cnt = n
        while cnt > 0
            x = rand(1:Mx)
            y = rand(1:My)
            if grid[y, x] == Way
                grid[y, x] = what
                cnt -= 1
                what == WeakMonster && push!(scoords, Position((x, y)))
            end
            iterations += 1
            @assert iterations <= 10_000 # (sanity check)
        end
    end
    grid[end-1, begin+1] = Hero
    return Game(grid, scoords, false, false, true, 0, 3, 2, My - 1)
end

function draw!(game)
    while true
        lock(gamelock)
        if game.showhelp
            Screen.clear!(Screen.All())
            Cursor.move!(Cursor.Coordinate(1, 1))
            print(HelpText)
            sleep(10)
            Screen.clear!(Screen.All())
            game.showhelp = false
            game.counterschanged = true
        end
        Cursor.move!(Cursor.Coordinate(1, 1))
        for row in eachrow(game.grid)
            s = join(row) # colorize
            s = replace(s, Treasure => "$(crayon"light_green")$Treasure$(crayon"white")")
            s = replace(s, Monster => "$(crayon"light_red")$Monster$(crayon"white")")
            s = replace(s, Hero => "$(crayon"light_yellow")$Hero$(crayon"white")")
            s = replace(s, Bomb => "$(crayon"light_blue")$Bomb$(crayon"white")")
            println(s)
        end
        if game.counterschanged
            print("\n\nCollected treasures = $(game.treasurecounter)     Bombs = $(game.bombs)\n")
            game.counterschanged = false
        end
        unlock(gamelock)
        game.terminate && break
        sleep(0.05)
    end
end

function monsterstepfinder(game, sx, sy)
    result = NoPosition
    for i in shuffle(1:4)
        nx = sx + Dx[i]
        ny = sy + Dy[i]
        if ny in 1:My && nx in 1:Mx && game.grid[ny, nx] in [Way, Hero]
            result = Position((nx, ny))
        end
    end
    return result
end

function monstermove!(game)
    cnt = 0
    while true
        active = rand(1:NumberOfMonsters)
        pos = game.scoords[active]
        sx, sy = pos.x, pos.y
        if sy in 1:My && sx in 1:Mx
            ch = game.grid[sy, sx]
            if ch == Monster
                if rand(1:MonsterWeaknessProbability) == 1
                    game.grid[sy, sx] = WeakMonster
                else
                    monster = monsterstepfinder(game, sx, sy)
                    if monster != NoPosition && monster.y in 1:My && monster.x in 1:Mx
                        if game.grid[monster.y, monster.x] == Hero
                            game.grid[monster.y, monster.x] = DeadHero
                            game.terminate = true
                            break
                        end
                    end
                    game.grid[sy, sx] = Way
                    if monster.y in 1:My && monster.x in 1:Mx
                        game.grid[monster.y, monster.x] = Monster
                        game.scoords[active] = monster
                    end
                end
            elseif ch == WeakMonster
                if rand(1:MonsterIntensifiesProbability) == 1
                    game.grid[sy, sx] = Monster
                else
                    monster = monsterstepfinder(game, sx, sy)
                    if monster != NoPosition && monster.y in 1:My && monster.x in 1:Mx
                        if game.grid[monster.y, monster.x] != Hero
                            game.grid[monster.y, monster.x] = WeakMonster
                            game.scoords[active] = monster
                        else
                            game.scoords[active] = NoPosition
                        end
                    end
                end
            end
        end
        sleep(0.2)
    end
end

function rotatedoor!(game, nx, ny)
    for i in 1:4
        wy = Dy[i]
        wx = Dx[i]
        cy = ny + wy
        cx = nx + wx
        if game.grid[cy, cx] == DoorCenter
            if game.grid[cy-1, cx-1] == Way &&
              game.grid[cy-1, cx+1] == Way &&
              game.grid[cy+1, cx-1] == Way &&
              game.grid[cy+1, cx+1] == Way  # four corners empty
                py = Dy[end-i+1]
                px = Dx[end-i+1]
                if game.grid[cy+py, cx+px] == Way &&
                  game.grid[cy-py, cx-px] == Way  # swung door empty
                    door = game.grid[ny, nx]
                    flip = door == DoorWingVertical ? DoorWingHorizontal : DoorWingVertical
                    game.grid[cy+py, cx+px] = flip
                    game.grid[cy-py, cx-px] = flip
                    game.grid[cy+wy, cx+wx] = Way
                    game.grid[cy-wy, cx-wx] = Way
                end
            end
            break
        end
    end
end

function keyboard!(game)
    cnt = 0
    Screen.raw() do
        for event in Inputs.Events()
            key = lowercase(string(event))
            sleep(0.01)
            if key in ["esc", "q"]
                game.terminate = true
                break
            elseif key == "b"
                if game.bombs > 0
                    lock(gamelock)
                    game.bombs -= 1
                    game.counterschanged = true
                    for i in 1:4
                        nx = game.x + Dx[i]
                        ny = game.y + Dy[i]
                        if ny in 2:My-1 && nx in 2:Mx-1 && game.grid[ny, nx] == Wall
                            game.grid[ny, nx] = Way
                        end
                    end
                    unlock(gamelock)
                end
            elseif key == "c"
                game.bombs += 1
                game.counterschanged = true
            elseif key in ["?", "h"]
                game.showhelp = true
            else
                chindex = findfirst(==(key), ["up", "down", "left", "right"])
                if chindex != nothing
                    nx = game.x + Dx[chindex]
                    ny = game.y + Dy[chindex]
                    if ny in 2:My-1 && nx in 2:Mx-1
                        ch = game.grid[ny, nx]
                        if ch in [DoorWingVertical, DoorWingHorizontal]
                                lock(gamelock)
                                game.grid[game.y, game.x] = Way   # (temp. "ghost" him)
                                rotatedoor!(game, nx, ny)
                                game.grid[game.y, game.x] = Hero
                                unlock(gamelock)
                                ch = game.grid[ny, nx]            # (maybe unaltered)
                        elseif ch == Monster
                            lock(gamelock)
                            game.grid[game.y, game.x] = Way
                            game.grid[ny, nx] = DeadHero
                            game.y = ny
                            game.x = nx
                            game.terminate = true
                            unlock(gamelock)
                            break
                        elseif ch == Treasure
                            game.treasurecounter += 1
                            game.counterschanged = true
                            ch = Way
                            if game.treasurecounter == TreasureDb
                                lock(gamelock)
                                game.grid[game.y, game.x] = Way
                                game.grid[ny, nx] = Hero
                                game.y = ny
                                game.x = nx
                                game.terminate = true
                                unlock(gamelock)
                                break
                            end
                        elseif ch == Bomb
                            game.bombs += 1
                            game.counterschanged = true
                            ch = Way
                        end
                        if ch in [Way, WeakMonster]
                            lock(gamelock)
                            game.grid[game.y, game.x] = Way
                            game.grid[ny, nx] = Hero
                            game.y = ny
                            game.x = nx
                            unlock(gamelock)
                        end
                    end
                end
            end
            sleep(0.01)
        end
    end
end

function play()
    print(Crayon(background=(0,0,0), foreground=(250,250,250))) # white on black
    Screen.clear!(Screen.All())
    game = Game()
    @async draw!(game)
    @async keyboard!(game)
    @async monstermove!(game)
    while !game.terminate
        sleep(1)
    end
    if game.treasurecounter == TreasureDb
        print("\nYOU WON! Congratulations!\n")
    elseif game.grid[game.y, game.x] == DeadHero
        print("\nYOU PERISHED!\n")
    end
end

play()
