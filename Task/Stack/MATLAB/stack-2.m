%This class impliments a standard LIFO queue.
classdef LIFOQueue

    properties
        queue
    end

    methods

        %Class constructor
        function theQueue = LIFOQueue(varargin)

            if isempty(varargin) %No input arguments

                %Initialize the queue state as empty
                theQueue.queue = {};
            elseif (numel(varargin) > 1) %More than 1 input arg

                %Make the queue the list of input args
                theQueue.queue = varargin;
            elseif iscell(varargin{:}) %If the only input is a cell array

                %Make the contents of the cell array the elements in the queue
                theQueue.queue = varargin{:};
            else %There is one input argument that is not a cell

                %Make that one arg the only element in the queue
                theQueue.queue = varargin;
            end

        end

        %push() - pushes a new element to the end of the queue
        function push(theQueue,varargin)

            if isempty(varargin)
                theQueue.queue(end+1) = {[]};
            elseif (numel(varargin) > 1) %More than 1 input arg

                %Make the queue the list of input args
                theQueue.queue( end+1:end+numel(varargin) ) = varargin;
            elseif iscell(varargin{:}) %If the only input is a cell array

                %Make the contents of the cell array the elements in the queue
                theQueue.queue( end+1:end+numel(varargin{:}) ) = varargin{:};
            else %There is one input argument that is not a cell

                %Make that one arg the only element in the queue
                theQueue.queue{end+1} = varargin{:};
            end

            %Makes changes to the queue permanent
            assignin('caller',inputname(1),theQueue);

        end

        %pop() - pops the first element off the queue
        function element = pop(theQueue)

            if empty(theQueue)
                error 'The queue is empty'
            else
                %Returns the first element in the queue
                element = theQueue.queue{end};

                %Removes the first element from the queue
                theQueue.queue(end) = [];

                %Makes changes to the queue permanent
                assignin('caller',inputname(1),theQueue);
            end
        end

        %empty() - Returns true if the queue is empty
        function trueFalse = empty(theQueue)

            trueFalse = isempty(theQueue.queue);

        end

    end %methods
end
