$a = 'abc 🐧 def'
$enum = $a.EnumerateRunes() | % { "$_" }
-join $enum[$enum.length..0] # fed 🐧 cba
