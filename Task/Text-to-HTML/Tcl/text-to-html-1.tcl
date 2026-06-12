package require Tcl 8.5

proc splitParagraphs {text} {
    split [regsub -all {\n\s*(\n\s*)+} [string trim $text] \u0000] "\u0000"
}
proc determineParagraph {para} {
    set para [regsub -all {\s*\n\s*} $para " "]
    switch -regexp -- $para {
	{^\s*\*+\s} {
	    return [list ul [string trimleft $para " \t*"]]
	}
	{^\s*\d+\.\s} {
	    set para [string trimleft $para " \t\n0123456789"]
	    set para [string range $para 1 end]
	    return [list ol [string trimleft $para " \t"]]
	}
	{^#+\s} {
	    return [list heading [string trimleft $para " \t#"]]
	}
    }
    return [list normal $para]
}
proc markupParagraphContent {para} {
    set para [string map {& &amp; < &lt; > &gt;} $para]
    regsub -all {_([\w&;]+)_} $para {<i>\1</i>} para
    regsub -all {\*([\w&;]+)\*} $para {<b>\1</b>} para
    regsub -all {`([\w&;]+)`} $para {<tt>\1</tt>} para
    return $para
}

proc markupText {title text} {
    set title [string map {& &amp; < &lt; > &gt;} $title]
    set result "<html>"
    append result "<head><title>" $title "</title>\n</head>"
    append result "<body>" "<h1>$title</h1>\n"
    set state normal
    foreach para [splitParagraphs $text] {
	lassign [determineParagraph $para] type para
	set para [markupParagraphContent $para]
	switch $state,$type {
	    normal,normal {append result "<p>" $para "</p>\n"}
	    normal,heading {
		append result "<h2>" $para "</h2>\n"
		set type normal
	    }
	    normal,ol {append result "<ol>" "<li>" $para "</li>\n"}
	    normal,ul {append result "<ul>" "<li>" $para "</li>\n"}

	    ul,normal {append result "</ul>" "<p>" $para "</p>\n"}
	    ul,heading {
		append result "</ul>" "<h2>" $para "</h2>\n"
		set type normal
	    }
	    ul,ol {append result "</ul>" "<ol>" "<li>" $para "</li>\n"}
	    ul,ul {append result "<li>" $para "</li>\n"}

	    ol,normal {append result "</ol>" "<p>" $para "</p>\n"}
	    ol,heading {
		append result "</ol>" "<h2>" $para "</h2>\n"
		set type normal
	    }
	    ol,ol {append result "<li>" $para "</li>\n"}
	    ol,ul {append result "</ol>" "<ul>" "<li>" $para "</li>\n"}
	}
	set state $type
    }
    if {$state ne "normal"} {
	append result "</$state>"
    }
    return [append result "</body></html>"]
}
