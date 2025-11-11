<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:xmi="http://schema.omg.org/spec/XMI/2.1"
  xmlns:uml="http://schema.omg.org/spec/UML/2.1"
  xmlns:thecustomprofile="http://www.sparxsystems.com/profiles/thecustomprofile/1.0"

  exclude-result-prefixes="xsl xs rdf rdfs skos"
>

<xsl:output indent="yes"/>

<xsl:key name="concepts" match="/ROOT/rdf:RDF/rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/2004/02/skos/core#Concept']" use="@rdf:about"/>

<xsl:template match="/">
  <xmi:XMI xmi:version="2.1">
    <!-- <xmi:Documentation exporter="Enterprise Architect" exporterVersion="6.5" exporterID="1554"/> -->
  	<uml:Model xmi:type="uml:Model" name="EA_Model" visibility="public">
      <packagedElement xmi:type="uml:Package" xmi:id="urn:name:package" name="Begrippen" visibility="public">
        <xsl:apply-templates select="ROOT/rdf:RDF"/>
      </packagedElement>
    </uml:Model>
  </xmi:XMI>
</xsl:template>

<xsl:template match="rdf:RDF">
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/2004/02/skos/core#Concept']" mode="class"/>
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/2004/02/skos/core#Concept']" mode="association"/>
</xsl:template>

<xsl:template match="rdf:Description" mode="class">
  <xsl:variable name="source" select="@rdf:about"/>
  <xsl:variable name="name">
    <xsl:choose>
      <xsl:when test="rdfs:label[1]!=''"><xsl:value-of select="rdfs:label[1]"/></xsl:when>
      <xsl:when test="skos:prefLabel[1]!=''"><xsl:value-of select="skos:prefLabel[1]"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="@rdf:about"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <packagedElement xmi:type="uml:Class" xmi:id="{@rdf:about}" name="{$name}" visibility="public">
    <!-- Almost identical code at association -->
    <xsl:for-each select="skos:definition">
      <ownedComment xmi:id="{@rdf:about}-def{position()}" body="{.}"/>
    </xsl:for-each>
    <xsl:for-each select="*/@rdf:resource">
      <xsl:variable name="target" select="."/>
      <xsl:variable name="association-name" select="../name()"/>
      <xsl:variable name="association-id">urn:md5:<xsl:value-of select="concat($source,$association-name,$target)"/></xsl:variable>
      <xsl:if test="exists(key('concepts',$target))">
        <xsl:choose>
          <xsl:when test="../namespace-uri()='http://www.w3.org/2004/02/skos/core#' and ../local-name()='broader'">
            <generalization xmi:type="uml:Generalization" xmi:id="{$association-id}" general="{$target}"/>
          </xsl:when>
          <xsl:when test="../namespace-uri()='http://purl.org/iso25964/skos-thes#' and ../local-name()='broaderGeneric'">
            <generalization xmi:type="uml:Generalization" xmi:id="{$association-id}" general="{$target}"/>
          </xsl:when>
          <xsl:otherwise>
            <ownedAttribute xmi:type="uml:Property" xmi:id="{$association-id}:trgt" visibility="public" association="{$association-id}" isStatic="false" isReadOnly="false" isDerived="false" isOrdered="false" isUnique="true" isDerivedUnion="false" aggregation="none">
    					<type xmi:idref="{$target}"/>
    				</ownedAttribute>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:for-each>
  </packagedElement>
</xsl:template>

<xsl:template match="rdf:Description" mode="association">
  <xsl:variable name="source" select="@rdf:about"/>
  <!-- Almost identical code at class -->
  <xsl:for-each select="*/@rdf:resource">
    <xsl:variable name="target" select="."/>
    <xsl:variable name="association-name" select="../name()"/>
    <xsl:variable name="association-id">urn:md5:<xsl:value-of select="concat($source,$association-name,$target)"/></xsl:variable>
    <xsl:if test="exists(key('concepts',$target))">
      <xsl:choose>
        <xsl:when test="../namespace-uri()='http://www.w3.org/2004/02/skos/core#' and ../local-name()='broader'"/>
        <xsl:when test="../namespace-uri()='http://purl.org/iso25964/skos-thes#' and ../local-name()='broaderGeneric'"/>
        <xsl:otherwise>
          <packagedElement xmi:type="uml:Association" xmi:id="{$association-id}" name="{$association-name}" visibility="public">
    				<memberEnd xmi:idref="{$association-id}:trgt"/>
    				<memberEnd xmi:idref="{$association-id}:src"/>
            <!-- ownedEnd for the target has moved to ownedAttribute of the class - it is navigatable! -->
    				<ownedEnd xmi:type="uml:Property" xmi:id="{$association-id}:src" visibility="public" association="{$association-id}" isStatic="false" isReadOnly="false" isDerived="false" isOrdered="false" isUnique="true" isDerivedUnion="false" aggregation="none">
    					<type xmi:idref="{$source}"/>
    				</ownedEnd>
    			</packagedElement>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
