def list1 : [ range(1;10) ];
def list2 : [ range(10; 19)];
def list3 : [ range(19; 28) ];

[list1, list2, list3]
| transpose
| map( map(tostring) | add | tonumber)
