my @array1 = 1, 2, 3;
my @array2 = 4, 5, 6;

# If you want to concatenate two array to form a third,
# either use the slip operator "|", to flatten each array.

my @array3 = |@array1, |@array2;
say @array3;

# or just flatten both arrays in one fell swoop

@array3 = flat @array1, @array2;
say @array3;

# On the other hand, if you just want to add the elements
# of the second array to the first, use the .append method.

say @array1.append: @array2;
