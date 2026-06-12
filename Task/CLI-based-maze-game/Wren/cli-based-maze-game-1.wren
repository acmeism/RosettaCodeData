/* CLI-based_maze_game.wren */

import "./dynamic" for Enum, Tuple, Struct
import "./str" for Char
import "./iterate" for Stepped
import "random" for Random

// all methods assume stdscr
class NC {
    foreign static initScr()

    foreign static cbreak()
    foreign static nocbreak()

    foreign static keypad(bf)

    foreign static echo()
    foreign static noecho()

    foreign static cursSet(visibility)

    foreign static erase()

    foreign static addStr(str)

    foreign static getch()

    foreign static move(y, x)

    foreign static refresh()

    foreign static endwin()
}

var KeyUp    = 259
var KeyDown  = 258
var KeyLeft  = 260
var KeyRight = 261

var Mx = 69  // no of columns (0..Mx-1), must be odd
var My = 31  // no of rows (0..My-1), must be odd
var Treasure = Char.code("$")
var TreasureDb = 3 // how many $ signs will be placed
var Way  = Char.code(" ")
var Wall = Char.code("X")
var Doors = 20 // no of doors
var DoorCenter = Char.code("o")
var DoorWingVertical = Char.code("|")
var DoorWingHorizontal = Char.code("-")
var Hero = Char.code("@")
var DeadHero = Char.code("+")
var NumberOfBombs = 5
var Bomb = Char.code("b")
var NumberOfMonsters = 20
var Monster = Char.code("*")
var WeakMonster = Char.code(".")

// the higher this is, the lower the chance that a string monster will become weak
var MonsterWeaknessProbability = 25

// the higher this is, the lower the chance that a weak monster will get stronger
var MonsterIntensifiesProbability = 5

var HelpText = """
  Maze game.

The object of the game is to get all the treasures. The symbol of the treasure is the $ sign.
Help (display this text): press ? or h
Exit: press Esc or q
You can detonate a bomb by pressing b, but only as long as your bomb remains.
A bomb destroys every wall around the player (the outermost, framing of the maze
except for its walls), but it won't kill monsters.
The bomb does not destroy diagonally, only vertically and horizontally.
The bomb will not destroy the doors or the treasure.
You can also find bombs in the maze, represented by the letter b. If you step on them,
you got the bomb with it, that is, the number of your bombs increases, for later use.
The game ends when you have acquired all the treasures.
The maze has not only walls but also revolving doors.
The revolving door, if horizontal, looks like this: -o-
If vertical, like this:
 |
 o
 |
The center of the revolving door is represented by the character o, the wings by the line.
The revolving door can be rotated if you take your wing in the right direction with your character,
and if nothing stands in the way of rotation.
The player is represented by @ in the game, and his starting point is always in the lower left corner.
There is a possibility of a little cheating in the game: each press of the letter c increases by one
the amount of your bombs.
"""

var Direction = Enum.create("Direction", ["left", "right", "up", "down"])
var Position = Tuple.create("Position", ["x", "y"])

var gameFields = ["grid", "scoords", "showHelp", "terminate", "treasureCounter", "bombs", "x", "y"]
var Game = Struct.create("Game", gameFields)

var None = Position.new(0, 0)
var Dy = [-1, 1, 0, 0]
var Dx = [0, 0, -1, 1]

var rand = Random.new()

var genFlags = Fn.new { |n|
    var flags = List.filled(n, false)
    for (i in Stepped.new(0...n, 2)) flags[i] = true
    return flags
}

var initGame = Fn.new {
    var grid = List.filled(My, null)
    for (y in 0...My) grid[y] = List.filled(Mx, Wall)
    for (y in 1...My-1) {
        for (x in 1...Mx-1) grid[y][x] = Way
    }
    var colFlags = genFlags.call(Mx)
    var rowFlags = genFlags.call(My)
    while (colFlags.any { |f| f } || rowFlags.any { |f| f }) {
        var dir = rand.int(4)
        var j = rand.int((dir <= Direction.right) ? My : Mx)
        if (j % 2 == 1) j = j + 1
        if (dir == Direction.left) {
            if (rowFlags[j]) {
                for (r in 0...Mx-1) {
                    if (grid[j][r] != Wall && grid[j][r+1] != Wall) grid[j][r] = Wall
                }
                rowFlags[j] = false
            }
        } else if (dir == Direction.right) {
            if (rowFlags[j]) {
                for (r in Mx-1..2) {
                    if (grid[j][r-1] != Wall && grid[j][r-2] != Wall) grid[j][r-1] = Wall
                }
                rowFlags[j] = false
            }
        } else if (dir == Direction.up) {
            if (colFlags[j]) {
                for (c in My-1..2) {
                    if (grid[c-1][j] != Wall && grid[c-2][j] != Wall) grid[c-1][j] = Wall
                }
                colFlags[j] = false
            }
        } else if (dir == Direction.down) {
            if (colFlags[j]) {
                for (c in 0...My-1) {
                    if (grid[c][j] != Wall && grid[c+1][j] != Wall) grid[c][j] = Wall
                }
                colFlags[j] = false
            }
        }
    }
    var doorsPlaced = 0
    while (doorsPlaced < Doors) {
        var x = rand.int(2, Mx - 2)
        var y = rand.int(2, My - 2)
        if (grid[y][x]     != Way  &&
            grid[y-1][x-1] == Way  &&  // top left corner free
            grid[y-1][x+1] == Way  &&  // top right corner free
            grid[y+1][x-1] == Way  &&  // left corner free
            grid[y+1][x+1] == Way) {   // right corner free
            // let's see if we can put a vertical door
            if (grid[y-1][x] == Wall &&    // wall above the current position
                grid[y-2][x] == Wall &&    // wall above the current position
                grid[y+1][x] == Wall &&    // wall below the current position
                grid[y+2][x] == Wall &&    // wall below the current position
                grid[y][x-1] == Way  &&    // left neighbor free
                grid[y][x+1] == Way) {     // right neighbor free
                grid[y][x]   = DoorCenter
                grid[y-1][x] = DoorWingVertical
                grid[y+1][x] = DoorWingVertical
                doorsPlaced  = doorsPlaced + 1
            // let's see if we can put a horizontal door
            } else if (grid[y][x-1] == Wall &&   // wall left of the current position
                       grid[y][x-2] == Wall &&   // wall left of the current position
                       grid[y][x+1] == Wall &&   // wall right of the current position
                       grid[y][x+2] == Wall &&   // wall right of the current position
                       grid[y+1][x] == Way  &&   // above neighbor free
                       grid[y-1][x] == Way) {    // below neighbor free
                grid[y][x]   = DoorCenter
                grid[y][x-1] = DoorWingHorizontal
                grid[y][x+1] = DoorWingHorizontal
                doorsPlaced  = doorsPlaced + 1
            }
        }
    }
    var scoords = List.filled(NumberOfMonsters, null)
    for (i in 0...NumberOfMonsters) scoords[i] = Position.new(0, 0)
    var stuff = [
        [TreasureDb, Treasure],
        [NumberOfBombs, Bomb],
        [NumberOfMonsters, WeakMonster] // at first, all monsters are weak
    ]
    for (s in stuff) {
        var n = s[0]
        var what = s[1]
        var iter = 1
        while (n >= 0) {
            var x = rand.int(Mx)
            var y = rand.int(My)
            if (grid[y][x] == Way) {
                grid[y][x] = what
                if (what == WeakMonster) scoords[n-1] = Position.new(x, y)
                n = n - 1
            }
            iter = iter + 1
            if (iter > 10000) Fiber.abort("Something went wrong.") // sanity check
        }
    }
    grid[My - 2][1] = Hero
    return Game.new(grid, scoords, false, false, 0, 3, 1, My - 2)
}

var draw = Fn.new { |game|
    NC.cursSet(0)
    while (true) {
        if (game.showHelp) {
            NC.erase()
            NC.addStr(HelpText)
            NC.getch()
            NC.erase()
            game.showHelp = false
        }
        NC.erase()
        NC.move(0, 0)
        for (row in game.grid) NC.addStr(row.map { |c| String.fromByte(c) }.join() + "\n")
        NC.addStr("\n\nCollected treasure = %(game.treasureCounter)     Bombs = %(game.bombs)\n")
        NC.refresh()
        Fiber.yield()
    }
}

var monsterStepFinder = Fn.new { |game, sx, sy|
    var result = None
    var m = [0, 1, 2, 3]
    rand.shuffle(m)
    for (i in m) {
        var nx = sx + Dx[i]
        var ny = sy + Dy[i]
        if (ny >= 0 && ny < My && nx >= 0 && nx < Mx && [Way, Hero].contains(game.grid[ny][nx])) {
            result = Position.new(nx, ny)
        }
    }
    return result
}

var monsterMove = Fn.new { |game|
    while (true) {
        var active = rand.int(NumberOfMonsters)
        var pos = game.scoords[active]
        var sx = pos.x
        var sy = pos.y
        if (sx != 0) {
            var ch = game.grid[sy][sx]
            if (ch == Monster) {
                if (rand.int(MonsterWeaknessProbability) == 0) {
                    game.grid[sy][sx] = WeakMonster
                } else {
                    var monster = monsterStepFinder.call(game, sx, sy)
                    if (monster.x != 0 && monster.y != 0) {
                        if (game.grid[monster.y][monster.x] == Hero) {
                            game.grid[monster.y][monster.x] = DeadHero
                            game.terminate = true
                            break
                        }
                    }
                    game.grid[sy][sx] = Way
                    game.grid[monster.y][monster.x] = Monster
                    game.scoords[active] = monster
                }
            } else if (ch == WeakMonster) {
                if (rand.int(MonsterIntensifiesProbability) == 0) {
                    game.grid[sy][sx] = Monster
                } else {
                    var monster = monsterStepFinder.call(game, sx, sy)
                    if (monster.x != 0 && monster.y != 0) {
                        if (game.grid[monster.y][monster.x] == Hero) {
                            game.grid[monster.y][monster.x] = WeakMonster
                            game.scoords[active] = monster
                            break
                        } else {
                            game.scoords[active] = None
                        }
                    }
                }
            }
        }
        Fiber.yield()
    }
}

var rotateDoor = Fn.new { |game, nx, ny|
    for (i in 1..4) {
        var wy = Dy[i-1]
        var wx = Dx[i-1]
        var cy = ny + wy
        var cx = nx + wx
        if (game.grid[cy][cx] == DoorCenter) {
            if (game.grid[cy-1][cx-1] == Way &&
                game.grid[cy-1][cx+1] == Way &&
                game.grid[cy+1][cx-1] == Way &&
                game.grid[cy+1][cx+1] == Way) {  // 4 corners empty
                var py = Dy[-i]
                var px = Dx[-i]
                if (game.grid[cy+py][cx+px] == Way &&
                    game.grid[cy-py][cx-px] == Way) { // swung door empty
                    var door = game.grid[ny][nx]
                    var flip = DoorWingVertical ? DoorWingHorizontal : DoorWingVertical
                    game.grid[cy+py][cx+px] = flip
                    game.grid[cy-py][cx-px] = flip
                    game.grid[cy+wy][cx+wx] = Way
                    game.grid[cy-wy][cx-wx] = Way
                }
            }
            break
        }
    }
}

var keyboard = Fn.new { |game|
    while (true) {
        var key = NC.getch()
        if (key == Char.code("\e") || key == Char.code("q")) {
            game.terminate = true
            break
        } else if (key == Char.code("b")) {
            if (game.bombs != 0) {
                game.bombs = game.bombs - 1
                for (i in 0..3) {
                    var nx = game.x + Dx[i]
                    var ny = game.y + Dy[i]
                    if (ny >= 1 && ny < My-1 && nx >= 1 && nx < Mx-1 && game.grid[ny][nx] == Wall) {
                        game.grid[ny][nx] =  Way
                    }
                }
            }
        } else if (key == Char.code("c")) {
            game.bombs = game.bombs + 1
        } else if (key == Char.code("?") || key == Char.code("h")) {
            game.showHelp = true
        } else {
            var chIndex = [KeyUp, KeyDown, KeyLeft, KeyRight].indexOf(key)
            if (chIndex >= 0) {
                var nx = game.x + Dx[chIndex]
                var ny = game.y + Dy[chIndex]
                if (ny >= 1 && ny < My-1 && nx >= 1 && nx < Mx-1) {
                    var ch = game.grid[ny][nx]
                    if (ch == DoorWingVertical || ch == DoorWingHorizontal) {
                        game.grid[game.y][game.x] = Way  // temp. "ghost" him
                        rotateDoor.call(game, nx, ny)
                        game.grid[game.y][game.x] = Hero
                        ch = game.grid[ny][nx]  // may be unaltered
                    } else if (ch == Monster) {
                        game.grid[game.y][game.x] = Way
                        game.grid[ny][nx] = DeadHero
                        game.y = ny
                        game.x = nx
                        game.terminate = true
                        break
                    } else if (ch == Treasure) {
                        game.treasureCounter = game.treasureCounter + 1
                        if (game.treasureCounter == TreasureDb) {
                            game.grid[game.y][game.x] = Way
                            game.grid[ny][nx] = Hero
                            game.y = ny
                            game.x = nx
                            game.terminate = true
                            break
                        }
                        ch = Way
                    } else if (ch == Bomb) {
                        game.bombs = game.bombs + 1
                        ch = Way
                    }
                    if (ch == Way || ch == WeakMonster) {
                        game.grid[game.y][game.x] = Way
                        game.grid[ny][nx] = Hero
                        game.y = ny
                        game.x = nx
                    }
                }
            }
        }
        Fiber.yield()
    }
}

var play = Fn.new {
    NC.initScr()
    NC.cbreak()
    NC.keypad(true)
    NC.noecho()
    var game = initGame.call()
    var fDraw = Fiber.new(draw)
    var fKeyboard = Fiber.new(keyboard)
    var fMonsterMove = Fiber.new(monsterMove)
    while (true) {
        fDraw.call(game)
        if (game.terminate) break
        fKeyboard.call(game)
        if (!game.terminate) fMonsterMove.call(game)
    }
    if (game.treasureCounter == TreasureDb) {
        NC.addStr("\nYOU WON! Congratulations!\n")
        NC.refresh()
        NC.getch()
    } else if (game.grid[game.y][game.x] == DeadHero) {
        NC.addStr("\nYOU PERISHED!\n")
        NC.refresh()
        NC.getch()
    }
}

play.call()
NC.echo()
NC.nocbreak()
NC.endwin()
NC.cursSet(1)
