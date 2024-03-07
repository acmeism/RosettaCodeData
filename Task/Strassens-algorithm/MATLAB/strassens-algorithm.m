clear all;close all;clc;

A = [1, 2; 3, 4];
B = [5, 6; 7, 8];
C = [1, 1, 1, 1; 2, 4, 8, 16; 3, 9, 27, 81; 4, 16, 64, 256];
D = [4, -3, 4/3, -1/4; -13/3, 19/4, -7/3, 11/24; 3/2, -2, 7/6, -1/4; -1/6, 1/4, -1/6, 1/24];
E = [1, 2, 3, 4; 5, 6, 7, 8; 9, 10, 11, 12; 13, 14, 15, 16];
F = eye(4);

disp('Regular multiply: ');
disp(A' * B');

disp('Strassen multiply: ');
disp(Strassen(A', B'));

disp('Regular multiply: ');
disp(C * D);

disp('Strassen multiply: ');
disp(Strassen(C, D));

disp('Regular multiply: ');
disp(E * F);

disp('Strassen multiply: ');
disp(Strassen(E, F));

r = sqrt(2)/2;
R = [r, r; -r, r];

disp('Regular multiply: ');
disp(R * R);

disp('Strassen multiply: ');
disp(Strassen(R, R));


function C = Strassen(A, B)
    n = size(A, 1);
    if n == 1
        C = A * B;
        return
    end
    A11 = A(1:n/2, 1:n/2);
    A12 = A(1:n/2, n/2+1:n);
    A21 = A(n/2+1:n, 1:n/2);
    A22 = A(n/2+1:n, n/2+1:n);
    B11 = B(1:n/2, 1:n/2);
    B12 = B(1:n/2, n/2+1:n);
    B21 = B(n/2+1:n, 1:n/2);
    B22 = B(n/2+1:n, n/2+1:n);

    P1 = Strassen(A12 - A22, B21 + B22);
    P2 = Strassen(A11 + A22, B11 + B22);
    P3 = Strassen(A11 - A21, B11 + B12);
    P4 = Strassen(A11 + A12, B22);
    P5 = Strassen(A11, B12 - B22);
    P6 = Strassen(A22, B21 - B11);
    P7 = Strassen(A21 + A22, B11);

    C11 = P1 + P2 - P4 + P6;
    C12 = P4 + P5;
    C21 = P6 + P7;
    C22 = P2 - P3 + P5 - P7;

    C = [C11 C12; C21 C22];
end
