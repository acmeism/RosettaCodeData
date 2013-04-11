-- Demonstrate the overlay of one object on another
A : Integer;
B : Integer;
for B'Address use A'Address;
-- A and B start at the same address
