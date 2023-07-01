function [ x ] = GaussElim( A, b)

% Ensures A is n by n
sz = size(A);
if sz(1)~=sz(2)
    fprintf('A is not n by n\n');
    clear x;
    return;
end

n = sz(1);

% Ensures b is n x 1.
if n~=sz(1)
    fprintf('b is not 1 by n.\n');
    return
end

x = zeros(n,1);
aug = [A b];
tempmatrix = aug;

for i=2:sz(1)


    % Find maximum of row and divide by the maximum
    tempmatrix(1,:) = tempmatrix(1,:)/max(tempmatrix(1,:));

    % Finds the maximum in column
    temp = find(abs(tempmatrix) - max(abs(tempmatrix(:,1))));
    if length(temp)>2
        for j=1:length(temp)-1
            if j~=temp(j)
                maxi = j; %maxi = column number of maximum
                break;
            end
        end
    else % length(temp)==2
        maxi=1;
    end

    % Row swap if maxi is not 1
    if maxi~=1
        temp = tempmatrix(maxi,:);
        tempmatrix(maxi,:) = tempmatrix(1,:);
        tempmatrix(1,:) = temp;
    end

    % Row reducing
    for j=2:length(tempmatrix)-1
        tempmatrix(j,:) = tempmatrix(j,:)-tempmatrix(j,1)/tempmatrix(1,1)*tempmatrix(1,:);
        if tempmatrix(j,j)==0 || isnan(tempmatrix(j,j)) || abs(tempmatrix(j,j))==Inf
            fprintf('Error: Matrix is singular.\n');
            clear x;
            return
        end
    end
    aug(i-1:end,i-1:end) = tempmatrix;

    % Decrease matrix size
    tempmatrix = tempmatrix(2:end,2:end);
end

% Backwards Substitution
x(end) = aug(end,end)/aug(end,end-1);
for i=n-1:-1:1
    x(i) = (aug(i,end)-dot(aug(i,1:end-1),x))/aug(i,i);
end

end
