<xsl:if test="@attrib = 'foo'">...</xsl:if>
<xsl:if test="position() != last()">...</xsl:if>
<xsl:if test="not(false())">...</xsl:if>

<!-- Some XPath expressions must be escaped. -->
<xsl:if test='contains(node, "stuff") and (position() &gt; first())'>...</xsl:if>

<!-- The following two examples are synonymous because the test attribute is
     implicitly converted to boolean. -->
<xsl:if test="boolean($expr)">...</xsl:if>
<xsl:if test="$expr">...</xsl:if>
