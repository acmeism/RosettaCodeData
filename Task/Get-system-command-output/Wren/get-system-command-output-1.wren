/* Get_system_command_output.wren */
class Command {
    foreign static output(name, param) // the code for this is provided by Go
}

System.print(Command.output("ls", "-ls"))
