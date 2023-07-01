<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
        <demo>
            <!--
                XSLT 1.0 actually defines two function-like constructs that
                are used variously depending on the context.
            -->
            <xsl:call-template name="xpath-function-demos"/>
            <xsl:call-template name="xslt-template-demos"/>
        </demo>
    </xsl:template>

    <xsl:template name="xpath-function-demos">
        <!--
            A 'function' in XSLT 1.0 is a function that can be called from
            an XPath 1.0 expression (such as from "select" or "test"
            attribute of several XSLT elements). The following demos apply
            to these functions.
        -->

        <!-- Calling function that requires no arguments -->
        <!-- false() always returns a boolean false value -->
        <line>This test is <xsl:if test="false()">NOT</xsl:if> OK.</line>

        <!-- Calling a function with a fixed number of arguments -->
        <!-- not() takes exactly 1 argument. starts-with() takes exactly 2 arguments. -->
        <line>'haystack' does <xsl:if test="not(starts-with('haystack', 'hay'))">NOT</xsl:if> start with 'hay'.</line>

        <!-- Calling a function with optional arguments -->
        <!-- If the third argument of substring() is omitted, the length of the string is assumed. -->
        <line>'<xsl:value-of select="substring('haystack', 1, 3)"/>' = 'hay'</line>
        <line>'<xsl:value-of select="substring('haystack', 4)"/>' = 'stack'</line>

        <!-- Calling a function with a variable number of arguments -->
        <!-- concat() accepts two or more arguments. -->
        <line>'<xsl:value-of select="concat('abcd', 'efgh')"/>' = 'abcdefgh'</line>
        <line>'<xsl:value-of select="concat('ij', 'kl', 'mn', 'op')"/>' = 'ijklmnop'</line>
        <!--
            Aggregate functions such as sum() and count() accept nodesets.
            This isn't quite the same as varargs but are probably worth
            mentioning.
        -->
        <line>The number of root elements in the input document is <xsl:value-of select="count(/*)"/> (should be 1).</line>

        <!-- Calling a function with named arguments -->
        <!-- XPath 1.0 uses only positional parameters. -->

        <!-- Using a function in statement context -->
        <!--
            In general, XPath 1.0 functions have no side effects, so calling
            them as statements is useless. While implementations often allow
            writing extensions in imperative languages, the semantics of
            calling a function with side effects are, at the very least,
            implementation-dependent.
        -->

        <!-- Using a function in first-class context within an expression -->
        <!-- Functions are not natively first-class values in XPath 1.0. -->

        <!-- Obtaining the return value of a function -->
        <!--
            The return value of the function is handled as specified by the
            various contexts in which an XPath expression is used. The
            return value can be stored in a "variable" (no destructive
            assignment is allowed), passed as a parameter to a function or a
            template, used as a conditional in an <xsl:if/> or <xsl:when/>,
            interpolated into text using <xsl:value-of/> or into an
            attribute value using brace syntax, and so forth.
        -->
        <!-- Here, concat() is interpolated into an attribute value using braces ({}). -->
        <line foo="{concat('Hello, ', 'Hello, ', 'Hello')}!">See attribute.</line>

        <!-- Distinguishing built-in functions and user-defined functions -->
        <!--
            Given that functions aren't first-class here, the origin of any
            given function is known before run time. Incidentally, functions
            defined by the standard are generally unprefixed while
            implementation-specific extensions (and user extensions, if
            available) must be defined within a separate namespace and
            prefixed.
        -->

        <!-- Distinguishing subroutines and functions -->
        <!--
            There are no "subroutines" in this sense—everything that looks
            like a subroutine has some sort of return or result value.
        -->

        <!-- Stating whether arguments are passed by value or by reference -->
        <!-- There is no meaningful distinction since there is no mechanism by which to mutate values. -->

        <!-- Is partial application possible and how -->
        <!-- Not natively. -->
    </xsl:template>

    <xsl:template name="xslt-template-demos">
        <!--
            A 'template' in XSLT 1.0 is a subroutine-like construct. When
            given a name (and, optionally, parameters), it can be called
            from within another template using the <xsl:call-template/>
            element. (An unnamed template is instead called according to its
            match and mode attributes.) The following demos apply to named
            templates.
        -->
        <!--
            Unlike with functions, there are no built-in named templates to
            speak of. The ones used here are defined later in this
            transform.
        -->

        <!--
            Answers for these prompts are the same as with XPath functions (above):
                Using a function in statement context
                Distinguishing subroutines and functions
                Stating whether arguments are passed by value or by reference
                Is partial application possible and how
        -->

        <!-- Calling function that requires no arguments -->
        <xsl:call-template name="nullary-demo"/>
        <!--
            Note that even if a template has no parameters, it has access to
            the current node (.) as of the time of the call. This
            <xsl:apply-templates/> runs a matching template above that calls
            the template "nullary-context-demo" with no parameters. Another
            way to manipulate a template's idea of which node is current is
            by calling from inside a <xsl:for-each/> loop.
        -->
        <xsl:apply-templates select="/*" mode="nullary-context-demo-mode"/>

        <!--
            A template parameter is made optional in the definition of the
            template by supplying an expression as its select attribute,
            which is evaluated and used as its value if the parameter is
            omitted. Note, though, that all template parameters have an
            implicit default value, the empty string, if the select
            attribute is not specified. Therefore, all template parameters
            are always optional, even when semantically they should not be.
        -->

        <!-- Calling a function with a fixed number of arguments -->
        <working note="When all parameters are supplied">
            <xsl:call-template name="ternary-demo">
                <xsl:with-param name="a" select="4"/>
                <xsl:with-param name="b">3</xsl:with-param>
                <xsl:with-param name="c" select="2 + 3"/>
            </xsl:call-template>
        </working>
        <broken note="When the third parameter 'c' is omitted">
            <xsl:call-template name="ternary-demo">
                <xsl:with-param name="a" select="4"/>
                <xsl:with-param name="b">3</xsl:with-param>
            </xsl:call-template>
        </broken>

        <!-- Calling a function with optional arguments -->
        <!-- With the optional third parameter -->
        <working name="When all parameters are supplied">
            <xsl:call-template name="binary-or-ternary-demo">
                <xsl:with-param name="a" select="4"/>
                <xsl:with-param name="b" select="3"/>
                <xsl:with-param name="c" select="5"/>
            </xsl:call-template>
        </working>
        <!-- Without the optional third parameter (which defaults to 0) -->
        <working name="When 'a' and 'b' are supplied but 'c' is defaulted to 0">
            <xsl:call-template name="binary-or-ternary-demo">
                <xsl:with-param name="a" select="4"/>
                <xsl:with-param name="b" select="3"/>
            </xsl:call-template>
        </working>

        <!-- Calling a function with a variable number of arguments -->
        <!--
            Templates are not varargs-capable. Variable numbers of arguments
            usually appear in the form of a nodeset which is then bound to a
            single parameter name.
        -->

        <!-- Calling a function with named arguments -->
        <!--
            Other than what comes with the current context, template
            arguments are always named and can be supplied in any order.
            Templates do not support positional arguments. Additionally,
            even arguments not specified by the template may be passed; they
            are silently ignored.
        -->

        <!-- Using a function in first-class context within an expression -->
        <!-- Templates are not first-class values in XSLT 1.0. -->

        <!-- Obtaining the return value of a function -->
        <!--
            The output of a template is interpolated into the place of the
            call. Often, this is directly into the output of the transform,
            as with most of the above examples. However, it is also possible
            to bind the output as a variable or parameter. This is useful
            for using templates to compute parameters for other templates or
            for XPath functions.
        -->
        <!-- Which is the least of 34, 78, 12, 56? -->
        <xsl:variable name="lesser-demo-result">
            <!-- The variable is bound to the output of this call -->
            <xsl:call-template name="lesser-value">
                <xsl:with-param name="a">
                    <!-- A call as a parameter to another call -->
                    <xsl:call-template name="lesser-value">
                        <xsl:with-param name="a" select="34"/>
                        <xsl:with-param name="b" select="78"/>
                    </xsl:call-template>
                </xsl:with-param>
                <xsl:with-param name="b">
                    <!-- and again -->
                    <xsl:call-template name="lesser-value">
                        <xsl:with-param name="a" select="12"/>
                        <xsl:with-param name="b" select="56"/>
                    </xsl:call-template>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <!-- The variable is used here in an XPath expression -->
        <line>
            <xsl:value-of select="concat('And the answer, which should be 12, is ', $lesser-demo-result, ', of course.')"/>
        </line>

        <!-- Distinguishing built-in functions and user-defined functions -->
        <!-- Virtually all templates are user-defined. -->

    </xsl:template>

    <!-- Templates supporting template demos above -->
    <xsl:template match="/*" mode="nullary-context-demo-mode">
        <xsl:call-template name="nullary-context-demo"/>
    </xsl:template>

    <xsl:template name="nullary-demo">
        <line>No parameters needed here!</line>
    </xsl:template>

    <xsl:template name="nullary-context-demo">
        <!-- When a template is called it has access to the current node of the caller -->
        <xsl:for-each select="self::*">
            <line>The context element here is named "<xsl:value-of select="local-name()"/>"</line>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="ternary-demo">
        <!-- This demo requires, at least semantically, all three parameters. -->
        <xsl:param name="a"/>
        <xsl:param name="b"/>
        <xsl:param name="c"/>
        <line>(<xsl:value-of select="$a"/> * <xsl:value-of select="$b"/>) + <xsl:value-of select="$c"/> = <xsl:value-of select="($a * $b) + $c"/></line>
    </xsl:template>

    <xsl:template name="binary-or-ternary-demo">
        <!-- This demo requires the first two parameters, but defaults the third to 0 if it is not supplied. -->
        <xsl:param name="a"/>
        <xsl:param name="b"/>
        <xsl:param name="c" select="0"/>
        <line>(<xsl:value-of select="$a"/> * <xsl:value-of select="$b"/>) + <xsl:value-of select="$c"/> = <xsl:value-of select="($a * $b) + $c"/></line>
    </xsl:template>

    <xsl:template name="lesser-value">
        <xsl:param name="a"/>
        <xsl:param name="b"/>
        <xsl:choose>
            <xsl:when test="number($a) &lt; number($b)">
                <xsl:value-of select="$a"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$b"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
