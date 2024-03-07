clear all;close all;clc;

size = 5; %  size of Pascal matrix

% Generate the symmetric Pascal matrix
symPascalMatrix = symPascal(size);

% Generate the upper triangular Pascal matrix
upperPascalMatrix = upperPascal(size);

% Generate the lower triangular Pascal matrix
lowerPascalMatrix = lowerPascal(size);

% Display the matrices
disp('Upper Pascal Matrix:');
disp(upperPascalMatrix);

disp('Lower Pascal Matrix:');
disp(lowerPascalMatrix);

disp('Symmetric Pascal Matrix:');
disp(symPascalMatrix);


function symPascal = symPascal(size)
    % Generates a symmetric Pascal matrix of given size
    row = ones(1, size);
    symPascal = row;
    for k = 2:size
        row = cumsum(row);
        symPascal = [symPascal; row];
    end
end

function upperPascal = upperPascal(size)
    % Generates an upper triangular Pascal matrix using Cholesky decomposition
    upperPascal = chol(symPascal(size));
end

function lowerPascal = lowerPascal(size)
    % Generates a lower triangular Pascal matrix using Cholesky decomposition
    lowerPascal = chol(symPascal(size))';
end
