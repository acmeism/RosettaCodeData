<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<xsl:template match="/">
  <hallway>
    <xsl:for-each select="1 to 100">
      <xsl:variable name="door-num" select="position()" />
      <door number="{$door-num}">
        <xsl:value-of select="('closed','open')[
	    number( sum( for $pass in 1 to 100 return
	    number(($door-num mod $pass) = 0)) mod 2 = 1) + 1]" />
      </door>
    </xsl:for-each>
  </hallway>
</xsl:template>

</xsl:stylesheet>
