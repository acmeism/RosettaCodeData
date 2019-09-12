'In case of problem this will terminate the program (without cleanup):
If problem then End
'As VBA is run within an application, such as Excel, a more rigorous way would be:
If problem then Application.Quit
'This will stop the application, but will prompt you to save work.
