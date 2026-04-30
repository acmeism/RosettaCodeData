with POSIX.Unsafe_Process_Primitives;

procedure Execute_A_System_Command is
   Arguments : POSIX.POSIX_String_List;
begin
   POSIX.Append (Arguments, "ls");
   POSIX.Unsafe_Process_Primitives.Exec_Search ("ls", Arguments);
end Execute_A_System_Command;
