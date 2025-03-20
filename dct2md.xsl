<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:sh="http://www.w3.org/ns/shacl#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:dct="http://purl.org/dc/terms/"
>

<xsl:variable name="params" select="/ROOT/@params"/>

<xsl:output method="text"/>

<xsl:variable name="doublequote">"</xsl:variable>
<xsl:variable name="doublequote-escape">\\"</xsl:variable>

<xsl:template match="rdf:Description" mode="reference">
  <xsl:text>  "</xsl:text>
  <xsl:value-of select="replace(dct:identifier,'[^a-zA-Z0-9_-]','')"/>
  <xsl:text>": {&#xa;</xsl:text>
  <xsl:if test="rdfs:label[1]!=''">
    <xsl:text>    title: "</xsl:text>
    <xsl:value-of select="replace(replace(rdfs:label[1],'\n',''),$doublequote,$doublequote-escape)"/>
    <xsl:text>",&#xa;</xsl:text>
  </xsl:if>
  <xsl:if test="dct:bibliographicCitation/@rdf:resource!=''">
    <xsl:text>    href: "</xsl:text>
    <xsl:value-of select="dct:bibliographicCitation[1]/@rdf:resource"/>
    <xsl:text>",&#xa;</xsl:text>
  </xsl:if>
  <xsl:text>  },&#xa;</xsl:text>
</xsl:template>

<xsl:template match="/">
  <xsl:apply-templates select="ROOT/rdf:RDF"/>
</xsl:template>

<xsl:template match="rdf:RDF">
  <xsl:text>var localBiblio = {&#xa;</xsl:text>
  <xsl:for-each select="rdf:Description[rdf:type/@rdf:resource='http://purl.org/dc/terms/BibliographicResource' and dct:identifier!='']"><xsl:sort select="dct:identifier"/>
    <xsl:apply-templates select="." mode="reference"/>
  </xsl:for-each>
  <xsl:text>}&#xa;</xsl:text>
</xsl:template>

</xsl:stylesheet>
