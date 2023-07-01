  <xsl:template name="ackermann">
    <xsl:param name="m"/>
    <xsl:param name="n"/>

    <xsl:choose>
      <xsl:when test="$m = 0">
        <xsl:value-of select="$n+1"/>
      </xsl:when>
      <xsl:when test="$n = 0">
        <xsl:call-template name="ackermann">
          <xsl:with-param name="m" select="$m - 1"/>
          <xsl:with-param name="n" select="'1'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="p">
          <xsl:call-template name="ackermann">
            <xsl:with-param name="m" select="$m"/>
            <xsl:with-param name="n" select="$n - 1"/>
          </xsl:call-template>
        </xsl:variable>

        <xsl:call-template name="ackermann">
          <xsl:with-param name="m" select="$m - 1"/>
          <xsl:with-param name="n" select="$p"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
