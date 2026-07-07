Program Wumpus;

type
    caveRoom = 1..20;
    pathRoom = 1..5;
    playerState = (IN_PLAY, WON, LOST);
    gameOption = (QUIT_GAME, SAME_ROOMS, NEW_ROOMS);
    playOption = (MOVE_ME, SHOOT, WHERE_AM_I, GAME_STATE, CAVE_ROOMS, SHUFFLED_ROOMS);
    yesnoOption = (YES, NO);
    gameState = record
        hunter : caveRoom;
        wumpus : caveRoom;
        pits : array [1..2] of caveRoom;
        bats : array [1..2] of caveRoom;
        arrows : 0..5;
        player : playerState
    end;

const
    wumpus_version : string = 'Version 1.00 - Pascal';
    instructions : array [1..59] of string = (
        '---- INSTRUCTIONS ----',
        '',
        'Welcome to Hunt the Wumpus! You are a hunter, looking to bag a Wumpus.',
        '',
        'The Wumpus lives in a cave of twenty rooms, each connected by',
        'tunnels to three other rooms, as in a dodecahedron.',
        '',
        'There are HAZARDS!!',
        '',
        'The Wumpus - One room has the Wumpus in it. If the Wumpus',
        'finds you in the room with it, it will eat you and you lose.',
        '',
        'Bottomless Pits - Two rooms have bottomless pits in them.',
        'If you go there, you fall into the pit and lose.',
        '',
        'Super Bats - Two other rooms have super bats in them.',
        'If you go there, a bat grabs you and takes you to another',
        'room, at random. This might be troublesome.',
        '',
        'As you are hunting, you will be able to sense something of',
        'the hazards, when you are in a room adjacent to one.',
        '',
        '- You can smell the Wumpus, when it is nearby.',
        '- You can feel a breeze, when there is a pit nearby',
        '- You can hear a rustling sound, when there are bats nearby.',
        '',
        'The Wumpus is not bothered by the hazards. It has sucker',
        'feet, so it can cling to the walls of a pit, and it''s too heavy',
        'for the super bats to lift. Usually, it is asleep.',
        '',
        'Two things wake up the Wumpus: you entering its room, or',
        'you shooting an arrow (anywhere in the cave!). When it',
        'wakes, it moves into an adjacent room (P=3/4) or stays',
        'where it is (P=1/4). After that, if it is where you are',
        'it eats you and you lose.',
        '',
        'The computer starts you in a randomly chosen room.',
        'Each turn you can move to an adjacent room or shoot an arrow.',
        '',
        'You are furnished with 5 crooked arrows, which you can program',
        'to go into 1 to 5 rooms. Starting from the room you are in,',
        'the arrow will go from room to room provided there is a tunnel',
        'from where it is to the next room on its list. If there is no',
        'tunnel, the arrow bounces on the walls of the cave and moves into',
        'an adjacent room at random, possibly the one you are in.',
        '',
        '- If the arrow hits the Wumpus, you win.',
        '- If the arrow hits you, you lose.',
        '- If you run out of arrows, you lose.',
        '',
        'When the game is over, you can start a new game.',
        'You can choose to start over with the same configuration',
        'as the game you just finished, that is: with you, the Wumpus,',
        'the pits, and the bats where they started in the game you',
        'just finished; or you can start fresh, with everything in',
        'new places (well, probably). In any case, you get a fresh',
        'supply of five arrows.',
        '',
        'Good luck!'
    );

    { The cave: 20 rooms, each connected to 3 others,
      as a dodecahedron. The connections are defined
      by this adjacency list. }
    cave : array [1..20, 1..3] of caveRoom = (
        ( 5,  8,  2), { ROOM  1 }
        ( 1, 10,  3), { ROOM  2 }
        ( 2, 12,  4), { ROOM  3 }
        ( 3, 14,  5), { ROOM  4 }
        ( 4,  6,  1), { ROOM  5 }
        (15,  5,  7), { ROOM  6 }
        ( 6, 17,  8), { ROOM  7 }
        ( 7,  1,  9), { ROOM  8 }
        ( 8, 18, 10), { ROOM  9 }
        ( 9,  2, 11), { ROOM 10 }
        (10, 19, 12), { ROOM 11 }
        (11,  3, 13), { ROOM 12 }
        (12, 20, 14), { ROOM 13 }
        (13,  4, 15), { ROOM 14 }
        (14, 16,  6), { ROOM 15 }
        (20, 15, 17), { ROOM 16 }
        (16,  7, 18), { ROOM 17 }
        (17,  9, 19), { ROOM 18 }
        (18, 11, 20), { ROOM 19 }
        (19, 13, 16)  { ROOM 20 }
    );
    rooms_in_order : array[1..20] of caveRoom =
        ( 1,  2,  3,  4,  5,  6,  7,  8,  9, 10,
         11, 12, 13, 14, 15, 16, 17, 18, 19, 20);

var
    initial_game_state : gameState;
    current_game_state : gameState;
    room_numbers : array [1..20] of caveRoom;
    arrow_path_length : integer;
    arrow_path : array [1..5] of integer;

{ The Cave }

{ Determine if a room number is in the cave }
function cave_room_number_valid (room_number : integer) : boolean;
    { room-number -- flag }
    begin
        cave_room_number_valid :=
            (0 < room_number) and (room_number <= 20)
    end;

{ Determine if a room is a neighbor }
function cave_room_reachable (toRoom: integer; fromRoom: integer) : boolean;
    { to from -- flag }
    var
        neighbor : integer;
    begin
        cave_room_reachable := false;
        if cave_room_number_valid(toRoom) and cave_room_number_valid(fromRoom) then
            for neighbor := 1 to 3 do
                if cave[fromRoom, neighbor] = toRoom then
                    begin
                        cave_room_reachable := true;
                        break
                    end
    end;

{ Does this room have the Hunter in it? }
function cave_room_has_hunter (room: integer) : boolean;
    { room-number -- flag }
    begin
        if cave_room_number_valid(room) then
            cave_room_has_hunter := room = current_game_state.hunter
        else
            cave_room_has_hunter := false
    end;

{ Does this room have the Wumpus in it? }
function cave_room_has_wumpus (room: integer) : boolean;
    { room-number -- flag }
    begin
        if cave_room_number_valid(room) then
            cave_room_has_wumpus := room = current_game_state.wumpus
        else
            cave_room_has_wumpus := false
    end;

{ Does this room have a bottomless pit in it? }
function cave_room_has_pit (room: integer) : boolean;
    { room-number -- flag }
    begin
        if cave_room_number_valid(room) then
            cave_room_has_pit :=
                (room = current_game_state.pits[1]) or
                (room = current_game_state.pits[2])
        else
            cave_room_has_pit := false
    end;

{ Does this room have super bats in it? }
function cave_room_has_bats (room: integer) : boolean;
    { room-number -- flag }
    begin
        if cave_room_number_valid(room) then
            cave_room_has_bats :=
                (room = current_game_state.bats[1]) or
                (room = current_game_state.bats[2])
        else
            cave_room_has_bats := false
    end;

{ Room number selection - for initial room assignments }

{ Fisher-Yates shuffle (a.k.a. the Knuth shuffle) on 20 room numbers. }
procedure shuffle_room_numbers ();
    { -- ; sets the list of shuffled room numbers }
    var
        lowIndex, highIndex, temp : caveRoom;
    begin
        room_numbers := rooms_in_order;
        for lowIndex := 1 to 19 do
            begin
                highIndex := lowIndex + random(21 - lowIndex);
                temp := room_numbers[lowIndex];
                room_numbers[lowIndex] := room_numbers[highIndex];
                room_numbers[highIndex] := temp
            end
    end;

{ Create a new starting state for the game,
  with random room assignments for
  the Hunter, Wumpus, pits, and bats;
  5 arrows; and the player IN_PLAY.
  The player can elect to return to this
  state when starting a new game. }
procedure create_new_initial_state ();
    { -- ; sets the initial game state }
    begin
        shuffle_room_numbers();
        with initial_game_state do
            begin
                hunter := room_numbers[1];
                wumpus := room_numbers[2];
                pits[1] := room_numbers[3];
                pits[2] := room_numbers[4];
                bats[1] := room_numbers[5];
                bats[2] := room_numbers[6];
                arrows := 5;
                player := IN_PLAY
            end
    end;

{ Player dialogue }

{ Accept a positive whole number from the player. }
function input_number () : integer;
    { -- number }
    const
        decimal_digits = ['1'..'9'];
    var
        response_valid : boolean = false;
        answer : string;
        number : integer;
        code : integer;
    begin
        repeat
            writeLn();
            write('> ');
            readLn(answer);
            if answer[1] in decimal_digits then
                { OK, starts as a positive decimal number,
                  and is not "0x..." hex }
                begin
                    { Free Pascal - convert string to number;
                      accepts hex, too (sigh). }
                    val(answer, number, code);
                    if (code = 0) and (number > 0) then
                        response_valid := true
                end;
            if not response_valid then
                write('That is not a valid number.')
        until response_valid;
        input_number := number
    end;

{ Accept the answer to a yes/no question from the player. }
function prompt_yes_no () : yesnoOption;
    { -- YES | NO }
    var
        response_valid : boolean;
        answer : string;
    begin
        repeat
            writeLn('(y/n)?');
            write('> ');
            readLn(answer);
            response_valid := true;
            case answer of
                'y', 'Y' : prompt_yes_no := YES;
                'n', 'N' : prompt_yes_no := NO
            otherwise
                response_valid := false;
                writeLn('Huh?')
            end
        until response_valid
    end;

{ Show the current game state, for debugging }
procedure show_game_state ();
    { -- ; prints the elements of the current game state }
    begin
        with current_game_state do
            begin
                writeLn('Hunter: ', hunter);
                writeLn('Wumpus: ', wumpus);
                writeLn('Pits  : ', pits[1], ' ', pits[2]);
                writeLn('Bats  : ', bats[1], ' ', bats[2]);
                writeLn('Arrows: ', arrows);
                writeLn('Player: ', player)
            end
    end;

{ Show the order in which room numbers will be assigned, for debugging }
procedure show_room_numbers ();
    { -- ; prints the shuffled room numbers }
    var
        roomIndex : caveRoom;
    begin
        for roomIndex := 1 to 20 do
            begin
                write(room_numbers[roomIndex]);
                if roomIndex = 20 then
                    writeLn()
                else
                    write(' ')
            end
    end;

{ Show a cave room's neighbors, appended to the current line }
procedure show_room_neighbors (room: caveRoom);
    { room-number -- ; prints a list of a room's neighbors }
    var
        neighbor: caveRoom;
    begin
        for neighbor := 1 to 3 do
            begin
                write(' ');
                write(cave[room, neighbor])
            end
    end;

{ Show a list of the cave rooms and each one's neighbors, for debugging }
procedure show_cave_rooms ();
    { -- ; prints a list of the cave rooms and neighbors }
    var
        room: caveRoom;
    begin
        for room := 1 to 20 do
            begin
                write(room);
                write(':');
                show_room_neighbors(room);
                writeLn()
            end
    end;

{ Show the stored crooked arrow path }
procedure show_arrow_path ();
    { -- ; prints the programmed arrow path }
    var
        pathIndex : pathRoom;
    begin
        write('Arrow path (', arrow_path_length, ') :');
        for pathIndex := 1 to arrow_path_length do
            write(' ', arrow_path[pathIndex]);
        writeLn()
    end;

{ Prompt for path length when shooting a crooked arrow }
procedure prompt_arrow_path_length();
    { -- 1..5 }
    begin
        arrow_path_length := 0;
        repeat
            write('How many rooms should the arrow traverse (1..5)?');
            arrow_path_length := input_number();
            if not ((0 < arrow_path_length) and (arrow_path_length <= 5)) then
                writeLn('Huh?')
        until (0 < arrow_path_length) and (arrow_path_length <= 5)
    end;

{ Get room number arrow can't go back to ... zero if any room OK. }
function arrow_path_backtrack_room (pathIndex : pathRoom) : integer;
    { index -- invalid-room }
    begin
        { The arrow is not so crooked that it
          can go out the tunnel it came in through. }
        if pathIndex > 2 then
            { The path has more than one room already;
              the arrow can't go back to the room
              before the last one entered. }
            arrow_path_backtrack_room := arrow_path[pathIndex - 2]
        else
            if pathIndex = 2 then
                { The path has exactly one room so far; the arrow
                  can't go back to the room the Hunter is in. }
                arrow_path_backtrack_room := current_game_state.hunter
            else
                { This is to be the first room in the path;
                  the arrow can be sent anywhere,
                  including the room the Hunter is in.
                  Zero won't match any room. }
                arrow_path_backtrack_room := 0
    end;

{ Prompt for the next room in the arrow's path }
function prompt_arrow_path_room (pathIndex : pathRoom) : integer;
    { index -- room }
    var
        room : integer;
        room_valid : boolean = false;
    begin
        repeat
            write('Enter room ', pathIndex);
            room := input_number(); { ... might not be in cave }
            if room = arrow_path_backtrack_room(pathIndex) then
                writeLn('Huh, arrows aren''t that crooked!')
            else
                room_valid := true
        until room_valid;
        prompt_arrow_path_room := room
    end;

{ Prompt for the arrow's path when shooting a crooked arrow }
procedure prompt_arrow_path ();
    { -- ; sets arrow path length and rooms }
    var
        pathIndex : pathRoom;
    begin
        prompt_arrow_path_length();
        for pathIndex := 1 to arrow_path_length do
          arrow_path[pathIndex] := prompt_arrow_path_room(pathIndex)
    end;

{ List any hazards in a room, Wumpus, pits, bats }
procedure warn_of_hazards (room: caveRoom);
    { room-number -- ; prints the hazards in this room }
    begin
        if cave_room_has_wumpus(room) then
            writeLn('I smell a Wumpus!');
        if cave_room_has_pit(room) then
            writeLn('I feel a draft!');
        if cave_room_has_bats(room) then
            writeLn('I hear a rustling sound!')
    end;

{ Warn of any hazards in the neighboring rooms }
procedure hazards_nearby (room: caveRoom);
    { room-number -- ; prints the hazards in each neighboring room }
    var
        neighbor: caveRoom;
    begin
        for neighbor := 1 to 3 do
            warn_of_hazards(cave[room, neighbor])
    end;

{ Describe the Hunter's location: room number, neighbors, hazards }
procedure describe_hunter_location ();
    { -- ; prints a description of the Hunter's location }
    begin
        with current_game_state do
            begin
                writeLn('You are in room ', hunter);
                write('Tunnels lead to rooms:');
                show_room_neighbors(hunter);
                writeLn();
                hazards_nearby(hunter);
            end
    end;

{ Get a room number for the Hunter to move to }
function prompt_new_hunter_room () : caveRoom;
    { -- room }
    var
        room : integer;
        room_valid : boolean = false;
    begin
        repeat
            write('Where do you want to go?');
            room := input_number(); { ... might not be in cave }
            if cave_room_reachable(room, current_game_state.hunter) then
                { OK, in cave and reachable }
                room_valid := true
            else
                if cave_room_has_hunter(room) then
                    writeLn('You are already in room ', room)
                else
                    writeLn('Can''t get there from here.')
        until room_valid;
        prompt_new_hunter_room := room
    end;

{ Prompt for a command }
function prompt_command () : playOption;
    { -- MOVE_ME | SHOOT | WHERE_AM_I | GAME_STATE | CAVE_ROOMS | SHUFFLED_ROOMS }
    var
        response_valid : boolean = false;
        answer : string;
    begin
        repeat
            write('What do you want to do ');
            writeLn('(m=move, s=shoot, w=where am I?)?');
            write('> ');
            readLn(answer);
            response_valid := true;
            case answer of
                'm', 'M' : prompt_command := MOVE_ME;
                's', 'S' : prompt_command := SHOOT;
                'w', 'W' : prompt_command := WHERE_AM_I;
                { - undocumented, for debugging - }
                'g', 'G' : prompt_command := GAME_STATE;
                'c', 'C' : prompt_command := CAVE_ROOMS;
                'r', 'R' : prompt_command := SHUFFLED_ROOMS
            otherwise
                response_valid := false;
                writeLn('Huh?')
            end
        until response_valid
    end;

{ Prompt to play again, with same or new room assignments }
function prompt_play_again () : gameOption;
    { -- QUIT_GAME | SAME_ROOMS | NEW_ROOMS }
    begin
        write('Play again ');
        if prompt_yes_no() = YES then
            begin
                writeLn('OK, play again ...');
                write('Same rooms ');
                if prompt_yes_no() = YES then
                    begin
                        writeLn('OK, you, the Wumpus, pits, and bats in the same rooms.');
                        prompt_play_again := SAME_ROOMS
                    end
                else
                    begin
                        writeLn('OK, you, the Wumpus, pits, and bats in new rooms (probably).');
                        prompt_play_again := NEW_ROOMS
                    end
            end
        else
            begin
                writeLn('Bye');
                prompt_play_again := QUIT_GAME
            end
    end;

{ Show congratulations or condolences }
procedure show_results ( finalPlayerState : playerState );
    { WON | LOST -- ; prints congratulations or condolences message }
    begin
        if finalPlayerState = WON then
            writeLn('Congratulations! You got the Wumpus! But next time, hee, hee, hee!')
        else
            if finalPlayerState = LOST then
                writeLn('Condolences, maybe better luck next time.')
            else
                writeLn(ord(finalPlayerState), ' unknown game result.')
    end;

{ Show the instructions to the player }
procedure show_instructions ();
    { -- ; prints the instructions }
    var
        lineIndex : integer;
    begin
        writeLn();
        for lineIndex := 1 to length(instructions) do
            writeLn(instructions[lineIndex])
    end;

{ Show the instructions if wanted }
procedure show_instructions_if_wanted ();
    { -- ; prompt if instructions wanted, print if yes }
    var
        wanted : yesnoOption;
    begin
        write('Show instructions ');
        wanted := prompt_yes_no();
        if wanted = YES then
            show_instructions()
    end;

{ Show a greeting to the player }
procedure show_greeting ();
    begin
        writeLn('----  ----  Hunt the Wumpus  ----  ----');
        writeLn('- ', wumpus_version);
        writeLn('----  ----  ---------------  ----  ----')
    end;

{ Game Play }

{ The Wumpus eats the Hunter if in the same room }
procedure did_wumpus_eat_hunter ();
    { -- ; may set player state to LOST }
    begin
        if cave_room_has_wumpus(current_game_state.hunter) then
            begin
                writeLn('Aaaaggghhh! The Wumpus got you! You lose!');
                current_game_state.player := LOST
            end
        else
            writeLn('Phew! The Wumpus didn''t get you.')
    end;

{ Move the Wumpus - did it get the Hunter? }
procedure move_wumpus ();
    { -- ; may set player state to LOST }
    var
        room : caveRoom;
        choice : 0..3;
    begin
        writeLn('Uh oh! You disturbed the Wumpus!');
        choice := random(4);
        if (choice > 0) then
            begin
                room := cave[current_game_state.wumpus, choice];
                current_game_state.wumpus := room
            end;
        did_wumpus_eat_hunter() { may set player state to LOST }
    end;

{ Did the crooked arrow hit the Wumpus? }
function did_arrow_hit_wumpus (room : caveRoom) : boolean;
    { room -- flag ; may set player state to WON }
    begin
        if cave_room_has_wumpus(room) then
            begin
                writeLn();
                writeLn('Aha! You got the Wumpus!');
                current_game_state.player := WON;
                did_arrow_hit_wumpus := true
            end
        else
            did_arrow_hit_wumpus := false
    end;

{ Did the crooked arrow hit the Hunter? }
function did_arrow_hit_hunter (room : caveRoom) : boolean;
    { room -- flag ; may set player state to LOST }
    begin
        if cave_room_has_hunter(room) then
            begin
                writeLn();
                writeLn('Ouch! Arrow got you! You lose!');
                current_game_state.player := LOST;
                did_arrow_hit_hunter := true
            end
        else
            did_arrow_hit_hunter := false
    end;

{ Did the Hunter run out of crooked arrows? }
procedure are_arrows_all_gone ();
    { -- ; may set player state to LOST }
    begin
        with current_game_state do
            if (arrows = 0) then
                begin
                    writeLn('You''re out of arrows, you lose!');
                    player := LOST
                end
    end;

{ Fly a crooked arrow }
procedure fly_arrow ();
    { -- ; may set player state to WON or LOST }
    var
        arrow : caveRoom;
        next : integer;
        roomIndex : 1..5;
        choice : 1..3;
    begin
        with current_game_state do
            begin
                { Hunter pulls an arrow from the quiver }
                arrows := arrows - 1;
                { Arrow starts where player is }
                arrow := hunter;
                write(arrow);
                for roomIndex := 1 to arrow_path_length do
                    begin
                        write(' --> ');
                        next := arrow_path[roomIndex]; { ... might not be in cave }
                        if cave_room_reachable(next, arrow) then
                            { Arrow now in next room in path }
                            arrow := next
                        else
                            begin
                                writeLn();
                                writeLn('Uh oh! You hit the cave wall, arrow gone astray!');
                                write(' --> ');
                                { Arrow enters one of the adjoining rooms }
                                choice := 1 + random(3);
                                arrow := cave[arrow, choice]
                            end;
                        write(arrow);
                        { OK, what happens when the arrow reaches this room? }
                        if did_arrow_hit_hunter(arrow) or did_arrow_hit_wumpus(arrow) then
                            break { That's the end of the arrow's flight }
                        else
                            if roomIndex = arrow_path_length then
                                writeLn() { That's the end of the arrow's flight }
                    end
            end
    end;

{ Shoot a crooked arrow }
procedure shoot_arrow ();
    {  -- ; may set player state to WON or LOST }
    begin
        prompt_arrow_path();
        show_arrow_path();
        fly_arrow(); { may set player state to WON or LOST }
        if current_game_state.player = IN_PLAY then
            begin
                { The arrow didn't hit anything }
                writeLn('You missed!');
                { Shooting an arrow always disturbs the Wumpus ... }
                move_wumpus(); { may set player state to LOST }
                { ... and uses up an arrow }
                are_arrows_all_gone() { may set player state to LOST }
            end
    end;

{ Hunter went into a room with super bats? }
function did_hunter_enter_room_with_bats () : boolean;
    { -- flag ; return TRUE if a super bat moved the Hunter }
    begin
        with current_game_state do
            if cave_room_has_bats(hunter) then
                begin
                    writeLn('Oh oh oh! A bat''s got you! Oh ohhh ...');
                    hunter := 1 + random(20);
                    writeLn('... the bat dropped you in room ', hunter);
                    did_hunter_enter_room_with_bats := true
                end
            else
                did_hunter_enter_room_with_bats := false
    end;

{ Hunter went into a room with a bottomless pit? }
procedure did_hunter_enter_room_with_pit ();
    { -- ; may set player state to LOST }
    begin
        if cave_room_has_pit(current_game_state.hunter) then
            begin
                writeLn('Aaaaggghhh! You fell in a pit! You lose!');
                current_game_state.player := LOST
            end
    end;

{ Hunter went into a room with the Wumpus? }
procedure did_hunter_enter_room_with_wumpus ();
    { -- ; may set player state to LOST }
    begin
        if cave_room_has_wumpus(current_game_state.hunter) then
            move_wumpus() { may set player state to LOST }
    end;

{ Move the Hunter to a new room }
procedure move_hunter ();
    { -- ; may set player state to LOST }
    var
        bats_moved_hunter : boolean;
    begin
        with current_game_state do
            begin
                hunter := prompt_new_hunter_room();
                repeat { repeat if the bats moved the Hunter }
                    bats_moved_hunter := false;
                    did_hunter_enter_room_with_wumpus();
                    { The player may have LOST,
                      if the Hunter entered the room with the Wumpus }
                    if player = IN_PLAY then
                        { NOPE, the Wumpus did not eat the Hunter ... }
                        begin
                            did_hunter_enter_room_with_pit();
                            { The player will have LOST,
                              if the Hunter entered a room with a pit }
                            if player = IN_PLAY then
                                { NOPE, the Hunter did not fall in a bottomless pit ... }
                                bats_moved_hunter := did_hunter_enter_room_with_bats()
                                { A bat will have moved the Hunter,
                                  if it entered a room with bats,
                                  with possibly dire consequences }
                        end
                until not bats_moved_hunter;
                if player = IN_PLAY then
                    { Nothing too bad happened, let's take a moment
                      to take in our surroundings ... }
                    describe_hunter_location()
            end
    end;

{ Play the game until won or lost }
function play() : playerState;
    { -- WON | LOST }
    var
        command : playOption;
    begin
        repeat
            command := prompt_command();
            case command of
                MOVE_ME         : move_hunter();
                SHOOT           : shoot_arrow();
                WHERE_AM_I      : describe_hunter_location();
                { - undocumented, for debugging - }
                GAME_STATE      : show_game_state();
                CAVE_ROOMS      : show_cave_rooms();
                SHUFFLED_ROOMS  : show_room_numbers()
            end
        until not (current_game_state.player = IN_PLAY);
        play := current_game_state.player
    end;

{ Reset the state for a new game, with or without new room assignments }
procedure new_game (option : gameOption);
    { SAME-ROOMS | NEW-ROOMS -- ; sets the current game state }
    begin
        if (option = NEW_ROOMS) then
            create_new_initial_state();
        current_game_state := initial_game_state
    end;

{ Greet the player, play, then prompt for a new game }
procedure Hunt_the_Wumpus();
    var
        new_game_option : gameOption;
        game_result : playerState;
    begin
        show_greeting();
        show_instructions_if_wanted();
        new_game_option := NEW_ROOMS;
        repeat
            new_game(new_game_option);
            describe_hunter_location();
            game_result := play();
            show_results(game_result);
            new_game_option := prompt_play_again()
        until new_game_option = QUIT_GAME
    end;

begin
    randomize();    { Free Pascal - initialize RNG from clock }
    Hunt_the_Wumpus()
end.
