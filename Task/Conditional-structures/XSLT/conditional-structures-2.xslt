<xsl:choose>
  <xsl:when test="condition1">
    <!-- executed if condition1 evaluates to true -->
  </xsl:when>
  <xsl:when test="condition2">
    <!-- executed if condition2 evaluates to true -->
  </xsl:when>
  <-- etc. -->
  <xsl:otherwise>
    <!-- optional catch-all processing, like C's else or default -->
  </xsl:otherwise>
</xsl:choose>
