<point x="20" y="30"/>

<!-- context is a point node. The '@' prefix selects named attributes of the current node. -->
<fo:block>Point = <xsl:value-of select="@x"/>, <xsl:value-of select="@y"/></fo:block>
