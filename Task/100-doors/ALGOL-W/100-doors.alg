begin
    % -- find the first few squares via the unoptimised door flipping method   %

    integer doorMax;
    doorMax := 100;

    begin
        % -- need to start a new block so the array can have variable bounds   %

        % -- array of doors - door( i ) is true if open, false if closed       %
        logical array door( 1 :: doorMax );

        % -- set all doors to closed                                           %
        for i := 1 until doorMax do door( i ) := false;

        % -- repeatedly flip the doors                                         %
        for i := 1 until doorMax
        do begin
            for j := i step i until doorMax
            do begin
                door( j ) := not door( j )
            end
        end;

        % -- display the results                                               %
        i_w := 1; % -- set integer field width                                 %
        s_w := 1; % -- and separator width                                     %
        for i := 1 until doorMax do if door( i ) then writeon( i )

    end

end.
