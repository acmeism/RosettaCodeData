<xsl:package xsl:version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:tour="http://www.seanbdurkin.id.au/tour"
  name="tour:tours">
<xsl:stylesheet>
  <xsl:function name="tour:manufacture-square"
       as="element(square)" visibility="public">
    <xsl:param name="rank" as="xs:integer" />
    <xsl:param name="file" as="xs:integer" />
    <square file="$file" rank="$rank" />
  </xsl:function>

  <xsl:function name="tour:on-board" as="xs:boolean" visibility="public">
    <xsl:param name="rank" as="xs:integer" />
    <xsl:param name="file" as="xs:integer" />
    <xsl:copy-of select="($rank ge 1) and ($rank le 8) and
                         ($file ge 1) and ($file le 8)" />
  </xsl:function>

  <xsl:function name="tour:solve-tour" as="item()*" visibility="public">
    <!-- Solves the tour for any specified piece. -->
    <!-- Outputs either a full solution of 64 squares, of if fail,
         a copy of the $state input. -->
    <xsl:param name="state" as="item()+" />
    <xsl:variable name="compute-possible-moves"
      select="$state[. instance of function(*)]"
      as="function(element(square)) as element(square)*">
    <xsl:variable name="way-points" select="$state/self::square" />
    <xsl:choose>
      <xsl:when test="count($way-points) eq 64">
        <xsl:sequence ="$state" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="
      let $try-move := function( $state as item()*, $move as item()) as item()*)
            {
             if $state/self::square[@file=$move/@file]
                                   [@rank=$move/@rank]
               then $state
               else tour:solve-tour( ( $state, $move) )
                },
              $possible-moves := $compute-possible-moves( $way-points[last()])
          return if empty( $possible-moves) then $state
                     else fn:fold-left( $try-move, $state, $possible-moves)" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable></xsl:function>
</xsl:stylesheet>

<xsl:expose component="function"
  names="tour:manufacture-square tour:on-board tour:solve-tour"
  visibility="public" />

</xsl:package>
