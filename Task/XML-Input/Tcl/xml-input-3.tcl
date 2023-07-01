proc xml2list xml {
    regsub -all {>\s*<} [string trim $xml " \n\t<>"] "\} \{" xml
    set xml [string map {> "\} \{#text \{" < "\}\} \{"}  $xml]
    set res ""   ;# string to collect the result
    set stack {} ;# track open tags
    set rest {}
    foreach item "{$xml}" {
        switch -regexp -- $item {
	    ^# {append res "{[lrange $item 0 end]} " ; #text item}
	    ^/ {
		regexp {/(.+)} $item -> tagname ;# end tag
		set expected [lindex $stack end]
		set stack [lrange $stack 0 end-1]
		append res "\}\} "
            }
	    /$ { # singleton - start and end in one <> group
                regexp {([^ ]+)( (.+))?/$} $item -> tagname - rest
                set rest [lrange [string map {= " "} $rest] 0 end]
                append res "{$tagname [list $rest] {}} "
	    }
	    default {
                set tagname [lindex $item 0] ;# start tag
                set rest [lrange [string map {= " "} $item] 1 end]
                lappend stack $tagname
                append res "\{$tagname [list $rest] \{"
	    }
        }
    }
    string map {"\} \}" "\}\}"} [lindex $res 0]   ;#"
}
proc deent str {
    regsub -all {&\#x(.+?);} $str {\\u\1} str
    subst -nocommands -novar $str
}
#----------------------- Testing the whole thing:
set xml {<Students>
  <Student Name="April" Gender="F" DateOfBirth="1989-01-02" />
  <Student Name="Bob" Gender="M"  DateOfBirth="1990-03-04" />
  <Student Name="Chad" Gender="M"  DateOfBirth="1991-05-06" />
  <Student Name="Dave" Gender="M"  DateOfBirth="1992-07-08">
    <Pet Type="dog" Name="Rover" />
  </Student>
  <Student DateOfBirth="1993-09-10" Gender="F" Name="&#x00C9;mily" /></Students>
}
foreach i [lindex  [xml2list $xml] 2] {
    if {[lindex $i 0] eq "Student"} {
        foreach {att val} [lindex $i 1] {
            if {$att eq "Name"} {puts [deent $val]}
        }
    }
}
