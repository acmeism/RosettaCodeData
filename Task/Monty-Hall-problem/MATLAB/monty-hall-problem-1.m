function montyHall(numDoors,numSimulations)

    assert(numDoors > 2);

    function num = randInt(n)
        num = floor( n*rand()+1 );
    end

    %The first column will tallie wins, the second losses
    switchedDoors = [0 0];
    stayed = [0 0];


    for i = (1:numSimulations)

        availableDoors = (1:numDoors); %Preallocate the available doors
        winningDoor = randInt(numDoors); %Define the winning door
        playersOriginalChoice = randInt(numDoors); %The player picks his initial choice

        availableDoors(playersOriginalChoice) = []; %Remove the players choice from the available doors

        %Pick the door to open from the available doors
        openDoor = availableDoors(randperm(numel(availableDoors))); %Sort the available doors randomly
        openDoor(openDoor == winningDoor) = []; %Make sure Monty doesn't open the winning door
        openDoor = openDoor(randInt(numel(openDoor))); %Choose a random door to open

        availableDoors(availableDoors==openDoor) = []; %Remove the open door from the available doors
        availableDoors(end+1) = playersOriginalChoice; %Put the player's original choice back into the pool of available doors
        availableDoors = sort(availableDoors);

        playersNewChoice = availableDoors(randInt(numel(availableDoors))); %Pick one of the available doors

        if playersNewChoice == playersOriginalChoice
            switch playersNewChoice == winningDoor
                case true
                    stayed(1) = stayed(1) + 1;
                case false
                    stayed(2) = stayed(2) + 1;
                otherwise
                    error 'ERROR'
            end
        else
            switch playersNewChoice == winningDoor
                case true
                    switchedDoors(1) = switchedDoors(1) + 1;
                case false
                    switchedDoors(2) = switchedDoors(2) + 1;
                otherwise
                    error 'ERROR'
            end
        end
    end

    disp(sprintf('Switch win percentage: %f%%\nStay win percentage: %f%%\n', [switchedDoors(1)/sum(switchedDoors),stayed(1)/sum(stayed)] * 100));

end
