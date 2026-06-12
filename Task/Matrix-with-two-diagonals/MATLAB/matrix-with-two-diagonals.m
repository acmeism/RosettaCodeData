function A = diagdiag(N, sparse)
% Create an diagonal-diagonal square matrix.
%
% Parameters:
%
%   N      -- number of rows (columns);
%   sparse -- should be true to create a sparse matrix,
%             default false (dense matrix).
%
% Return:
%
%   A matrix where all elements A(i, j) are zero except
%   elements on the diagonal or on the back-diagonal.
%   The diagonal (and back-diagonal) elements are equal 1.

    if nargin < 2
        sparse = false;
    end

    if sparse
        A = speye(N);
    else
        A = eye(N);
    end

    A = fliplr(A);
    A(1:N+1:end) = 1;
end
