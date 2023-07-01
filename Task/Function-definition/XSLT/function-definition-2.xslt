<xsl:call-template name="multiply">
  <xsl:with-param name="a">4</xsl:with-param>
  <xsl:with-param name="b">5</xsl:with-param>
</xsl:call-template>

<xsl:call-template name="multiply"/>    <-- using default parameters of 2 and 3 -->
