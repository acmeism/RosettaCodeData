function [doors,opened,closed] = hundredDoors()

    %Initialize the doors, make them booleans for easy vectorization
    doors = logical( (1:1:100) );

    %Go through the flipping process, ignore the 1 case because the doors
    %array is already initialized to all open
    for initialPosition = (2:100)
        doors(initialPosition:initialPosition:100) = not( doors(initialPosition:initialPosition:100) );
    end

    opened = find(doors); %Stores the numbers of the open doors
    closed = find( not(doors) ); %Stores the numbers of the closed doors

end
