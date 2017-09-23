begin
    string(20) state;
    string(20) nextState;
    integer    generation;
    generation := 0;
    state := "_###_##_#_#_#_#__#__";
    while begin
        write( i_w := 1, s_w := 1, "Generation ", generation, state );
        nextState := "____________________";
        for cPos := 1 until 18 do begin
            string(3) curr;
            curr := state( cPos - 1 // 3 );
            nextState( cPos // 1 ) := if curr = "_##" or curr = "#_#" or curr = "##_" then "#" else "_"
        end for_cPos ;
        ( state not = nextState )
    end do begin
        state := nextState;
        generation := generation + 1
    end while_not_finished
end.
