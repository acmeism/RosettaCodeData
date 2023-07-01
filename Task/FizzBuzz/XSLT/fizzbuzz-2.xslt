<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exsl="http://exslt.org/common"
  exclude-result-prefixes="xsl exsl">
<xsl:output method="text"/>

<xsl:template name="FizzBuzz" match="/">
  <xsl:param name="n" select="1" />
  <xsl:variable name="_">
    <_><xsl:value-of select="$n" /></_>
  </xsl:variable>
  <xsl:apply-templates select="exsl:node-set($_)/_" />
  <xsl:if test="$n < 100">
    <xsl:call-template name="FizzBuzz">
      <xsl:with-param name="n" select="$n + 1" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="_[. mod 3 = 0]">Fizz
</xsl:template>

<xsl:template match="_[. mod 5 = 0]">Buzz
</xsl:template>

<xsl:template match="_[. mod 15 = 0]" priority="1">FizzBuzz
</xsl:template>

<xsl:template match="_">
  <xsl:value-of select="concat(.,'&#x0A;')" />
</xsl:template>

</xsl:stylesheet>
