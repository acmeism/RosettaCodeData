/* Check_output_device_is_a_terminal.wren */

class C {
    foreign static isOutputDeviceTerminal
}

System.print("Output device is a terminal = %(C.isOutputDeviceTerminal)")
