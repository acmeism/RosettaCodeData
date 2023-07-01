<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exsl="http://exslt.org/common"
  exclude-result-prefixes="xsl exsl">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<xsl:template match="/*">
  <xsl:copy>
    <xsl:apply-templates select="door" />
  </xsl:copy>
</xsl:template>

<xsl:template match="door">
  <xsl:variable name="door-num" select="@number" />
  <xsl:variable name="knocks">
    <xsl:for-each select="/*/door">
      <xsl:if test="$door-num mod position() = 0">
        <xsl:text>!</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <door number="{$door-num}">
   <xsl:choose>
     <xsl:when test="string-length($knocks) mod 2 = 1">
        <xsl:text>open</xsl:text>
     </xsl:when>
     <xsl:otherwise>
        <xsl:text>closed</xsl:text>
     </xsl:otherwise>
   </xsl:choose>
  </door>
</xsl:template>

</xsl:stylesheet>
