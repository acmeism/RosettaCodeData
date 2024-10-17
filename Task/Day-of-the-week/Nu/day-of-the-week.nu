2008..2121 | where ($'($it)-12-25' | format date '%w') == '0' | str join ' '
