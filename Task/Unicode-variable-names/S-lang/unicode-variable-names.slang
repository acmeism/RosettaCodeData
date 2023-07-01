define ∆increment(∆ref) {
  @∆ref++;
}
variable foo∆bar = 1;
foo∆bar++;
variable ∆bar = 1;
∆bar++;
∆increment(&∆bar);
% foo∆bar should be 2 and ∆bar should be 3.
print(foo∆bar);
print(∆bar);
