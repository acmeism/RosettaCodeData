use AppleScript version "2.4" -- Mac OS X 10.10 (Yosemite) or later.
use framework "Foundation"

on task()
    set nums to {}
    repeat with a from 2 to 5
        repeat with b from 2 to 5
            set end of nums to (a ^ b) as integer
            set end of nums to (b ^ a) as integer
        end repeat
    end repeat

    set nums to current application's class "NSSet"'s setWithArray:(nums)
    set descriptor to current application's class "NSSortDescriptor"'s sortDescriptorWithKey:("self") ascending:(true)
    return (nums's sortedArrayUsingDescriptors:({descriptor})) as list
end task

task()
