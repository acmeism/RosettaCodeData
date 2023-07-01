List<Integer> integers = new List<Integer>{1,2,3,4,5};
Set<Integer> evenIntegers = new Set<Integer>();
for(Integer i : integers)
{
    if(math.mod(i,2) == 0)
    {
        evenIntegers.add(i);
    }
}
system.assert(evenIntegers.size() == 2, 'We should only have two even numbers in the set');
system.assert(!evenIntegers.contains(1), '1 should not be a number in the set');
system.assert(evenIntegers.contains(2), '2 should be a number in the set');
system.assert(!evenIntegers.contains(3), '3 should not be a number in the set');
system.assert(evenIntegers.contains(4), '4 should be a number in the set');
system.assert(!evenIntegers.contains(5), '5 should not be a number in the set');
