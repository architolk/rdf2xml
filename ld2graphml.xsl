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

<xsl:output method="xml" indent="yes"/>

<xsl:key name="resource" match="/ROOT/rdf:RDF/rdf:Description" use="@rdf:about|@rdf:nodeID"/>
<xsl:key name="node-geo" match="/ROOT/graphml:graphml/graphml:graph/graphml:node" use="graphml:data[@key='d3']"/>
<xsl:key name="edge-geo" match="/ROOT/graphml:graphml/graphml:graph/graphml:edge" use="graphml:data[@key='d7']"/>

<xsl:variable name="params" select="/ROOT/@params"/>

<xsl:template match="@*" mode="label">
  <xsl:value-of select="replace(.,'^.*(#|/)([^(#|/)]+)$','$2')"/>
</xsl:template>

<xsl:template match="rdf:Description" mode="label">
  <xsl:if test="@rdf:about!=''"> <!--Don't set a label for blank nodes -->
    <xsl:variable name="slabel"><xsl:value-of select="replace(@rdf:about|@rdf:nodeID,'^.*(#|/)([^(#|/)]+)$','$2')"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="sh:name!=''"><xsl:value-of select="sh:name"/></xsl:when>
      <xsl:when test="skos:notation!=''"><xsl:value-of select="skos:notation"/></xsl:when>
      <xsl:when test="rdfs:label!=''"><xsl:value-of select="rdfs:label"/></xsl:when>
      <xsl:when test="$slabel!=''"><xsl:value-of select="$slabel"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="@rdf:about|@rdf:nodeID"/></xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>
<!--
<xsl:template match="*" mode="label">
  <xsl:choose>
    <xsl:when test="exists(key('resources',@rdf:resource|rdf:nodeID))"><xsl:apply-templates select="key('resources',@rdf:resource|rdf:nodeID)" mode="label"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="replace(@rdf:resource|@rdf:nodeID,'^.*(#|/)([^(#|/)]+)$','$2')"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>
-->

<xsl:template match="*" mode="property-label">
  <xsl:value-of select="local-name()"/>
</xsl:template>

<xsl:template match="/">
	<graphml>
		<key attr.name="url" attr.type="string" for="node" id="d3"/>
    <key attr.name="statement-url" attr.type="string" for="edge" id="d7"/>
    <key attr.name="url" attr.type="string" for="edge" id="d8"/>
		<key for="node" id="d6" yfiles.type="nodegraphics"/>
		<key for="edge" id="d10" yfiles.type="edgegraphics"/>
		<graph id="G" edgedefault="directed">
			<xsl:apply-templates select="ROOT/rdf:RDF"/>
		</graph>
	</graphml>
</xsl:template>

<xsl:template match="rdf:RDF">
  <xsl:apply-templates select="rdf:Description" mode="node"/>
  <xsl:apply-templates select="rdf:Description" mode="edge"/>
</xsl:template>

<xsl:template match="rdf:Description" mode="node">
  <xsl:variable name="subject-uri" select="@rdf:about|@rdf:nodeID"/>
  <xsl:variable name="geo" select="key('node-geo',$subject-uri)"/>
  <node id="{$subject-uri}">
		<data key="d3"><xsl:value-of select="$subject-uri"/></data>
		<data key="d6">
      <y:ShapeNode>
        <xsl:choose>
          <xsl:when test="@rdf:nodeID!=''"><y:Geometry height="40.0" width="40.0" x="365.0" y="294.0"/></xsl:when>
          <xsl:otherwise><y:Geometry height="66.0" width="205.0" x="365.0" y="294.0"/></xsl:otherwise>
        </xsl:choose>
        <y:Fill color="#FFCC00" transparent="false"/>
        <y:BorderStyle color="#000000" raised="false" type="line" width="1.0"/>
        <y:NodeLabel alignment="center" autoSizePolicy="content" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasBackgroundColor="false" hasLineColor="false" height="18.1328125" horizontalTextPosition="center" iconTextGap="4" modelName="custom" textColor="#000000" verticalTextPosition="bottom" visible="true" width="32.11328125" x="86.443359375" xml:space="preserve" y="23.93359375"><xsl:apply-templates select="." mode="label"/><y:LabelModel><y:SmartNodeLabelModel distance="4.0"/></y:LabelModel><y:ModelParameter><y:SmartNodeLabelModelParameter labelRatioX="0.0" labelRatioY="0.0" nodeRatioX="0.0" nodeRatioY="0.0" offsetX="0.0" offsetY="0.0" upX="0.0" upY="-1.0"/></y:ModelParameter></y:NodeLabel>
        <y:Shape type="ellipse"/>
      </y:ShapeNode>
		</data>
	</node>
</xsl:template>

<xsl:template match="rdf:Description" mode="edge">
  <xsl:variable name="subject-uri" select="@rdf:about|@rdf:nodeID"/>
  <xsl:variable name="subject-geo" select="key('node-geo',$subject-uri)"/>
  <!-- Edges to resources that exist-->
  <xsl:for-each select="*[exists(key('resource',@rdf:resource|@rdf:nodeID))]">
    <xsl:variable name="object-uri" select="@rdf:resource|@rdf:nodeID"/>
    <xsl:variable name="property-uri" select="local-name()"/> <!-- Niet helemaal goed, dit is zonder de namespace -->
    <xsl:variable name="statement-uri"><xsl:value-of select="$subject-uri"/><xsl:value-of select="$property-uri"/><xsl:value-of select="$object-uri"/></xsl:variable>
    <edge source="{$subject-uri}" target="{$object-uri}">
      <data key="d7"><xsl:value-of select="$statement-uri"/></data>
      <data key="d8"><xsl:value-of select="$property-uri"/></data>
      <data key="d10">
        <y:PolyLineEdge>
          <y:Path sx="0.0" sy="0.0" tx="0.0" ty="0.0"/>
          <y:LineStyle color="#000000" type="line" width="1.0"/>
          <y:Arrows source="none" target="standard"/>
          <y:EdgeLabel alignment="center" anchorX="66.16976041841713" anchorY="44.44649798225862" backgroundColor="#FFFFFF" configuration="AutoFlippingLabel" distance="2.0" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasLineColor="false" height="18.1328125" horizontalTextPosition="center" iconTextGap="4" modelName="custom" preferredPlacement="anywhere" ratio="0.5" textColor="#000000" upX="0.4595559136184651" upY="-0.8881488401491598" verticalTextPosition="bottom" visible="true" width="65.658203125" x="66.16976041841713" xml:space="preserve" y="28.341861591741434"><xsl:apply-templates select="." mode="property-label"/><y:LabelModel><y:SmartEdgeLabelModel autoRotationEnabled="true" defaultAngle="0.0" defaultDistance="10.0"/></y:LabelModel><y:ModelParameter><y:SmartEdgeLabelModelParameter angle="0.0" distance="30.0" distanceToCenter="true" position="center" ratio="0.5" segment="0"/></y:ModelParameter><y:PreferredPlacementDescriptor angle="0.0" angleOffsetOnRightSide="0" angleReference="absolute" angleRotationOnRightSide="co" distance="-1.0" frozen="true" placement="anywhere" side="anywhere" sideReference="relative_to_edge_flow"/></y:EdgeLabel>
          <y:BendStyle smoothed="false"/>
        </y:PolyLineEdge>
      </data>
    </edge>
  </xsl:for-each>
  <!-- Edges to other non-blank node resources that don't exist-->
  <xsl:for-each select="*[exists(@rdf:resource) and (not(exists(key('resource',@rdf:resource))))]">
    <xsl:variable name="object-uri" select="@rdf:resource"/>
    <xsl:variable name="property-uri" select="local-name()"/> <!-- Niet helemaal goed, dit is zonder de namespace -->
    <xsl:variable name="statement-uri"><xsl:value-of select="$subject-uri"/><xsl:value-of select="$property-uri"/><xsl:value-of select="$object-uri"/></xsl:variable>
    <edge source="{$subject-uri}" target="{$object-uri}">
      <data key="d7"><xsl:value-of select="$statement-uri"/></data>
      <data key="d8"><xsl:value-of select="$property-uri"/></data>
      <data key="d10">
        <y:PolyLineEdge>
          <y:Path sx="0.0" sy="0.0" tx="0.0" ty="0.0"/>
          <y:LineStyle color="#000000" type="line" width="1.0"/>
          <y:Arrows source="none" target="standard"/>
          <y:EdgeLabel alignment="center" anchorX="66.16976041841713" anchorY="44.44649798225862" backgroundColor="#FFFFFF" configuration="AutoFlippingLabel" distance="2.0" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasLineColor="false" height="18.1328125" horizontalTextPosition="center" iconTextGap="4" modelName="custom" preferredPlacement="anywhere" ratio="0.5" textColor="#000000" upX="0.4595559136184651" upY="-0.8881488401491598" verticalTextPosition="bottom" visible="true" width="65.658203125" x="66.16976041841713" xml:space="preserve" y="28.341861591741434"><xsl:apply-templates select="." mode="property-label"/><y:LabelModel><y:SmartEdgeLabelModel autoRotationEnabled="true" defaultAngle="0.0" defaultDistance="10.0"/></y:LabelModel><y:ModelParameter><y:SmartEdgeLabelModelParameter angle="0.0" distance="30.0" distanceToCenter="true" position="center" ratio="0.5" segment="0"/></y:ModelParameter><y:PreferredPlacementDescriptor angle="0.0" angleOffsetOnRightSide="0" angleReference="absolute" angleRotationOnRightSide="co" distance="-1.0" frozen="true" placement="anywhere" side="anywhere" sideReference="relative_to_edge_flow"/></y:EdgeLabel>
          <y:BendStyle smoothed="false"/>
        </y:PolyLineEdge>
      </data>
    </edge>
    <node id="{$object-uri}">
  		<data key="d3"><xsl:value-of select="$object-uri"/></data>
  		<data key="d6">
        <y:ShapeNode>
          <y:Geometry height="66.0" width="205.0" x="365.0" y="294.0"/>
          <y:Fill color="#00CCFF" transparent="false"/>
          <y:BorderStyle color="#000000" raised="false" type="line" width="1.0"/>
          <y:NodeLabel alignment="center" autoSizePolicy="content" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasBackgroundColor="false" hasLineColor="false" height="18.1328125" horizontalTextPosition="center" iconTextGap="4" modelName="custom" textColor="#000000" verticalTextPosition="bottom" visible="true" width="32.11328125" x="86.443359375" xml:space="preserve" y="23.93359375"><xsl:apply-templates select="$object-uri" mode="label"/><y:LabelModel><y:SmartNodeLabelModel distance="4.0"/></y:LabelModel><y:ModelParameter><y:SmartNodeLabelModelParameter labelRatioX="0.0" labelRatioY="0.0" nodeRatioX="0.0" nodeRatioY="0.0" offsetX="0.0" offsetY="0.0" upX="0.0" upY="-1.0"/></y:ModelParameter></y:NodeLabel>
          <y:Shape type="ellipse"/>
        </y:ShapeNode>
  		</data>
  	</node>
  </xsl:for-each>
  <!-- Edges to literals-->
  <xsl:for-each select="*[not(exists(@rdf:resource|@rdf:nodeID))]">
    <xsl:variable name="object-uri" select="generate-id()"/>
    <xsl:variable name="property-uri" select="local-name()"/> <!-- Niet helemaal goed, dit is zonder de namespace -->
    <xsl:variable name="statement-uri"><xsl:value-of select="$subject-uri"/><xsl:value-of select="$property-uri"/><xsl:value-of select="$object-uri"/></xsl:variable>
    <edge source="{$subject-uri}" target="{$object-uri}">
      <data key="d7"><xsl:value-of select="$statement-uri"/></data>
      <data key="d8"><xsl:value-of select="$property-uri"/></data>
      <data key="d10">
        <y:PolyLineEdge>
          <y:Path sx="0.0" sy="0.0" tx="0.0" ty="0.0"/>
          <y:LineStyle color="#000000" type="line" width="1.0"/>
          <y:Arrows source="none" target="standard"/>
          <y:EdgeLabel alignment="center" anchorX="66.16976041841713" anchorY="44.44649798225862" backgroundColor="#FFFFFF" configuration="AutoFlippingLabel" distance="2.0" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasLineColor="false" height="18.1328125" horizontalTextPosition="center" iconTextGap="4" modelName="custom" preferredPlacement="anywhere" ratio="0.5" textColor="#000000" upX="0.4595559136184651" upY="-0.8881488401491598" verticalTextPosition="bottom" visible="true" width="65.658203125" x="66.16976041841713" xml:space="preserve" y="28.341861591741434"><xsl:apply-templates select="." mode="property-label"/><y:LabelModel><y:SmartEdgeLabelModel autoRotationEnabled="true" defaultAngle="0.0" defaultDistance="10.0"/></y:LabelModel><y:ModelParameter><y:SmartEdgeLabelModelParameter angle="0.0" distance="30.0" distanceToCenter="true" position="center" ratio="0.5" segment="0"/></y:ModelParameter><y:PreferredPlacementDescriptor angle="0.0" angleOffsetOnRightSide="0" angleReference="absolute" angleRotationOnRightSide="co" distance="-1.0" frozen="true" placement="anywhere" side="anywhere" sideReference="relative_to_edge_flow"/></y:EdgeLabel>
          <y:BendStyle smoothed="false"/>
        </y:PolyLineEdge>
      </data>
    </edge>
    <node id="{$object-uri}">
  		<data key="d3"><xsl:value-of select="$object-uri"/></data>
  		<data key="d6">
        <y:ShapeNode>
          <y:Geometry height="30.0" width="238.0" x="621.0" y="453.0"/>
          <y:Fill color="#FFCC00" transparent="false"/>
          <y:BorderStyle color="#000000" raised="false" type="line" width="1.0"/>
          <y:NodeLabel alignment="center" autoSizePolicy="node_width" configuration="CroppingLabel" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasBackgroundColor="false" hasLineColor="false" height="34.265625" horizontalTextPosition="center" iconTextGap="4" modelName="custom" textColor="#000000" verticalTextPosition="bottom" visible="true" width="238.0" x="0.0" xml:space="preserve" y="-2.1328125"><xsl:value-of select="."/><y:LabelModel><y:SmartNodeLabelModel distance="4.0"/></y:LabelModel><y:ModelParameter><y:SmartNodeLabelModelParameter labelRatioX="0.0" labelRatioY="0.0" nodeRatioX="0.0" nodeRatioY="0.0" offsetX="0.0" offsetY="0.0" upX="0.0" upY="-1.0"/></y:ModelParameter></y:NodeLabel>
          <y:Shape type="rectangle"/>
        </y:ShapeNode>
  		</data>
  	</node>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
