<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:sh="http://www.w3.org/ns/shacl#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:graphml="http://graphml.graphdrawing.org/xmlns"
  xmlns:y="http://www.yworks.com/xml/graphml"
>

<xsl:key name="items" match="/ROOT/rdf:RDF/rdf:Description" use="@rdf:about"/>
<xsl:key name="resources" match="/ROOT/rdf:RDF/rdf:Description" use="@rdf:about|@rdf:nodeID"/>
<xsl:key name="node-geo" match="/ROOT/graphml:graphml/graphml:graph/graphml:node" use="graphml:data[@key='d3']"/>
<xsl:key name="edge-geo" match="/ROOT/graphml:graphml/graphml:graph/graphml:edge" use="graphml:data[@key='d7']"/>

<xsl:variable name="params" select="/ROOT/@params"/>

<xsl:template match="rdf:Description" mode="label">
  <xsl:variable name="slabel"><xsl:value-of select="replace(@rdf:about|@rdf:nodeID,'^.*(#|/)([^(#|/)]+)$','$2')"/></xsl:variable>
  <xsl:choose>
    <xsl:when test="skos:prefLabel!=''"><xsl:value-of select="skos:prefLabel"/></xsl:when>
    <xsl:when test="rdfs:label!=''"><xsl:value-of select="rdfs:label"/></xsl:when>
    <xsl:when test="$slabel!=''"><xsl:value-of select="$slabel"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="@rdf:about|@rdf:nodeID"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>
<xsl:template match="*" mode="label">
  <xsl:choose>
    <xsl:when test="exists(key('resources',@rdf:resource|rdf:nodeID))"><xsl:apply-templates select="key('resources',@rdf:resource|rdf:nodeID)" mode="label"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="replace(@rdf:resource|@rdf:nodeID,'^.*(#|/)([^(#|/)]+)$','$2')"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rdf:Description" mode="definition">
  <xsl:choose>
    <xsl:when test="skos:definition!=''"><xsl:value-of select="skos:definition"/></xsl:when>
    <xsl:when test="rdfs:comment!=''"><xsl:value-of select="rdfs:comment"/></xsl:when>
    <xsl:otherwise />
  </xsl:choose>
</xsl:template>

<xsl:template match="/">
	<graphml>
		<key attr.name="url" attr.type="string" for="node" id="d3"/>
    <key attr.name="statement-url" attr.type="string" for="edge" id="d7"/>
    <key attr.name="url" attr.type="string" for="edge" id="d8"/>
		<key for="node" id="d6" yfiles.type="nodegraphics"/>
		<key for="edge" id="d10" yfiles.type="edgegraphics"/>
    <key for="graphml" id="d9" yfiles.type="resources"/>
		<graph id="G" edgedefault="directed">
			<xsl:apply-templates select="ROOT/rdf:RDF"/>
    </graph>
    <data key="d9">
      <y:Resources>
        <y:Resource id="1" xml:space="preserve">&lt;?xml version="1.0" encoding="UTF-8" standalone="no"?&gt;
&lt;!-- Created with Inkscape (http://www.inkscape.org/) --&gt;

&lt;svg
   width="58.871731mm"
   height="33.321747mm"
   viewBox="0 0 58.871731 33.321746"
   version="1.1"
   id="svg5"
   xml:space="preserve"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:svg="http://www.w3.org/2000/svg"&gt;&lt;defs
     id="defs2"&gt;&lt;clipPath
       clipPathUnits="userSpaceOnUse"
       id="clipPath43"&gt;&lt;path
         d="M 9.000031,66.2756 H 831.96003 v 463 H 9.000031 Z"
         id="path41" /&gt;&lt;/clipPath&gt;&lt;clipPath
       clipPathUnits="userSpaceOnUse"
       id="clipPath53"&gt;&lt;path
         d="M 9.000031,66.2756 H 832.00003 v 463 H 9.000031 Z"
         id="path51" /&gt;&lt;/clipPath&gt;&lt;clipPath
       clipPathUnits="userSpaceOnUse"
       id="clipPath302"&gt;&lt;path
         d="M 9.000031,66.2756 H 831.96003 v 463 H 9.000031 Z"
         id="path300" /&gt;&lt;/clipPath&gt;&lt;clipPath
       clipPathUnits="userSpaceOnUse"
       id="clipPath312"&gt;&lt;path
         d="M 9.000031,66.2756 H 832.00003 v 463 H 9.000031 Z"
         id="path310" /&gt;&lt;/clipPath&gt;&lt;/defs&gt;&lt;g
     id="g306"
     transform="matrix(0.35277777,0,0,-0.35277775,-84.367952,122.78507)"&gt;&lt;g
       id="g308"
       clip-path="url(#clipPath312)"&gt;&lt;path
         d="m 239.5819,275.9561 v 71.6674 h 166.019 l -0.7095,-72.377 c -0.2366,-16.202 -44.1061,20.4594 -73.0767,-4.2575 -28.9706,-24.717 -89.6313,-21.8787 -92.2328,4.9671 z"
         style="fill:#ffffff;fill-opacity:1;fill-rule:evenodd;stroke:none"
         id="path316" /&gt;&lt;g
         id="g318"
         transform="matrix(6.750328e-5,0,0,-6.751239e-5,239.5819,347.6235)"&gt;&lt;path
           d="M 0,1061545 V 0 h 2459421 l -10511,1072055 c -3504,239986 -653392,-303047 -1082565,63063 C 937172,1501228 38538,1459187 0,1061545 Z"
           style="fill:none;stroke:#000000;stroke-width:12700;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:8;stroke-dasharray:none;stroke-opacity:1"
           id="path320" /&gt;&lt;/g&gt;&lt;/g&gt;&lt;/g&gt;&lt;/svg&gt;
</y:Resource>
      </y:Resources>
    </data>
	</graphml>
</xsl:template>

<xsl:template match="rdf:RDF">
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/2004/02/skos/core#Concept']" mode="node"/>
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/2004/02/skos/core#Concept']" mode="edge"/>
</xsl:template>

<xsl:template match="rdf:Description" mode="node">
    <node id="{@rdf:about}">
  		<data key="d3"><xsl:value-of select="@rdf:about"/></data>
  		<data key="d6">
        <y:SVGNode>
          <xsl:variable name="geo" select="key('node-geo',@rdf:about)"/>
          <xsl:choose>
            <xsl:when test="exists($geo/graphml:data/y:GenericNode/y:Geometry)"><xsl:copy-of select="$geo/graphml:data/y:GenericNode/y:Geometry"/></xsl:when>
  				  <xsl:otherwise><y:Geometry height="90.0" width="80.0" x="637.0" y="277.0"/></xsl:otherwise>
          </xsl:choose>
  				<y:Fill color="#E8EEF7" color2="#B7C9E3" transparent="false"/>
  				<y:BorderStyle color="#000000" type="line" width="1.0"/>
  				<y:NodeLabel alignment="center" autoSizePolicy="content" backgroundColor="#B7C9E3" configuration="com.yworks.entityRelationship.label.name" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasLineColor="false" height="18.1328125" horizontalTextPosition="center" iconTextGap="4" modelName="internal" modelPosition="t" textColor="#000000" verticalTextPosition="bottom" visible="true" width="44.25390625" x="17.873046875" y="4.0">
  					<xsl:apply-templates select="." mode="label"/>
  				</y:NodeLabel>
  				<y:NodeLabel alignment="left" autoSizePolicy="node_size" configuration="CroppingLabel" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasBackgroundColor="false" hasLineColor="false" height="46.3984375" horizontalTextPosition="center" iconTextGap="4" modelName="custom" textColor="#000000" verticalTextPosition="top" visible="true" width="65.541015625" x="2.0" y="30.1328125">
            <xsl:apply-templates select="." mode="definition"/>
            <y:LabelModel><y:ErdAttributesNodeLabelModel/></y:LabelModel><y:ModelParameter><y:ErdAttributesNodeLabelModelParameter/></y:ModelParameter>
          </y:NodeLabel>
          <y:SVGNodeProperties usingVisualBounds="true"/>
          <y:SVGModel svgBoundsPolicy="0">
            <y:SVGContent refid="1"/>
          </y:SVGModel>
        </y:SVGNode>
  		</data>
  	</node>
</xsl:template>

<xsl:template match="rdf:Description" mode="edge">
  <xsl:variable name="subject-uri"><xsl:value-of select="@rdf:about"/></xsl:variable>
  <xsl:for-each select="*[exists(key('items',@rdf:resource))]">
    <xsl:variable name="object-uri"><xsl:value-of select="@rdf:resource"/></xsl:variable>
    <edge source="{$subject-uri}" target="{$object-uri}">
      <data key="d10">
        <y:PolyLineEdge>
          <y:LineStyle color="#000000" type="line" width="1.0"/>
          <y:Arrows source="none" target="standard"/>
          <y:EdgeLabel alignment="center" backgroundColor="#FFFFFF" configuration="AutoFlippingLabel" distance="2.0" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasLineColor="false" modelName="custom" preferredPlacement="anywhere" ratio="0.5" textColor="#000000" visible="true">
              <xsl:value-of select="local-name()"/><y:LabelModel>
              <y:SmartEdgeLabelModel autoRotationEnabled="false" defaultAngle="0.0" defaultDistance="10.0"/></y:LabelModel>
            <y:ModelParameter><y:SmartEdgeLabelModelParameter angle="0.0" distance="30.0" distanceToCenter="true" position="center" ratio="0.5" segment="0"/></y:ModelParameter>
            <y:PreferredPlacementDescriptor angle="0.0" angleOffsetOnRightSide="0" angleReference="absolute" angleRotationOnRightSide="co" distance="-1.0" frozen="true" placement="anywhere" side="anywhere" sideReference="relative_to_edge_flow"/>
          </y:EdgeLabel>
          <y:BendStyle smoothed="false"/>
        </y:PolyLineEdge>
      </data>
    </edge>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
