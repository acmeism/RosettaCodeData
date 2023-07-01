# cartesian product of two lists using the X cross meta-operator
say (1, 2) X (3, 4);
say (3, 4) X (1, 2);
say (1, 2) X ( );
say ( )    X ( 1, 2 );

# cartesian product of variable number of lists using
# the [X] reduce cross meta-operator
say [X] (1776, 1789), (7, 12), (4, 14, 23), (0, 1);
say [X] (1, 2, 3), (30), (500, 100);
say [X] (1, 2, 3), (),   (500, 100);
