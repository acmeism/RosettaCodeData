<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text"/>

<xsl:template match="/">
  <xsl:value-of separator="&#x0A;" select="
    for $n in 1 to 100 return
      concat('fizz'[not($n mod 3)], 'buzz'[not($n mod 5)], $n[$n mod 15 = (1,2,4,7,8,11,13,14)])"/>
</xsl:template>

</xsl:stylesheet>
