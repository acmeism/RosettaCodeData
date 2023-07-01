public //visible to anything.
protected //visible to current class and to derived classes.
internal //visible to anything inside the same assembly (.dll/.exe).
protected internal //visible to anything inside the same assembly and also to derived classes outside the assembly.
private //visible only to the current class.
//C# 7.2 adds:
private protected //visible to current class and to derived classes inside the same assembly.

//                   |       |     subclass     |    other class   ||     subclass     |    other class
//Modifier           | class | in same assembly | in same assembly || outside assembly | outside assembly
//-------------------------------------------------------------------------------------------------------
//public             |  Yes  |        Yes       |        Yes       ||        Yes       |       Yes
//protected internal |  Yes  |        Yes       |        Yes       ||        Yes       |       No
//protected          |  Yes  |        Yes       |        No        ||        Yes       |       No
//internal           |  Yes  |        Yes       |        Yes       ||        No        |       No
//private            |  Yes  |        No        |        No        ||        No        |       No
// C# 7.2:
//private protected  |  Yes  |        Yes       |        No        ||        No        |       No
