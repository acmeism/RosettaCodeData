{ Task: A + B
Sum of A + B while A, B >= -1000 and A,B <= 1000
Author: Sinuhe Masan (2019) }
program APlusB;

var
    A, B : integer;

begin
    repeat
        write('Enter two numbers betwen -1000 and 1000 separated by space: ');
        readln(A, B);

    until ((abs(A) < 1000) and (abs(B) < 1000));

    writeln('The sum is: ', A + B);

end.
