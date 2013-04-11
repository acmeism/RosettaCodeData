<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:template match="/numbers">
        <html>
            <body>
                <ul>
                    <xsl:apply-templates />
                </ul>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="number">
        <li>
            Number:
            <xsl:apply-templates mode="value" />
            Factors:
            <xsl:apply-templates mode="factors" />
        </li>
    </xsl:template>

    <xsl:template match="value" mode="value">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="value" mode="factors">
        <xsl:call-template name="generate">
            <xsl:with-param name="number" select="number(current())" />
            <xsl:with-param name="candidate" select="number(2)" />
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="generate">
        <xsl:param name="number" />
        <xsl:param name="candidate" />
        <xsl:choose>
            <!-- 1 is no prime and does not have any factors -->
            <xsl:when test="$number = 1"></xsl:when>
            <!-- if the candidate is larger than the sqrt of the number, it's prime and the last factor -->
            <xsl:when test="$candidate * $candidate &gt; $number">
                <xsl:value-of select="$number" />
            </xsl:when>
            <!-- if the number is factored by the candidate, add the factor and try again with the same factor -->
            <xsl:when test="$number mod $candidate = 0">
                <xsl:value-of select="$candidate" />
                <xsl:text> </xsl:text>
                <xsl:call-template name="generate">
                    <xsl:with-param name="number" select="$number div $candidate" />
                    <xsl:with-param name="candidate" select="$candidate" />
                </xsl:call-template>
            </xsl:when>
            <!-- else try again with the next factor -->
            <xsl:otherwise>
                <!-- increment by 2 to save stack depth -->
                <xsl:choose>
                    <xsl:when test="$candidate = 2">
                        <xsl:call-template name="generate">
                            <xsl:with-param name="number" select="$number" />
                            <xsl:with-param name="candidate" select="$candidate + 1" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="generate">
                            <xsl:with-param name="number" select="$number" />
                            <xsl:with-param name="candidate" select="$candidate + 2" />
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
