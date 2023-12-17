/* Execute_a_system_command.wren */
class Command {
    foreign static exec(name, param) // the code for this is provided by Go
}

Command.exec("ls", "-lt")
System.print()
Command.exec("dir", "")
