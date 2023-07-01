<xsl:template match="/table">
    <table>
        <xsl:apply-templates />
    </table>
</xsl:template>

<xsl:template match="tr">
    <tr><xsl:apply-templates /></tr>
</xsl:template>

<xsl:template match="td">
    <xsl:variable name="liveNeighbours">
        <xsl:apply-templates select="current()" mode="countLiveNeighbours" />
    </xsl:variable>

    <xsl:choose>
        <xsl:when test="(current() = 'X' and $liveNeighbours = 2) or $liveNeighbours = 3">
            <xsl:call-template name="live" />
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="die" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="td" mode="countLiveNeighbours">
    <xsl:variable name="currentX" select="count(preceding-sibling::td) + 1" />
    <xsl:variable name="precedingRow" select="parent::tr/preceding-sibling::tr[1]" />
    <xsl:variable name="followingRow" select="parent::tr/following-sibling::tr[1]" />

    <xsl:variable name="neighbours" select="$precedingRow/td[$currentX - 1] |
                                            $precedingRow/td[$currentX] |
                                            $precedingRow/td[$currentX + 1] |
                                            preceding-sibling::td[1] |
                                            following-sibling::td[1] |
                                            $followingRow/td[$currentX - 1] |
                                            $followingRow/td[$currentX] |
                                            $followingRow/td[$currentX + 1]" />

    <xsl:value-of select="count($neighbours[text() = 'X'])" />
</xsl:template>

<xsl:template name="die">
    <td>_</td>
</xsl:template>

<xsl:template name="live">
    <td>X</td>
</xsl:template>
