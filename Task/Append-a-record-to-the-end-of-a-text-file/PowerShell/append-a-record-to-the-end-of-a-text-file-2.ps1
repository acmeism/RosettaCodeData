$records = @()

$records+= New-Record -Account   'jsmith' `
                      -Password  'x' `
                      -UID       1001 `
                      -GID       1000 `
                      -FullName  'Joe Smith' `
                      -Office    'Room 1007' `
                      -Extension '(234)555-8917' `
                      -HomePhone '(234)555-0077' `
                      -Email     'jsmith@rosettacode.org' `
                      -Directory '/home/jsmith' `
                      -Shell     '/bin/bash'

$records+= New-Record -Account   'jdoe' `
                      -Password  'x' `
                      -UID       1002 `
                      -GID       1000 `
                      -FullName  'Jane Doe' `
                      -Office    'Room 1004' `
                      -Extension '(234)555-8914' `
                      -HomePhone '(234)555-0044' `
                      -Email     'jdoe@rosettacode.org' `
                      -Directory '/home/jdoe' `
                      -Shell     '/bin/bash'
