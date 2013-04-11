Directory fileNamed("input.txt") remove
Directory directoryNamed("docs") remove
RootDir := Directory clone setPath("/")
RootDir fileNamed("input.txt") remove
RootDir directoryNamed("docs") remove
