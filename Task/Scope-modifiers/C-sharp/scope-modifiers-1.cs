public //visible to anything.
protected //visible to current class and to derived classes.
internal //visible to anything inside the same assembly (.dll/.exe).
protected internal //visible to anything inside the same assembly and also to derived classes outside the assembly.
private //visible only to the current class.

//Modifier           | Class | Assembly | Subclass | World
//--------------------------------------------------------
//public             |  Y    |  Y       |  Y       |  Y
//protected internal |  Y    |  Y       |  Y       |  N
//protected          |  Y    |  N       |  Y       |  N
//internal           |  Y    |  Y       |  N       |  N
//private            |  Y    |  N       |  N       |  N
