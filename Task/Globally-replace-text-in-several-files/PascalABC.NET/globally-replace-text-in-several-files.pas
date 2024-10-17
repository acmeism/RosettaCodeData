##
foreach var name in EnumerateFiles('.','*.txt') do
  WriteAllText(name,ReadAllText(name).Replace('Goodbye London!', 'Hello, New York!'));
