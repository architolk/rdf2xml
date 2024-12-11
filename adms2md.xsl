<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:sh="http://www.w3.org/ns/shacl#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:skosthes="http://purl.org/iso25964/skos-thes#"
  xmlns:dct="http://purl.org/dc/terms/"
  xmlns:adms="http://www.w3.org/ns/adms#"
  xmlns:dcat="http://www.w3.org/ns/dcat#"
>

<xsl:key name="items" match="/ROOT/rdf:RDF/rdf:Description" use="@rdf:about"/>
<xsl:key name="bnodes" match="/ROOT/rdf:RDF/rdf:Description" use="@rdf:nodeID"/>
<xsl:key name="asset" match="/ROOT/rdf:RDF/rdf:Description" use="dcat:theme/@rdf:resource"/>
<xsl:key name="repo" match="/ROOT/rdf:RDF/rdf:Description" use="dcat:dataset/@rdf:resource"/>
<xsl:key name="member" match="/ROOT/rdf:RDF/rdf:Description" use="skos:member/@rdf:resource"/>

<xsl:variable name="params" select="/ROOT/@params"/>

<xsl:output method="text"/>

<xsl:template match="rdf:Description" mode="asset">
  <xsl:text>|</xsl:text><xsl:value-of select="key('items',dct:type/@rdf:resource)/rdfs:label"/>
  <xsl:text>|</xsl:text><xsl:value-of select="rdfs:label"/>
  <xsl:text>|</xsl:text><xsl:value-of select="key('repo',@rdf:about)/rdfs:label"/>
  <xsl:text>|</xsl:text>
  <xsl:for-each select="key('items',dcat:theme/@rdf:resource)">
    <xsl:if test="position()!=1"><xsl:text>, </xsl:text></xsl:if>
    <xsl:value-of select="rdfs:label"/>
  </xsl:for-each>
  <xsl:text>|</xsl:text><xsl:value-of select="dct:rightsHolder"/>
  <xsl:text>|</xsl:text><xsl:value-of select="dct:publisher"/>
  <xsl:text>|</xsl:text><xsl:value-of select="key('repo',@rdf:about)/rdfs:comment"/>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<xsl:template match="rdf:Description" mode="asset-theme">
  <xsl:text>|</xsl:text><xsl:value-of select="rdfs:label"/>
  <xsl:text>|</xsl:text><xsl:value-of select="key('items',skos:inScheme/@rdf:resource)/skos:prefLabel"/>
  <xsl:text>|</xsl:text><xsl:value-of select="key('member',@rdf:about)/skos:notation"/>
  <xsl:text>|</xsl:text><xsl:value-of select="key('items',key('asset',@rdf:about)/dct:type/@rdf:resource)/rdfs:label"/>
  <xsl:text>|</xsl:text><xsl:value-of select="key('asset',@rdf:about)/rdfs:label"/>
  <xsl:text>|</xsl:text><xsl:value-of select="key('asset',@rdf:about)/dct:rightsHolder"/>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<xsl:template match="/">
  <xsl:apply-templates select="ROOT/rdf:RDF"/>
</xsl:template>

<xsl:template match="rdf:RDF">
  <xsl:text># Metadataverzamelingen</xsl:text>
  <xsl:text>&#xa;&#xa;</xsl:text>
  <xsl:text>## Administraties</xsl:text>
  <xsl:text>&#xa;&#xa;</xsl:text>
  <xsl:text>Onderstaande tabel geeft de plek aan waar de betreffende metadata terecht komt: in welke administratie(s) wordt deze metadata bijgehouden en in welke applicatie(s) worden deze administraties geïmplementeerd. Deze informatie is informatief en volgt uit de architectuurproducten.</xsl:text>
  <xsl:text>&#xa;&#xa;</xsl:text>
  <xsl:text>Onderstaande kolommen dienen als volgt gelezen te worden:&#xa;</xsl:text>
  <xsl:text>- Soort administratie: dit betreft een administratie, registratie of kennisbank. In geval van een registratie of kennisbank is er slechts één applicatie, bij gewone administraties kunnen er meerdere implementaties zijn.&#xa;</xsl:text>
  <xsl:text>- Beschreven door: de partij die de metadata beschrijft. Er is altijd slechts één partij die de metadata beschrijft&#xa;</xsl:text>
  <xsl:text>- In beheer bij: de partij die de metadata beheert. In geval van een registratie of kennisbank is er precies één partij. Bij overige administraties kunnen er meerdere partijen zijn, voor elke applicatie één. In dat geval is deze kolom leeg.&#xa;</xsl:text>
  <xsl:text>&#xa;&#xa;</xsl:text>
  <xsl:text>|Soort administratie|Metadata|Applicatie   |Thema's|Beschreven door|In beheer bij|Toelichting|&#xa;</xsl:text>
  <xsl:text>|-------------------|--------|-------------|-------|---------------|-------------|-----------|&#xa;</xsl:text>
  <xsl:for-each select="rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/ns/adms#Asset']"><xsl:sort select="rdfs:label"/>
    <xsl:apply-templates select="." mode="asset"/>
  </xsl:for-each>
  <xsl:if test="exists(rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/2004/02/skos/core#Concept' and not(exists(key('asset',@rdf:about)))])">
    <xsl:text>&#xa;&#xa;</xsl:text>
    <xsl:text>De volgende metadata-begrippen zijn nog niet toebedeeld:</xsl:text>
    <xsl:text>&#xa;&#xa;</xsl:text>
    <xsl:for-each select="rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/2004/02/skos/core#Concept' and not(exists(key('asset',@rdf:about)))]"><xsl:sort select="rdfs:label"/>
      <xsl:text>- </xsl:text>
      <xsl:value-of select="rdfs:label"/>
      <xsl:text>&#xa;</xsl:text>
    </xsl:for-each>
  </xsl:if>
  <xsl:text>&#xa;&#xa;</xsl:text>
  <xsl:text>## Thema's</xsl:text>
  <xsl:text>&#xa;&#xa;</xsl:text>
  <xsl:text>Onderstaande tabel geeft een overzicht van alle metadata-thema's en de toebedeling aan een administratie</xsl:text>
  <xsl:text>&#xa;&#xa;</xsl:text>
  <xsl:text>|Thema|Groep|Soort metadata|Soort administratie|Metadata|Beschreven door|&#xa;</xsl:text>
  <xsl:text>|-----|-----|--------------|-------------------|--------|---------------|&#xa;</xsl:text>
  <xsl:for-each select="rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/2004/02/skos/core#Concept' and exists(key('asset',@rdf:about)/rdfs:label)]"><xsl:sort select="key('items',skos:inScheme/@rdf:resource)/rdfs:label"/><xsl:sort select="rdfs:label"/>
    <xsl:apply-templates select="." mode="asset-theme"/>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
