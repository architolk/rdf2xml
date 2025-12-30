<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:sh="http://www.w3.org/ns/shacl#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:skosthes="http://purl.org/iso25964/skos-thes#"
  xmlns:dct="http://purl.org/dc/terms/"
  xmlns:skosxl="http://www.w3.org/2008/05/skos-xl#"
>

<xsl:key name="items" match="/ROOT/rdf:RDF/rdf:Description" use="@rdf:about|@rdf:nodeID"/>
<xsl:key name="bnodes" match="/ROOT/rdf:RDF/rdf:Description" use="@rdf:nodeID"/>
<xsl:key name="terms" match="/ROOT/rdf:RDF/rdf:Description[skosxl:literalForm!='']" use="lower-case(skosxl:literalForm)"/>

<xsl:variable name="params" select="/ROOT/@params"/>

<xsl:output method="text"/>

<xsl:variable name="terms">
  <xsl:for-each select="/ROOT/rdf:RDF/rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/2004/02/skos/core#Concept']">
    <xsl:variable name="term"><xsl:apply-templates select="rdfs:label" mode="anchor"/></xsl:variable>
    <term term="{$term}">
      <literal><xsl:value-of select="$term"/></literal>
      <xsl:for-each select="key('items',key('terms',lower-case(rdfs:label))/skosxl:hiddenLabel/@rdf:resource)">
        <xsl:variable name="literal"><xsl:apply-templates select="skosxl:literalForm" mode="anchor"/></xsl:variable>
        <xsl:if test="$literal!=$term">
          <literal><xsl:value-of select="$literal"/></literal>
        </xsl:if>
      </xsl:for-each>
    </term>
  </xsl:for-each>
</xsl:variable>

<xsl:template match="*|@*|text()" mode="anchor">
  <xsl:value-of select="replace(replace(replace(lower-case(.),':',''),' ','-'),'-[-]+','-')"/>
</xsl:template>

<xsl:template match="rdf:Description" mode="link">
  <xsl:text>[</xsl:text><xsl:value-of select="rdfs:label"/><xsl:text>]</xsl:text>
  <xsl:text>(#</xsl:text><xsl:apply-templates select="rdfs:label" mode="anchor"/><xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="*" mode="definition">
  <xsl:for-each select="tokenize(.,'\[')">
    <xsl:variable name="token"><xsl:value-of select="substring-before(.,']')"/></xsl:variable>
    <xsl:variable name="anchor"><xsl:apply-templates select="$token" mode="anchor"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="position()=1"><xsl:value-of select="."/></xsl:when>
      <xsl:when test="$token!=''">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="$token"/>
        <xsl:text>](</xsl:text>
        <xsl:if test="exists($terms/term[literal=$anchor])"><xsl:text>#</xsl:text><xsl:value-of select="$terms/term[literal=$anchor][1]/@term"/></xsl:if>
        <xsl:text>)</xsl:text>
        <xsl:value-of select="substring-after(.,']')"/>
    </xsl:when>
      <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<xsl:template match="rdf:Description" mode="concept-row">
  <xsl:text>|</xsl:text>
  <xsl:apply-templates select="." mode="link"/>
  <xsl:text>|</xsl:text>
  <xsl:apply-templates select="skos:definition" mode="definition"/>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<xsl:template match="/">
  <xsl:apply-templates select="ROOT/rdf:RDF"/>
</xsl:template>

<xsl:template match="rdf:RDF">
  <xsl:text># Begrippenlijst</xsl:text>
  <xsl:text>&#xa;&#xa;</xsl:text>
  <xsl:text>|Begrip|Definitie|&#xa;</xsl:text>
  <xsl:text>|------|---------|&#xa;</xsl:text>
  <xsl:for-each select="rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/2004/02/skos/core#Concept']"><xsl:sort select="rdfs:label"/>
    <xsl:apply-templates select="." mode="concept-row"/>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
