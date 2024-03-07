clear all;close all;clc;
A = [1, 3, 7, 8, 10;
     2, 4, 16, 14, 4;
     3, 1, 9, 18, 11;
     12, 14, 17, 18, 20;
     7, 1, 3, 9, 5];

lower_triangular = tril(A, -1);
sum_of_elements = sum(lower_triangular(:)); % Sum of all elements in the lower triangular part

fprintf('%d\n', sum_of_elements);  % Prints 69
