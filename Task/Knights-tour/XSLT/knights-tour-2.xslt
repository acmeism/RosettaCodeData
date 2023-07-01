<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:tour="http://www.seanbdurkin.id.au/tour"
  exclude-result-prefixes="xsl fn xs tour">
<xsl:use-package name="tour:tours" />
<xsl:output indent="yes" encoding="UTF-8" omit-xml-declaration="yes" />
<xsl:mode on-no-match="shallow-copy" streamable="yes"/>

<xsl:template match="knight[square]">
  <xsl:variable name="error">
    <error>Failed to find solution to Knight's Tour.</error>
  </xsl:variable>
  <xsl:copy>
    <xsl:copy-of select="
    let $final-state := tour:solve-tour((
    function( $piece-position as element(square)) as element(square)*
      { (: This function defines a knight's move. :)
        let $r0 := number( $piece-position/@rank),
        let $f0 := number( $piece-position/@file),
        for $r in -2..2, $f in -2..2 return
          if (abs($r) + abs($f) eq 3) and
             tour:on-board($r+$r0, $f+$f0) then
            tour:manufacture-square($r+$r0, $f+$f0)
          else ()
      }
      , current()/square)),
     $solution := $final-state/self::square
    return if count($solution) eq 64 then $solution
           else $error/*" />
  </xsl:copy>
</xsl:template>

<!-- Add templates for other piece types if you want to solve
     their tours too. Solve by calling tour:solve-tour() .    -->

</xsl:stylesheet>
