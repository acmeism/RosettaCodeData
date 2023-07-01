def csv = '''Character,Speech
The multitude,The messiah! Show us the messiah!
Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
The multitude,Who are you?
Brians mother,I'm his mother; that's who!
The multitude,Behold his mother! Behold his mother!'''

println 'Basic:'
println '-----------------------------------------'
println (formatPage('Basic', csv))
println '-----------------------------------------'
println()
println()
println 'Extra Credit:'
println '-----------------------------------------'
println (formatPage('Extra Credit', csv, true))
println '-----------------------------------------'
