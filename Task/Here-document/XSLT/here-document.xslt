<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text"/>

<xsl:template match="/">
<![CDATA[

This text is in a CDATA section. In here, it's okay to include <, >, &, ", and '
without any special treatment.

The section is terminated by a three-character sequence consisting of two right
brackets ("]]") followed by a greater-than (">"). If this sequence appears in
your text, a workaround is to drop out of the CDATA section, output part of the
terminator, then start a new CDATA section and output the rest. Let's do this
now:

	]]>]]<![CDATA[>

Newlines and spacing are retained as well, as long as they're evaluated in a
context that bothers preserving them. Whether or not the spaces before and after
the CDATA section are also preserved may be application-dependent.

]]>
</xsl:template>
</xsl:stylesheet>
