<xsl:template name="multiply">
  <xsl:param name="a" select="2"/>
  <xsl:param name="b" select="3"/>
  <xsl:value-of select="$a * $b"/>
</xsl:template>
