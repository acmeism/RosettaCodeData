function solution = sudokuSolver(sudokuGrid)

    %Define what each of the sub-boxes of the sudoku grid are by defining
    %the start and end coordinates of each sub-box. The indecies represent
    %the column and row of a grid coordinate on the actual sudoku grid.
    %The contents of each cell with the same grid coordinates contain the
    %information to determine which sub-box that grid coordinate is
    %contained in on the sudoku grid. The array in position 1, i.e.
    %subBoxes{row,column}(1), represents the row indecies of the subbox.
    %The array in position 2, i.e. subBoxes{row,column}(2),represents the
    %column indecies of the subbox.

    subBoxes(1:9,1:9) = {{(1:3),(1:3)}};
    subBoxes(4:6,:)= {{(4:6),(1:3)}};
    subBoxes(7:9,:)= {{(7:9),(1:3)}};

    for column = (4:6)
        for row = (1:9)
            subBoxes{row,column}(2)= {4:6};
        end
    end
    for column = (7:9)
        for row = (1:9)
            subBoxes{row,column}(2)= {7:9};
        end
    end

    %Generate a cell of arrays which contain the possible values of the
    %sudoku grid for each cell in the grid. The possible values a specific
    %grid coordinate can take share the same indices as the sudoku grid
    %coordinate they represent.
    %For example sudokuGrid(m,n) can be possibly filled in by the
    %values stored in the array at possibleValues(m,n).
    possibleValues(1:9,1:9) = { (1:9) };

    %Filter the possibleValues so that no entry exists for coordinates that
    %have already been filled in. This will replace any array with an empty
    %array in the possibleValues cell matrix at the coordinates of a grid
    %already filled in the sudoku grid.
    possibleValues( ~isnan(sudokuGrid) )={[]};

    %Iterate through each grid coordinate and filter out the possible
    %values for that grid point that aren't alowed by the rules given the
    %current values that are filled in. Or, if there is only one possible
    %value for the current coordinate, fill it in.

    solution = sudokuGrid; %so the original sudoku input isn't modified
    memory = 0; %contains the previous iterations possibleValues
    dontStop = true; %stops the while loop when nothing else can be reasoned about the sudoku

    while( dontStop )

%% Process of elimination deduction method

        while( ~isequal(possibleValues,memory) ) %Stops using the process of elimination deduction method when this deduction rule stops working

            memory = possibleValues; %Copies the current possibleValues into memory, for the above conditional on the next iteration.

            %Iterate through everything
            for row = (1:9)
                for column = (1:9)

                    if isnan( solution(row,column) ) %If grid coordinate hasn't been filled in, try to determine it's value.

                        %Look at column to see what values have already
                        %been filled in and thus the current grid
                        %coordinate can't be
                        removableValues = solution( ~isnan(solution(:,column)),column );

                        %If there are any values that have been assigned to
                        %other cells in the same column, filter those out
                        %of the current cell's possiblValues
                        if ~isempty(removableValues)
                            for m = ( 1:numel(removableValues) )
                                possibleValues{row,column}( possibleValues{row,column}==removableValues(m) )=[];
                            end
                        end

                        %If the current grid coordinate can only atain one
                        %possible value, assign it that value
                        if numel( possibleValues{row,column} ) == 1
                            solution(row,column) = possibleValues{row,column};
                            possibleValues(row,column)={[]};
                        end
                    end  %end if

                    if isnan( solution(row,column) ) %If grid coordinate hasn't been filled in, try to determine it's value.

                        %Look at row to see what values have already
                        %been filled in and thus the current grid
                        %coordinate can't be
                        removableValues = solution( row,~isnan(solution(row,:)) );

                        %If there are any values that have been assigned to
                        %other cells in the same row, filter those out
                        %of the current cell's possiblValues
                        if ~isempty(removableValues)
                            for m = ( 1:numel(removableValues) )
                                possibleValues{row,column}( possibleValues{row,column}==removableValues(m) )=[];
                            end
                        end

                        %If the current grid coordinate can only atain one
                        %possible value, assign it that value
                        if numel( possibleValues{row,column} ) == 1
                            solution(row,column) = possibleValues{row,column};
                            possibleValues(row,column)={[]};
                        end
                    end %end if

                    if isnan( solution(row,column) ) %If grid coordinate hasn't been filled in, try to determine it's value.

                        %Look at sub-box to see if any possible values can be
                        %filtered out. First pull the boundaries of the sub-box
                        %containing the current array coordinate
                        currentBoxBoundaries=subBoxes{row,column};

                        %Then pull the sub-boxes values out of the solution
                        box = solution(currentBoxBoundaries{:});

                        %Look at sub-box to see what values have already
                        %been filled in and thus the current grid
                        %coordinate can't be
                        removableValues = box( ~isnan(box) );

                        %If there are any values that have been assigned to
                        %other cells in the same sub-box, filter those out
                        %of the current cell's possiblValues
                        if ~isempty(removableValues)
                            for m = ( 1:numel(removableValues) )
                                possibleValues{row,column}( possibleValues{row,column}==removableValues(m) )=[];
                            end
                        end

                        %If the current grid coordinate can only atain one
                        %possible value, assign it that value
                        if numel( possibleValues{row,column} ) == 1
                            solution(row,column) = possibleValues{row,column};
                            possibleValues(row,column)={[]};
                        end
                    end %end if

                end %end for column
            end %end for row
        end %stop process of elimination

%% Check that there are no contradictions in the solved grid coordinates.

        %Check that each row at most contains one of each of the integers
        %from 1 to 9
        if ~isempty( find( histc( solution,(1:9),1 )>1 ) )
            solution = false;
            return
        end

        %Check that each column at most contains one of each of the integers
        %from 1 to 9
        if ~isempty( find( histc( solution,(1:9),2 )>1 ) )
            solution = false;
            return
        end

        %Check that each sub-box at most contains one of each of the integers
        %from 1 to 9
        subBoxBins = zeros(9,9);
        counter = 0;
        for row = [2 5 8]
            for column = [2 5 8]
                counter = counter +1;

                %because the sub-boxes are extracted as square matricies,
                %we need to reshape them into row vectors so all of the
                %boxes can be input into histc simultaneously
                subBoxBins(counter,:) = reshape( solution(subBoxes{row,column}{:}),1,9 );
            end
        end
        if ~isempty( find( histc( subBoxBins,(1:9),2 )>1 ) )
            solution = false;
            return
        end

        %Check to make sure there are no grid coordinates that are not
        %filled in and have no possible values.

        [rowStack,columnStack] = find(isnan(solution)); %extracts the indicies of the unsolved grid coordinates
        if (numel(rowStack) > 0)

            for counter = (1:numel(rowStack))
                if isempty(possibleValues{rowStack(counter),columnStack(counter)})
                    solution = false;
                    return
                end
            end

        %if there are no more grid coordinates to be filed in then the
        %sudoku is solved and we can return the solution without further
        %computation
        elseif (numel(rowStack) == 0)
            return
        end

%% Use the unique relative compliment of sets deduction method

        %Because no more information can be determined by the process of
        %ellimination we have to try a new method of reasoning. Now we will
        %look at the possible values a cell can take. If there is a value that
        %that grid coordinate can take but no other coordinates in the same row,
        %column or sub-box can take that value then we assign that coordinate
        %that value.

        keepGoing = true; %signals to keep applying rules to the current grid-coordinate because it hasn't been solved using previous rules
        dontStop = false; %if this method doesn't figure anything out, this will terminate the top level while loop

        [rowStack,columnStack] = find(isnan(solution)); %This will also take care of the case where the sudoku is solved
        counter = 0; %makes sure the loop terminates when there are no more cells to consider

        while( keepGoing && (counter < numel(rowStack)) ) %stop this method of reasoning when the value of one of the cells has been determined and return to the process of elimination method

            counter = counter + 1;

            row = rowStack(counter);
            column = columnStack(counter);

            gridPossibles = [possibleValues{row,column}];

            coords = (1:9);
            coords(column) = [];
            rowPossibles = [possibleValues{row,coords}]; %extract possible values for everything in the same row except the current grid coordinate

            totalMatches = zeros( numel(gridPossibles),1 ); %preallocate for speed

            %count how many times a possible value for the current cell
            %appears as a possible value for the cells in the same row
            for n = ( 1:numel(gridPossibles) )
                totalMatches(n) = sum( (rowPossibles == gridPossibles(n)) );
            end

            %remove any possible values for the current cell that have
            %matches in other cells
            gridPossibles = gridPossibles(totalMatches==0);

            %if there is only one possible value that the current cell can
            %take that aren't shared by other cells, assign that value to
            %the current cell.
            if numel(gridPossibles) == 1

                solution(row,column) = gridPossibles;
                possibleValues(row,column)={[]};
                keepGoing = false; %stop this method of deduction and return to the process of elimination
                dontStop = true; %keep the top level loop going

            end

            if(keepGoing) %do the same as above but for the current cell's column

                gridPossibles = [possibleValues{row,column}];

                coords = (1:9);
                coords(row) = [];
                columnPossibles = [possibleValues{coords,column}];

                totalMatches = zeros( numel(gridPossibles),1 );
                for n = ( 1:numel(gridPossibles) )
                    totalMatches(n) = sum( (columnPossibles == gridPossibles(n)) );
                end

                gridPossibles = gridPossibles(totalMatches==0);

                if numel(gridPossibles) == 1

                    solution(row,column) = gridPossibles;
                    possibleValues(row,column)={[]};
                    keepGoing = false;
                    dontStop = true;

                end
            end

            if(keepGoing) %do the same as above but for the current cell's sub-box

                gridPossibles = [possibleValues{row,column}];

                currentBoxBoundaries = subBoxes{row,column};
                subBoxPossibles = [];
                for m = currentBoxBoundaries{1}
                    for n = currentBoxBoundaries{2}
                        if ~((m == row) && (n == column))
                            subBoxPossibles = [subBoxPossibles possibleValues{m,n}];
                        end
                    end
                end

                totalMatches = zeros( numel(gridPossibles),1 );
                for n = ( 1:numel(gridPossibles) )
                    totalMatches(n) = sum( (subBoxPossibles == gridPossibles(n)) );
                end

                gridPossibles = gridPossibles(totalMatches==0);

                if numel(gridPossibles) == 1

                    solution(row,column) = gridPossibles;
                    possibleValues(row,column)={[]};
                    keepGoing = false;
                    dontStop = true;

                end
            end %end

        end %end  set comliment rule while loop
    end %end top-level while loop

%% Depth-first search of the solution tree

    %There is no more reasoning that can solve the puzzle so now it is time
    %for a depth-first search of the possible answers, basically
    %guess-and-check. This is implimented recursively.

    [rowStack,columnStack] = find(isnan(solution)); %Get all of the unsolved cells

    if (numel(rowStack) > 0) %If all of the above stuff terminates then there will be at least one grid coordinate not filled in

        %Treat the rowStack and columnStack like stacks, and pop the top
        %value off the stack to act as the current node whose
        %possibleValues to search through, then assign the possible values
        %of that grid coordinate to a variable that holds that values to
        %search through
        searchTreeNodes = possibleValues{rowStack(1),columnStack(1)};

        keepSearching = true; %used to continue the search
        counter = 0; %counts the amount of possible values searched for the current node
        tempSolution = solution; %used so that the solution is not overriden until a solution hase been found

        while( keepSearching && (counter < numel(searchTreeNodes)) ) %stop recursing if we run out of possible values for the current node

            counter = counter + 1;
            tempSolution(rowStack(1),columnStack(1)) = searchTreeNodes(counter); %assign a possible value to the current node in the tree
            tempSolution = sudokuSolver(tempSolution); %recursively call the solver with the current guess value for the current grid coordinate

            if ~islogical(tempSolution) %if tempSolution is not a boolean but a valid sudoku stop recursing and set solution to tempSolution
               keepSearching = false;
               solution = tempSolution;
            elseif counter == numel(searchTreeNodes) %if we have run out of guesses for the current node, stop recursing and return a value of "false" for the solution
               solution = false;
            else %reset tempSolution to the current state of the board and try the next guess for the possible value of the current cell
               tempSolution = solution;
            end

        end %end recursion
    end  %end if

%% End of program
end %end sudokuSolver
