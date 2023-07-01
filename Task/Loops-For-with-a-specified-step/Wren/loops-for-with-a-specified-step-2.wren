import "/iterate" for Stepped

// Print odd numbers under 20.
for (i in Stepped.new(1..20, 2)) System.write("%(i) ")
System.print()

// Print first plus every third element thereafter.
for (i in Stepped.new(1..20, 3)) System.write("%(i) ")
System.print()
