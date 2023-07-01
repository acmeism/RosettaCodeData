function SumProductPuzzle(maxSum, m)
% SumProductPuzzle(maxSum=100, m=2)
% Efficiently solve the Sum and Product puzzle.
% No solution if maxSum < 65; multiple solutions if maxSum >= 1685.
if nargin<2
    m = 2;          % minimum number
    if nargin<1
        maxSum = 100;
    end
end

%Step 1: Determine viable sums; i.e. sums for which all possibilities have
% non-unique products
productCount = zeros(1,floor((maxSum/2)^2));   % Memory hog
for i = m:(maxSum/2-1)
    j = i+1:maxSum-i;
    ij = i*j;
    productCount(ij) = productCount(ij) +1;
end
viableSum = true(1,maxSum);
viableSum(1:2*m) = false;
for s = 2*m+1:maxSum
    i = m:(s-1)/2;
    j = s-i;
    if any(productCount(i.*j) == 1)
        viableSum(s) = false;
    end
end
tmp = 1:maxSum;
sums = tmp(viableSum);
N1 = sum(floor((sums+1)/2) - m);
fprintf( 1, 'After step 1: %d viable sums (%d total possibilities).\n', length(sums), N1 );

%Step 2: Determine which possibilities now have unique products
productCount = zeros(1,floor((maxSum/2)^2));
for s = sums
    i = m:(s-1)/2;
    j = s-i;
    ij = i.*j;
    productCount(ij) = productCount(ij) +1;
end
A = zeros(2,N1);    %Pre-allocate for speed
n = 1;
for s = sums
    i = m:(s-1)/2;
    j = s-i;
    ii = productCount(i.*j) == 1;
    ij = [i(ii); j(ii)];
    nn = n + size(ij,2);
    A(:,n:nn-1) = ij;
    n = nn;
end
A(:,nn:end) = [];
fprintf( 1, 'After step 2: %d possibilities.\n', size(A,2) );

%Step 3: Narrow down to pairs that have unique sums.
% Since the values are in sum order, just check the neighbor's sum.
d = diff(sum(A))==0;
ii = [d false] | [false d];
A(:,ii) = [];

switch size(A,2)
    case 0
        fprintf(1,'No solution.\n');
    case 1
        fprintf(1,'Puzzle solved! The numbers are %d and %d.\n', A(1:2));
    otherwise
        fprintf(1,'After step 3 there are still multiple possibilities:');
        fprintf(1,' (%d, %d)', A(1:2,:));
        fprintf(1,'\n');
end
