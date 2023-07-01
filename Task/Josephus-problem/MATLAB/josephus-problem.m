function [indAlive] = josephus(numPeople,count)
% Josephus: Given a circle of numPeople individuals, with a count of count,
% find the index (starting at 1) of the survivor [see Josephus Problem]

%% Definitions:
%   0 = dead position
%   1 = alive position
%   index = # of person

%% Setting up
arrPeople = ones(1, numPeople);
currInd = 0;

%% Counting
while (length(arrPeople(arrPeople == 1)) > 1)     % While more than 1 person is alive
    counter = 0;
    while counter ~= count                       % Counting until we hit the count
        currInd = currInd + 1;                  % Move to the next person

        if currInd > numPeople                  % If overflow, wraparound
            currInd = currInd - numPeople;
        end

        if arrPeople(currInd)                   % If the current person is alive
            counter = counter + 1;                % Add 1 person to the count
            %fprintf("Index: %d \t| Counter: %d\n", currInd, counter)           % Uncomment to display index and counter location
        end

    end

    arrPeople(currInd) = 0;                     % Kill the person we reached
    %fprintf("Killed person %d \n", currInd)                                   % Uncomment to display order of killing
    %disp(arrPeople)                                                           % Uncomment to display current status of people
end

indAlive = find(arrPeople);

end
