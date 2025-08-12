from random import shuffle, seed, random_ui64

alias adjacent_rooms: List[List[Int]] = [
  [],
  [2, 5, 8],   [1, 3, 10],  [2, 4, 12],  [3, 5, 14],   [1, 4, 6],
  [5, 7, 15],  [6, 8, 17],  [1, 7, 9],   [8, 10, 18],  [2, 9, 11],
  [10, 12, 19],[2, 11, 13],[12, 14, 20], [4, 13, 15],  [6, 14, 16],
  [15, 17, 20],[7, 16, 18], [9, 17, 19],  [11, 18, 20], [13, 16, 19]
]

struct Game_State:
    var winloss_state: Int
    var player_location: Int
    var wumpus_location: Int
    var pit_locations: Tuple[Int, Int]
    var bat_locations: Tuple[Int, Int]
    var arrows_remaining: Int

    fn __init__(out self):
        var all_locations = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
        shuffle(all_locations)

        self.winloss_state = 0
        self.player_location = all_locations[0]
        self.wumpus_location = all_locations[1]
        self.pit_locations = (all_locations[2], all_locations[3])
        self.bat_locations = (all_locations[4], all_locations[5])
        self.arrows_remaining = 5

    fn __copyinit__(out self, other: Self):
        self.winloss_state = other.winloss_state
        self.player_location = other.player_location
        self.wumpus_location = other.wumpus_location
        self.pit_locations = other.pit_locations
        self.bat_locations = other.bat_locations
        self.arrows_remaining = other.arrows_remaining

fn print_instructions() -> None:
    print("WELCOME TO 'HUNT THE WUMPUS'")
    print("  THE WUMPUS LIVES IN A CAVE OF 20 ROOMS. EACH ROOM")
    print("HAS 3 TUNNELS LEADING TO OTHER ROOMS. (LOOK AT A")
    print("DODECAHEDRON TO SEE HOW THIS WORKS-IF YOU DON'T KNOW")
    print("WHAT A DODECAHEDRON IS, ASK SOMEONE)\n")
    print("     HAZARDS:")
    print(" BOTTOMLESS PITS - TWO ROOMS HAVE BOTTOMLESS PITS IN THEM")
    print("     IF YOU GO THERE, YOU FALL INTO THE PIT (& LOSE!)")
    print(" SUPER BATS - TWO OTHER ROOMS HAVE SUPER BATS. IF YOU")
    print("     GO THERE, A BAT GRABS YOU AND TAKES YOU TO SOME OTHER")
    print("     ROOM AT RANDOM. (WHICH MIGHT BE TROUBLESOME)\n")
    print("     WUMPUS:")
    print(" THE WUMPUS IS NOT BOTHERED BY THE HAZARDS (HE HAS SUCKER")
    print(" FEET AND IS TOO BIG FOR A BAT TO LIFT).  USUALLY")
    print(" HE IS ASLEEP. TWO THINGS WAKE HIM UP: YOUR ENTERING")
    print(" HIS ROOM OR YOUR SHOOTING AN ARROW.")
    print("     IF THE WUMPUS WAKES, HE MOVES (P=.75) ONE ROOM")
    print(" OR STAYS STILL (P=.25). AFTER THAT, IF HE IS WHERE YOU")
    print(" ARE, HE EATS YOU UP (& YOU LOSE!)\n")
    print("     YOU:")
    print(" EACH TURN YOU MAY MOVE OR SHOOT A CROOKED ARROW")
    print("   MOVING: YOU CAN GO ONE ROOM (THRU ONE TUNNEL)")
    print("   ARROWS: YOU HAVE 5 ARROWS. YOU LOSE WHEN YOU RUN OUT.")
    print("   EACH ARROW CAN GO FROM 1 TO 5 ROOMS. YOU AIM BY TELLING")
    print("   THE COMPUTER THE ROOM#S YOU WANT THE ARROW TO GO TO.")
    print("   IF THE ARROW CAN'T GO THAT WAY (IE NO TUNNEL) IT MOVES")
    print("   AT RAMDOM TO THE NEXT ROOM.")
    print("     IF THE ARROW HITS THE WUMPUS, YOU WIN.")
    print("     IF THE ARROW HITS YOU, YOU LOSE.\n")
    print("    WARNINGS:")
    print("     WHEN YOU ARE ONE ROOM AWAY FROM WUMPUS OR HAZARD,")
    print("    THE COMPUTER SAYS:")
    print(" WUMPUS-  'I SMELL A WUMPUS'")
    print(" BAT   -  'BATS NEARBY'")
    print(" PIT   -  'I FEEL A DRAFT'\n")
    return None

fn print_location(game_state: Game_State) -> None:
    if game_state.wumpus_location in adjacent_rooms[game_state.player_location]:
        print("I SMELL A WUMPUS!")
    if game_state.pit_locations[0] in adjacent_rooms[game_state.player_location] or game_state.pit_locations[1] in adjacent_rooms[game_state.player_location]:
        print("I FEEL A DRAFT")
    if game_state.bat_locations[0] in adjacent_rooms[game_state.player_location] or game_state.bat_locations[1] in adjacent_rooms[game_state.player_location]:
        print("BATS NEARBY!")
    print("YOU ARE IN ROOM", game_state.player_location)
    print("TUNNELS LEAD TO", adjacent_rooms[game_state.player_location][0], adjacent_rooms[game_state.player_location][1], adjacent_rooms[game_state.player_location][2])
    return None

fn move_wumpus(mut game_state: Game_State) -> Bool:
    if random_ui64(0,3) != 3:
        game_state.wumpus_location = adjacent_rooms[game_state.wumpus_location][random_ui64(0,2)]
        if game_state.wumpus_location == game_state.player_location:
            print("TSK TSK TSK- WUMPUS GOT YOU!")
            game_state.winloss_state = -1
            return True
    return False

def shoot_action(mut game_state: Game_State) -> None:
    while True:
        distance = Int(input("NO. OF ROOMS(1-5)"))
        if distance >= 1 and distance <= 5:
            break
    path: List[Int] = []
    for i in range(distance):
        while True:
            fork = Int(input("ROOM #"))
            if i <= 1:
                break
            elif fork != path[-2]:
                break
            else:
                print("ARROWS AREN'T THAT CROOKED - TRY ANOTHER ROOM")
                pass
        path.append(fork)
    arrow_location = game_state.player_location
    for i in range(distance):
        if path[i] in adjacent_rooms[arrow_location]:
            arrow_location = path[i]
        else:
            arrow_location = adjacent_rooms[arrow_location][random_ui64(0, 2)]
        if arrow_location == game_state.wumpus_location:
            print("AHA! YOU GOT THE WUMPUS!")
            game_state.winloss_state = 1
            return
        elif arrow_location == game_state.player_location:
            print("OUCH! ARROW GOT YOU!")
            game_state.winloss_state = -1
            return
    print("MISSED")
    if move_wumpus(game_state):
        return
    game_state.arrows_remaining -= 1
    if game_state.arrows_remaining == 0:
        game_state.winloss_state = -1
        return

def move_action(mut game_state: Game_State) -> None:
    while True:
        next_room = Int(input("WHERE TO"))
        if next_room < 1 or next_room > 20:
            pass
        if next_room in adjacent_rooms[game_state.player_location]:
            game_state.player_location = next_room
            break
        if next_room == game_state.player_location:
            break
        print("NOT POSSIBLE -")
    if game_state.player_location == game_state.wumpus_location:
        print("...OOPS! BUMPED A WUMPUS!")
        if move_wumpus(game_state):
            return
    if game_state.player_location == game_state.pit_locations[0] or game_state.player_location == game_state.pit_locations[1]:
        print("YYYIIIIEEEE . . . FELL IN PIT")
        game_state.winloss_state = -1
        return
    if game_state.player_location == game_state.bat_locations[0] or game_state.player_location == game_state.bat_locations[1]:
        print("ZAP--SUPER BAT SNATCH! ELSEWHEREVILLE FOR YOU!")
        move_action(game_state, Int(random_ui64(1, 20)))
    return

fn move_action(mut game_state: Game_State, room_number: Int) -> None:
    game_state.player_location = room_number
    if game_state.player_location == game_state.wumpus_location:
        print("...OOPS! BUMPED A WUMPUS!")
        if move_wumpus(game_state):
            return
    if game_state.player_location == game_state.pit_locations[0] or game_state.player_location == game_state.pit_locations[1]:
        print("YYYIIIIEEEE . . . FELL IN PIT")
        game_state.winloss_state = -1
        return
    if game_state.player_location == game_state.bat_locations[0] or game_state.player_location == game_state.bat_locations[1]:
        print("ZAP--SUPER BAT SNATCH! ELSEWHEREVILLE FOR YOU!")
        move_action(game_state, Int(random_ui64(1, 20)))
    return

def main():
    seed()
    instruct_cond = input("INSTRUCTIONS (Y-N)")
    if instruct_cond != 'N':
        print_instructions()

    game_state = Game_State()
    saved_state = game_state

    game_is_running = True
    while game_is_running:
        print("HUNT THE WUMPUS\n")
        print_location(game_state)
        action = input("SHOOT OR MOVE (S-M)")

        if action == 'S':
            shoot_action(game_state)
        elif action == 'M':
            move_action(game_state)
        if game_state.winloss_state == -1:
            print("HA HA HA - YOU LOSE!")
        elif game_state.winloss_state == 1:
            print("HEE HEE HEE - THE WUMPUS'LL GETCHA NEXT TIME!!")
        if game_state.winloss_state != 0:
            state_update = input("SAME SET-UP (Y-N)")
            if state_update == 'Y':
                game_state = saved_state
            else:
                game_state = Game_State()
                saved_state = game_state
