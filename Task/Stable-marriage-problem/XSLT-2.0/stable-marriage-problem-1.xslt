<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:m="http://rosettacode.org/wiki/Stable_marriage_problem"
  xmlns:t="http://rosettacode.org/wiki/Stable_marriage_problem/temp"
  exclude-result-prefixes="xsl xs fn t m">
<xsl:output indent="yes" encoding="UTF-8" omit-xml-declaration="yes" />
<xsl:strip-space elements="*" />

<xsl:template match="*">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()" />
  </xsl:copy>
</xsl:template>

<xsl:template match="@*|comment()|processing-instruction()">
  <xsl:copy />
</xsl:template>

<xsl:template match="m:interest" mode="match-making">
  <m:engagement>
    <m:dude name="{../@name}" /><m:maid name="{.}" />
  </m:engagement>
</xsl:template>

<xsl:template match="m:dude" mode="match-making">
  <!-- 3. Reject suitors cross-off the maids that spurned them. -->
  <xsl:param name="eliminations" select="()" />
  <m:dude name="{@name}">
	<xsl:copy-of select="for $b in @name return
	  m:interest[not(. = $eliminations[m:dude/@name=$b]/m:maid/@name)]" />
  </m:dude>
</xsl:template>

<xsl:template match="*" mode="perturbation">
  <xsl:copy>
    <xsl:apply-templates select="@*,node()" mode="perturbation"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="@*" mode="perturbation">
  <xsl:copy />
</xsl:template>

<xsl:template match="m:engagement[position() lt 3]/m:maid/@name" mode="perturbation">
  <!-- Swap maids 1 and 2. -->
  <xsl:copy-of select="for $c in count(../../preceding-sibling::m:engagement)
       return ../../../m:engagement[2 - $c]/m:maid/@name" />
</xsl:template>

<xsl:template match="m:stable-marriage-problem">
  <xsl:variable name="population" select="m:dude|m:maid" />
  <xsl:variable name="solution">
    <xsl:call-template name="solve-it">
      <xsl:with-param name="dudes" select="m:dude" />
      <xsl:with-param name="maids" select="m:maid" tunnel="yes" />
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="perturbed">
   <xsl:apply-templates select="$solution/*" mode="perturbation" />
  </xsl:variable>
  <m:stable-marriage-problem-result>
    <m:solution is-stable="{t:is-stable( $population, $solution/*)}">
	  <xsl:copy-of select="$solution/*" />
    </m:solution>
	<m:message>Perturbing the matches! Swapping <xsl:value-of select="$solution/*[1]/m:maid/@name" /> for <xsl:value-of select="$solution/*[2]/m:maid/@name" /></m:message>
	<m:message><xsl:choose>
	  <xsl:when test="t:is-stable( $population, $perturbed/*)">
	    <xsl:text>The perturbed configuration is stable.</xsl:text>
	  </xsl:when>
	    <xsl:otherwise>The perturbed configuration is unstable.</xsl:otherwise>
	</xsl:choose></m:message>
  </m:stable-marriage-problem-result>
</xsl:template>

<xsl:template name="solve-it">
  <xsl:param name="dudes" as="element()*" /> <!-- Sequence of m:dude -->
  <xsl:param name="maids" as="element()*" tunnel="yes" />  <!-- Sequence of m:maid -->
  <xsl:param name="engagements" as="element()*" select="()" /> <!-- Sequence of m:engagement -->

  <!-- 1. For each dude not yet engaged, and has a preference, propose to his top preference. -->
  <xsl:variable name="fresh-proposals">
    <xsl:apply-templates select="$dudes[not(@name = $engagements/m:dude/@name)]/m:interest[1]" mode="match-making" />
  </xsl:variable>
  <xsl:variable name="proposals" select="$engagements | $fresh-proposals/m:engagement" />

  <!-- 2. For each maid with conflicting suitors, reject all but the most attractive (for her) proposal. -->
  <xsl:variable name="acceptable" select="$proposals[
    for $g in m:maid/@name, $b in m:dude/@name, $this-interest in $maids[@name=$g]/m:interest[.=$b]
	  return every
	      $interest
		in
		  for $other-b in $proposals[m:maid[@name=$g]]/m:dude/@name[. ne $b]
		    return $maids[@name=$g]/m:interest[.=$other-b]
		satisfies
		  $interest >> $this-interest
    ]" />

  <!-- 3. Reject suitors cross-off the maids that spurned them. -->
  <xsl:variable name="new-dudes">
    <xsl:apply-templates select="$dudes" mode="match-making">
      <xsl:with-param name="eliminations" select="$fresh-proposals/m:engagement" />
    </xsl:apply-templates>
  </xsl:variable>

  <!-- 4. Test for finish. If not, loop back for another round of proposals. -->
  <xsl:choose>
    <xsl:when test="$dudes[not(for $b in @name return $acceptable[m:dude/@name=$b])]">
  	  <xsl:call-template name="solve-it">
        <xsl:with-param name="dudes" select="$new-dudes/m:dude" />
        <xsl:with-param name="engagements" select="$acceptable" />
	  </xsl:call-template>
    </xsl:when>
	<xsl:otherwise>
      <xsl:copy-of select="$acceptable" />
	</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:function name="t:is-stable" as="xs:boolean">
  <xsl:param name="population" as="element()*" />
  <xsl:param name="engagements" as="element()*" />
  <xsl:sequence select="
    every $e in $engagements,
	      $b in string($e/m:dude/@name), $g in string($e/m:maid/@name),
		  $desired-g in $population/self::m:dude[@name=$b]/m:interest[$g=following-sibling::m:interest],
		  $desired-maid in $population/self::m:maid[@name=$desired-g]
	  satisfies
          not(
		    $desired-maid/m:interest[.=$b] &lt;&lt;
		    $desired-maid/m:interest[.=$engagements[m:maid[@name=$desired-g]]/m:dude/@name])
  " />
</xsl:function>
	
</xsl:stylesheet>
