        >> SOURCE FORMAT FREE
identification division.
program-id. 'decisiontable'.

environment division.
configuration section.
repository.
    function all intrinsic.

data division.

working-storage section.

01  conditions.
    03  notprinting pic x.
    03  flashing pic x.
    03  notrecognized pic x.

procedure division.
start-decision-table.

display space

display 'The printer does not print (Y or N) ' with no advancing
accept notprinting

display 'A red light is flashing (Y or N) ' with no advancing
accept flashing

display 'The printer is unrecognized (Y or N) ' with no advancing
accept notrecognized

move upper-case(conditions) to conditions

display space

*>decision table Printer troubleshooter

*>  conditions
*>Printer does not print               Y  Y  Y  Y  N  N  N  N
*>A red light is flashing              Y  Y  N  N  Y  Y  N  N
*>Printer is unrecognized              Y  N  Y  N  Y  N  Y  N
*>  actions
*>Check the power cable                      X
*>Check the printer-computer cable     X     X
*>Ensure printer software is installed X     X     X     X
*>Check/replace ink                    X  X        X  X
*>Check for paper jam                     X     X

*>end decision table

evaluate notprinting also flashing also notrecognized

when 'Y' also 'Y' also 'Y'
    display 'Check the printer-computer cable'
    display 'Ensure printer software is installed'
    display 'Check/replace ink'

when 'Y' also 'Y' also 'N'
    display 'Check/replace ink'
    display 'Check for paper jam'

when 'Y' also 'N' also 'Y'
    display 'Check the power cable'
    display 'Check the printer-computer cable'
    display 'Ensure printer software is installed'

when 'Y' also 'N' also 'N'
    display 'Check for paper jam'

when 'N' also 'Y' also 'Y'
    display 'Ensure printer software is installed'
    display 'Check/replace ink'

when 'N' also 'Y' also 'N'
    display 'Check/replace ink'

when 'N' also 'N' also 'Y'
    display 'Ensure printer software is installed'

when 'N' also 'N' also 'N'
    display 'no action found'

when other
    display 'invalid input: ' notprinting space flashing space notrecognized

end-evaluate

display space

stop run
.

end program 'decisiontable'.
