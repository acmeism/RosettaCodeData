<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" />
  <xsl:variable name="alpha">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="rot13">NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm</xsl:variable>
  <xsl:template match="body">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="rot13">
    <xsl:value-of select="translate(.,$alpha,$rot13)"/>
  </xsl:template>
</xsl:stylesheet>
