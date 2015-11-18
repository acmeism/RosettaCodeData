begin

    string(10) board;

    % initialise the board                                                   %
    procedure initBoard ; board := " 123456789";

    % display the board                                                      %
    procedure showBoard ;
        begin
            s_w := 0;
            write( board(1//1), "|", board(2//1), "|", board(3//1) );
            write( "-+-+-" );
            write( board(4//1), "|", board(5//1), "|", board(6//1) );
            write( "-+-+-" );
            write( board(7//1), "|", board(8//1), "|", board(9//1) )
        end showBoard ;

    % returns true if board pos is free, false otherwise                     %
    logical procedure freeSpace( integer value pos ) ;
        ( board(pos//1) >= "1" and board(pos//1) <= "9" );

    % check for game over                                                    %
    logical procedure gameOver ;
        begin
            logical noMoves;
            noMoves := true;
            for i := 1 until 9 do if noMoves then noMoves := not freeSpace( i );
            noMoves
        end gameOver ;

    % makes the specified winning move or blocks it, if it will win          %
    logical procedure winOrBlock( integer   value pos1, pos2, pos3
                                ; string(1) value searchCharacter
                                ; string(1) value playerCharacter
                                ) ;
        if      board(pos1//1) = searchCharacter
            and board(pos2//1) = searchCharacter
            and freeSpace( pos3 )
        then begin
            board(pos3//1) := playerCharacter;
            true
            end
        else if board(pos1//1) = searchCharacter
            and freeSpace( pos2 )
            and board(pos3//1) = searchCharacter
        then begin
            board(pos2//1) := playerCharacter;
            true
            end
        else if freeSpace( pos1 )
            and board(pos2//1) = searchCharacter
            and board(pos3//1) = searchCharacter
        then begin
            board(pos1//1) := playerCharacter;
            true
            end
        else begin
            false
        end winOrBlock ;

    % makes a winning move or blocks a winning move, if there is one         %
    logical procedure makeOrBlockWinningMove( string(1) value searchCharacter
                                            ; string(1) value playerCharacter
                                            ) ;
        (  winOrBlock( 1, 2, 3, searchCharacter, playerCharacter )
        or winOrBlock( 4, 5, 6, searchCharacter, playerCharacter )
        or winOrBlock( 7, 8, 9, searchCharacter, playerCharacter )
        or winOrBlock( 1, 4, 7, searchCharacter, playerCharacter )
        or winOrBlock( 2, 5, 8, searchCharacter, playerCharacter )
        or winOrBlock( 3, 6, 9, searchCharacter, playerCharacter )
        or winOrBlock( 1, 5, 9, searchCharacter, playerCharacter )
        or winOrBlock( 3, 5, 7, searchCharacter, playerCharacter )
        ) ;

    % makes a move when there isn't an obvious winning/blocking move         %
    procedure move ( string(1) value playerCharacter ) ;
        begin
            logical moved;
            moved := false;
            % try for the centre, a corner or the midle of a line            %
            for pos := 5, 1, 3, 7, 9, 2, 4, 6, 8 do begin
                if not moved and freeSpace( pos ) then begin
                    moved := true;
                    board(pos//1) := playerCharacter
                end
            end
        end move ;

    % gets a move from the user                                              %
    procedure userMove( string(1) value playerCharacter ) ;
        begin
            integer move;
            while
                begin
                    write( "Please enter the move for ", playerCharacter, " " );
                    read( move );
                    ( move < 1 or move > 9 or not freeSpace( move ) )
                end
            do  begin
                write( "Invalid move" )
            end;
            board(move//1) := playerCharacter
        end userMove ;

    % returns true if the three board positions have the player character,   %
    %         false otherwise                                                %
    logical procedure same( integer   value pos1, pos2, pos3
                          ; string(1) value playerCharacter
                          ) ;
        (   board(pos1//1) = playerCharacter
        and board(pos2//1) = playerCharacter
        and board(pos3//1) = playerCharacter
        );

    % returns true if the player has made a winning move, false otherwise    %
    logical procedure playerHasWon( string(1) value playerCharacter ) ;
        (  same( 1, 2, 3, playerCharacter )
        or same( 4, 5, 6, playerCharacter )
        or same( 7, 8, 9, playerCharacter )
        or same( 1, 4, 7, playerCharacter )
        or same( 2, 5, 8, playerCharacter )
        or same( 3, 6, 9, playerCharacter )
        or same( 1, 5, 9, playerCharacter )
        or same( 3, 5, 7, playerCharacter )
        ) ;

    % takes a players turn - either automated or user input                  %
    procedure turn ( string(1) value playerCharacter, otherCharacter
                   ; logical   value playerIsUser
                   ) ;
        begin
            if playerIsUser then userMove( playerCharacter )
            else begin
                write( playerCharacter, " moves..." );
                if  not makeOrBlockWinningMove( playerCharacter, playerCharacter )
                and not makeOrBlockWinningMove( otherCharacter,  playerCharacter )
                then move( playerCharacter )
            end;
            showBoard
        end turn ;

    % asks a question and returns true if the user inputs y/Y,               %
    % false otherwise                                                        %
    logical procedure yes( string(32) value question ) ;
        begin
            string(1) answer;
            write( question );
            read( answer );
            answer = "y" or answer = "Y"
        end yes ;

    % play the game                                                          %
    while
        begin
            string(1)  again;
            string(32) gameResult;
            logical    oIsUser, xIsUser;

            oIsUser := yes( "Do you want to play O? " );
            xIsUser := yes( "Do you want to play X? " );

            gameResult := "it's a draw";
            initBoard;
            showBoard;
            while not gameOver and not playerHasWon( "O" ) and not playerHasWon( "X" ) do begin
                turn( "O", "X", oIsUser );
                if playerHasWon( "O" ) then gameResult := "O wins"
                else if not gameOver then begin
                    turn( "X", "O", xIsUser );
                    if playerHasWon( "X" ) then gameResult := "X wins"
                end
            end ;
            write( gameResult );

            yes( "Play again? " )
        end
    do  begin end

end.
