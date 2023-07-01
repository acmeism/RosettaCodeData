n=8;
solutions=[[]];
v = 1:n;
P = perms(v);
for i=1:length(P)
    for j=1:n
        sub(j)=P(i,j)-j;
        add(j)=P(i,j)+j;
    end
    if n==length(unique(sub)) && n==length(unique(add))
        solutions(end+1,:)=P(i,:);
    end
end

fprintf('Number of solutions with %i queens: %i', n, length(solutions));

if ~isempty(solutions)
    %Print first possible solution
    board=solutions(1,:);
    s = repmat('-',n);
    for k=1:length(board)
        s(k,board(k)) = 'Q';
    end
    s
end
