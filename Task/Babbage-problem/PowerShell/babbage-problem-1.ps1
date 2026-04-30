###########################################################################################
#
# Definitions:
#
#   Lines that begin with the "#" symbol are comments: they will be ignored by the machine.
#
# -----------------------------------------------------------------------------------------
#
#   While
#
#   Run a command block based on the results of a conditional test.
#
#   Syntax
#       while (condition) {command_block}
#
#   Key
#
#       condition      If this evaluates to TRUE the loop {command_block} runs.
#                      when the loop has run once the condition is evaluated again.
#
#       command_block  Commands to run each time the loop repeats.
#
#   As long as the condition remains true, PowerShell reruns the {command_block} section.
#
# -----------------------------------------------------------------------------------------
#
#   *   means 'multiplied by'
#   %   means 'modulo', or remainder after division
#   -ne means 'is not equal to'
#   ++  means 'increment variable by one'
#
###########################################################################################

# Declare a variable, $integer, with a starting value of 0.

$integer = 0

while (($integer * $integer) % 1000000 -ne 269696)
{
    $integer++
}

# Show the result.

$integer
