String.metaClass.getAsAsciiArt = {
    def request = "http://www.network-science.de/ascii/ascii.php?TEXT=${delegate}&x=23&y=10&FONT=block&RICH=no&FORM=left&STRE=no&WIDT=80"
    def html = new URL(request).text
    (html =~ '<TD><PRE>([^<]+)</PRE>')[-1][1]
}

println "Groovy".asAsciiArt
