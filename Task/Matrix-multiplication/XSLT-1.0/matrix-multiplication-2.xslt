<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
  <xsl:output method="html"/>

  <xsl:template match="/mult">
    <table>
      <tr><td>╭</td><td colspan="{count(*[2]/*[1]/*)}"/><td>╮</td></tr>
      <xsl:call-template name="prodMM">
        <xsl:with-param name="A" select="*[1]/*"/>
        <xsl:with-param name="B" select="*[2]/*"/>
      </xsl:call-template>
      <tr><td>╰</td><td colspan="{count(*[2]/*[1]/*)}"/><td>╯</td></tr>
    </table>
  </xsl:template>

  <xsl:template name="prodMM">
    <xsl:param name="A"/>
    <xsl:param name="B"/>

    <xsl:if test="$A/*">
      <tr>
        <td>│</td>
        <xsl:call-template name="prodVM">
          <xsl:with-param name="a" select="$A[1]/*"/>
          <xsl:with-param name="B" select="$B"/>
        </xsl:call-template>
        <td>│</td>
      </tr>

      <xsl:call-template name="prodMM">
        <xsl:with-param name="A" select="$A[position()>1]"/>
        <xsl:with-param name="B" select="$B"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="prodVM">
    <xsl:param name="a"/>
    <xsl:param name="B"/>
    <xsl:param name="col" select="1"/>

    <xsl:if test="$B/*[$col]">
      <td align="right">
        <xsl:call-template name="prod">
          <xsl:with-param name="a" select="$a"/>
          <xsl:with-param name="b" select="$B/*[$col]"/>
        </xsl:call-template>
      </td>

      <xsl:call-template name="prodVM">
        <xsl:with-param name="a"   select="$a"/>
        <xsl:with-param name="B"   select="$B"/>
        <xsl:with-param name="col" select="$col+1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="prod">
    <xsl:param name="a"/>
    <xsl:param name="b"/>

    <xsl:if test="not($a)">0</xsl:if>

    <xsl:if test="$a">
      <xsl:variable name="res">
        <xsl:call-template name="prod">
          <xsl:with-param name="a" select="$a[position()>1]"/>
          <xsl:with-param name="b" select="$b[position()>1]"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:value-of select="$a[1] * $b[1] + $res"/>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
