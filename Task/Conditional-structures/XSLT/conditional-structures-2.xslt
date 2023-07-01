<xsl:choose>
  <xsl:when test="condition1">
    <!-- included if condition1 evaluates to true (like C `if`) -->
  </xsl:when>
  <xsl:when test="condition2">
    <!-- included if all previous conditions evaluated to false and
         condition2 evaluates to true (like C `else if`) -->
  </xsl:when>
  <--
    ...
  -->
  <xsl:otherwise>
    <!-- included if all previous conditions evaluated to false
         (like C `else`) -->
    <!-- (The `otherwise` element is optional) -->
  </xsl:otherwise>
</xsl:choose>
