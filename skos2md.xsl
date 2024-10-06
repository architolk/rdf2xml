<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:sh="http://www.w3.org/ns/shacl#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:skosthes="http://purl.org/iso25964/skos-thes#"
  xmlns:dct="http://purl.org/dc/terms/"
>

<xsl:key name="items" match="/ROOT/rdf:RDF/rdf:Description" use="@rdf:about"/>
<xsl:key name="bnodes" match="/ROOT/rdf:RDF/rdf:Description" use="@rdf:nodeID"/>

<xsl:variable name="params" select="/ROOT/@params"/>

<xsl:output method="text"/>

<xsl:template match="rdf:Description" mode="link">
  <xsl:text>[</xsl:text><xsl:value-of select="rdfs:label"/><xsl:text>]</xsl:text>
  <xsl:text>(#</xsl:text><xsl:value-of select="replace(lower-case(rdfs:label),' ','-')"/><xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="rdf:Description" mode="scheme-content">
  <xsl:param name="level">2</xsl:param>
  <xsl:value-of select="substring('######',1,$level)"/><xsl:text> </xsl:text>
  <xsl:value-of select="rdfs:label"/>
  <xsl:text>&#xa;&#xa;</xsl:text>
  <xsl:if test="rdfs:comment!=''">
    <xsl:value-of select="rdfs:comment"/>
    <xsl:text>&#xa;&#xa;</xsl:text>
  </xsl:if>
  <xsl:if test="skos:editorialNote!=''">
    <xsl:text>*</xsl:text><xsl:value-of select="skos:editorialNote"/><xsl:text>*</xsl:text>
    <xsl:text>&#xa;&#xa;</xsl:text>
  </xsl:if>
  <xsl:variable name="uri" select="@rdf:about"/>
  <xsl:for-each select="../rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/2004/02/skos/core#ConceptScheme' and skos:inScheme/@rdf:resource=$uri]"><xsl:sort select="rdfs:label"/>
    <xsl:apply-templates select="." mode="scheme-content"><xsl:with-param name="level" select="$level+1"/></xsl:apply-templates>
  </xsl:for-each>
  <xsl:for-each select="../rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/2004/02/skos/core#Concept' and skos:inScheme/@rdf:resource=$uri]"><xsl:sort select="rdfs:label"/>
    <xsl:apply-templates select="." mode="concept-content"><xsl:with-param name="level" select="$level+1"/></xsl:apply-templates>
  </xsl:for-each>
</xsl:template>

<xsl:template match="rdf:Description" mode="source-label">
  <xsl:choose>
    <xsl:when test="dct:identifier!=''">
      <xsl:value-of select="rdfs:label"/>
      <xsl:text> [[</xsl:text><xsl:value-of select="dct:identifier"/><xsl:text>]]</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>[</xsl:text><xsl:value-of select="rdfs:label"/><xsl:text>]</xsl:text>
      <xsl:text>(</xsl:text><xsl:value-of select="dct:bibliographicCitation/@rdf:resource"/><xsl:text>)</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
<xsl:template match="rdf:Description" mode="source">
  <xsl:choose>
    <xsl:when test="dct:identifier!=''">
      <xsl:text> [[!</xsl:text><xsl:value-of select="dct:identifier"/><xsl:text>]]</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>[</xsl:text><xsl:value-of select="rdfs:label"/><xsl:text>]</xsl:text>
      <xsl:text>(</xsl:text><xsl:value-of select="dct:bibliographicCitation/@rdf:resource"/><xsl:text>)</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rdf:Description" mode="concept-content">
  <xsl:param name="level">3</xsl:param>
  <xsl:value-of select="substring('######',1,$level)"/><xsl:text> </xsl:text>
  <xsl:value-of select="rdfs:label"/>
  <xsl:text>&#xa;&#xa;</xsl:text>
  <xsl:if test="skos:altLabel[1]!=''">
    <xsl:text>Alternatieve aanduiding: </xsl:text>
    <xsl:for-each select="skos:altLabel">
      <xsl:if test="position()>1"><xsl:text>, </xsl:text></xsl:if>
      <xsl:text>*</xsl:text><xsl:value-of select="."/><xsl:text>*</xsl:text>
    </xsl:for-each>
    <xsl:text>&#xa;&#xa;</xsl:text>
  </xsl:if>
  <xsl:if test="skos:definition!=''">
    <xsl:text>&gt; </xsl:text>
    <xsl:value-of select="skos:definition"/>
    <xsl:text>&#xa;&#xa;</xsl:text>
  </xsl:if>
  <xsl:if test="skos:scopeNote!=''">
    <xsl:text>Toelichting: </xsl:text>
    <xsl:value-of select="skos:scopeNote"/>
    <xsl:text>&#xa;&#xa;</xsl:text>
  </xsl:if>
  <xsl:if test="rdfs:comment!=''">
    <xsl:text>Uitleg: </xsl:text>
    <xsl:value-of select="rdfs:comment"/>
    <xsl:text>&#xa;&#xa;</xsl:text>
  </xsl:if>
  <xsl:if test="skos:editorialNote!=''">
    <xsl:text>*</xsl:text><xsl:value-of select="skos:editorialNote"/><xsl:text>*</xsl:text>
    <xsl:text>&#xa;&#xa;</xsl:text>
  </xsl:if>
  <xsl:if test="exists(dct:source)">
    <xsl:text>Bron: </xsl:text>
    <xsl:for-each select="dct:source">
      <xsl:if test="position()>1"><xsl:text>, </xsl:text></xsl:if>
      <xsl:apply-templates select="key('items',@rdf:resource)" mode="source-label"/>
    </xsl:for-each>
    <xsl:text>&#xa;&#xa;</xsl:text>
  </xsl:if>
  <xsl:if test="exists(skosthes:broaderGeneric)">
    <xsl:text>Specialisatie van: </xsl:text>
    <xsl:for-each select="skosthes:broaderGeneric">
      <xsl:if test="position()>1"><xsl:text>, </xsl:text></xsl:if>
      <xsl:apply-templates select="key('items',@rdf:resource)" mode="link"/>
    </xsl:for-each>
    <xsl:text>&#xa;&#xa;</xsl:text>
  </xsl:if>
  <xsl:if test="exists(skosthes:narrowerGeneric)">
    <xsl:text>Generalisatie van: </xsl:text>
    <xsl:for-each select="skosthes:narrowerGeneric">
      <xsl:if test="position()>1"><xsl:text>, </xsl:text></xsl:if>
      <xsl:apply-templates select="key('items',@rdf:resource)" mode="link"/>
    </xsl:for-each>
    <xsl:text>&#xa;&#xa;</xsl:text>
  </xsl:if>
  <xsl:if test="exists(skosthes:broaderPartitive)">
    <xsl:text>Onderdeel van: </xsl:text>
    <xsl:for-each select="skosthes:broaderPartitive">
      <xsl:if test="position()>1"><xsl:text>, </xsl:text></xsl:if>
      <xsl:apply-templates select="key('items',@rdf:resource)" mode="link"/>
    </xsl:for-each>
    <xsl:text>&#xa;&#xa;</xsl:text>
  </xsl:if>
  <xsl:if test="exists(skosthes:narrowerPartitive)">
    <xsl:text>Omvat: </xsl:text>
    <xsl:for-each select="skosthes:narrowerPartitive">
      <xsl:if test="position()>1"><xsl:text>, </xsl:text></xsl:if>
      <xsl:apply-templates select="key('items',@rdf:resource)" mode="link"/>
    </xsl:for-each>
    <xsl:text>&#xa;&#xa;</xsl:text>
  </xsl:if>
  <xsl:if test="exists(skos:related)">
    <xsl:text>Gerelateerd: </xsl:text>
    <xsl:for-each select="skos:related">
      <xsl:if test="position()>1"><xsl:text>, </xsl:text></xsl:if>
      <xsl:apply-templates select="key('items',@rdf:resource)" mode="link"/>
    </xsl:for-each>
    <xsl:text>&#xa;&#xa;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="rdf:Description" mode="collection-toc-rec">
  <xsl:apply-templates select="key('items',rdf:first/@rdf:resource)" mode="collection-content"/>
  <xsl:apply-templates select="key('bnodes',rdf:rest/@rdf:nodeID)" mode="collection-toc-rec"/>
</xsl:template>

<xsl:template match="rdf:Description" mode="collection-toc">
  <xsl:text>## </xsl:text>
  <xsl:value-of select="rdfs:label"/>
  <xsl:text>&#xa;&#xa;</xsl:text>
  <xsl:if test="rdfs:comment!=''">
    <xsl:value-of select="rdfs:comment"/>
    <xsl:text>&#xa;&#xa;</xsl:text>
  </xsl:if>
  <xsl:apply-templates select="key('bnodes',skos:memberList/@rdf:nodeID)" mode="collection-toc-rec"/>
</xsl:template>

<xsl:template match="rdf:Description" mode="collection-content">
  <xsl:text>### </xsl:text>
  <xsl:value-of select="rdfs:label"/>
  <xsl:text>&#xa;&#xa;</xsl:text>
  <xsl:if test="rdfs:comment!=''">
    <xsl:value-of select="rdfs:comment"/>
    <xsl:text>&#xa;&#xa;</xsl:text>
  </xsl:if>
  <xsl:if test="exists(skos:example)">
    <xsl:text>Voorbeelden:&#xa;</xsl:text>
    <xsl:for-each select="skos:example"><xsl:sort select="."/>
      <xsl:text>- </xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>&#xa;</xsl:text>
    </xsl:for-each>
    <xsl:text>&#xa;</xsl:text>
  </xsl:if>
  <xsl:if test="exists(skos:member)">
    <xsl:text>Deze lijst bestaat uit de volgende elementen:&#xa;</xsl:text>
    <xsl:for-each select="key('items',skos:member/@rdf:resource)"><xsl:sort select="rdfs:label"/>
      <xsl:text>- </xsl:text>
      <xsl:value-of select="rdfs:label"/>
      <xsl:text>&#xa;</xsl:text>
    </xsl:for-each>
    <xsl:text>&#xa;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="rdf:Description" mode="conformance">
  <xsl:text>## </xsl:text>
  <xsl:value-of select="rdfs:label"/>
  <xsl:text>&#xa;&#xa;</xsl:text>
  <xsl:if test="rdfs:comment!=''">
    <xsl:value-of select="rdfs:comment"/>
    <xsl:text>&#xa;&#xa;</xsl:text>
  </xsl:if>
  <xsl:text>|Begrip|Conformance|Referentie|Standaard|&#xa;</xsl:text>
  <xsl:text>|------|-|-|---------|&#xa;</xsl:text>
  <xsl:for-each select="../rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/2004/02/skos/core#Concept' and exists(skos:exactMatch|skos:closeMatch|skos:broadMatch)]"><xsl:sort select="rdfs:label"/>
    <xsl:apply-templates select="." mode="conformance-statement"/>
  </xsl:for-each>
</xsl:template>

<xsl:template match="rdf:Description" mode="conformance-statement">
  <xsl:variable name="ref-label">
    <xsl:value-of select="key('items',(skos:exactMatch|skos:closeMatch|skos:broadMatch)/@rdf:resource)/rdfs:label"/>
  </xsl:variable>
  <xsl:if test="$ref-label!=''">
    <xsl:text>|</xsl:text>
    <xsl:value-of select="rdfs:label"/>
    <xsl:text>|</xsl:text>
    <xsl:choose>
      <xsl:when test="exists(skos:exactMatch)">exact gelijk aan</xsl:when>
      <xsl:when test="exists(skos:closeMatch)">vergelijkbaar met</xsl:when>
      <xsl:when test="exists(skos:broadMatch)">specifieke variant van</xsl:when>
      <xsl:otherwise />
    </xsl:choose>
    <xsl:text>|</xsl:text>
    <xsl:value-of select="$ref-label"/>
    <xsl:text>|</xsl:text>
    <xsl:apply-templates select="key('items',key('items',(skos:exactMatch|skos:closeMatch|skos:broadMatch)/@rdf:resource)/dct:conformsTo/@rdf:resource)" mode="source"/>
    <xsl:text>|&#xa;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="/">
  <xsl:apply-templates select="ROOT/rdf:RDF"/>
</xsl:template>

<xsl:template match="rdf:RDF">
  <xsl:text># Begrippen</xsl:text>
  <xsl:text>&#xa;&#xa;</xsl:text>
  <xsl:for-each select="rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/2004/02/skos/core#ConceptScheme' and not(exists(skos:inScheme))]"><xsl:sort select="rdfs:label"/>
    <xsl:apply-templates select="." mode="scheme-content"/>
  </xsl:for-each>
  <xsl:for-each select="rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/2004/02/skos/core#OrderedCollection']"><xsl:sort select="rdfs:label"/>
    <xsl:apply-templates select="." mode="collection-toc"/>
  </xsl:for-each>
  <!-- A bit of a hack to use prov:Entity and a dct:identifier... -->
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/ns/prov#Entity' and dct:identifier='CONFORMANCE']" mode="conformance"/>
</xsl:template>

</xsl:stylesheet>
