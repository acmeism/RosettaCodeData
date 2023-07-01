myfifo = {};

% push
myfifo{end+1} = x;

% pop
x = myfifo{1};  myfifo{1} = [];

% empty
isempty(myfifo)
