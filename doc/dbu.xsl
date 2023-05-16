<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0' xmlns="http://www.w3.org/1999/xhtml">

<xsl:import href="http://docbook.sourceforge.net/release/xsl/current/xhtml/chunk.xsl"/>

<xsl:template name="header.navigation"/>
<xsl:template name="footer.navigation"/>

<xsl:template name="user.head.content">
   <xsl:variable name="headfile" select="document('head.html',/)"/>
   <xsl:copy-of select="$headfile/head/node()"/>
</xsl:template>

<xsl:template match="refname">
  <xsl:if test="not(preceding-sibling::refdescriptor)">
    <span class="name">
      <xsl:apply-templates/>
      <xsl:if test="following-sibling::refname">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </span>
  </xsl:if>
</xsl:template>

<xsl:template match="refpurpose">
  <xsl:if test="node()">
    <xsl:text> </xsl:text>
    <span class="em-dash">
      <xsl:call-template name="dingbat">
        <xsl:with-param name="dingbat">em-dash</xsl:with-param>
      </xsl:call-template>
    </span>
    <xsl:text> </xsl:text>
    <span class="purpose">
      <xsl:apply-templates/>
    </span>
  </xsl:if>
</xsl:template>

<xsl:template match="refpurpose" mode="no.anchor.mode">
  <xsl:if test="node()">
    <xsl:text> </xsl:text>
    <span class="em-dash">
      <xsl:call-template name="dingbat">
        <xsl:with-param name="dingbat">em-dash</xsl:with-param>
      </xsl:call-template>
    </span>
    <xsl:text> </xsl:text>
    <span class="purpose">
      <xsl:apply-templates mode="no.anchor.mode"/>
    </span>
  </xsl:if>
</xsl:template>

<xsl:template match="programlisting|screen|synopsis">
  <xsl:param name="suppress-numbers" select="'0'"/>

  <xsl:call-template name="anchor"/>

  <xsl:variable name="div.element">pre</xsl:variable>

  <xsl:if test="$shade.verbatim != 0">
    <xsl:message>
      <xsl:text>The shade.verbatim parameter is deprecated. </xsl:text>
      <xsl:text>Use CSS instead,</xsl:text>
    </xsl:message>
    <xsl:message>
      <xsl:text>for example: pre.</xsl:text>
      <xsl:value-of select="local-name(.)"/>
      <xsl:text> { background-color: #E0E0E0; }</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="$suppress-numbers = '0'
                    and @linenumbering = 'numbered'
                    and $use.extensions != '0'
                    and $linenumbering.extension != '0'">
      <xsl:variable name="rtf">
        <xsl:choose>
          <xsl:when test="$highlight.source != 0">
            <xsl:call-template name="apply-highlighting"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:element name="{$div.element}">
        <xsl:apply-templates select="." mode="common.html.attributes"/>
        <xsl:call-template name="id.attribute"/>
        <xsl:if test="@language != ''">
          <xsl:attribute name="class">
              <xsl:value-of select="concat('language-', @language)"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="@width != ''">
          <xsl:attribute name="width">
            <xsl:value-of select="@width"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:call-template name="number.rtf.lines">
          <xsl:with-param name="rtf" select="$rtf"/>
        </xsl:call-template>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:element name="{$div.element}">
        <xsl:apply-templates select="." mode="common.html.attributes"/>
        <xsl:call-template name="id.attribute"/>
        <xsl:if test="@language != ''">
          <xsl:attribute name="class">
              <xsl:value-of select="concat('language-', @language)"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="@width != ''">
          <xsl:attribute name="width">
            <xsl:value-of select="@width"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="$highlight.source != 0">
            <xsl:call-template name="apply-highlighting"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:element>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
