<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="3.0">

  <xsl:output method="text"/>

  <xsl:variable name="startingNumberOfBottles" select="99"/>

  <!-- Main procedure.  -->
  <xsl:template match="/" expand-text="true">
    <xsl:iterate select="reverse(1 to $startingNumberOfBottles)">
      <xsl:variable name="currentBottles" select="." as="xs:integer"/>
      <xsl:variable name="newBottles" select=". - 1" as="xs:integer"/>
      <xsl:text>{$currentBottles} bottle{if ($currentBottles ne 1) then 's' else ()} of beer on the wall&#10;</xsl:text>
      <xsl:text>{$currentBottles} bottle{if ($currentBottles ne 1) then 's' else ()} of beer&#10;</xsl:text>
      <xsl:text>Take one down, pass it around&#10;</xsl:text>
      <xsl:text>{$newBottles} bottle{if ($newBottles ne 1) then 's' else ()} of beer on the wall&#10;&#10;</xsl:text>
    </xsl:iterate>
  </xsl:template>
</xsl:stylesheet>
