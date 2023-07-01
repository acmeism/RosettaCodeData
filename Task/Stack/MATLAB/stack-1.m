mystack = {};

% push
mystack{end+1} = x;

%pop
x = mystack{end};  mystack{end} = [];

%peek,top
x = mystack{end};

% empty
isempty(mystack)
