function [isDividedByZero] = dividebyzero(numerator, denomenator)
   isDividedByZero = isinf( numerator/denomenator );
   % If isDividedByZero equals 1, divide by zero occured.
