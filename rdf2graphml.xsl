<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:sh="http://www.w3.org/ns/shacl#"
  xmlns:y="http://www.yworks.com/xml/graphml"
>

<xsl:key name="items" match="/rdf:RDF/rdf:Description" use="@rdf:about"/>
<xsl:key name="blanks" match="/rdf:RDF/rdf:Description" use="@rdf:nodeID"/>

<xsl:template match="*" mode="label">
  <xsl:choose>
    <xsl:when test="rdfs:label!=''"><xsl:value-of select="rdfs:label"/></xsl:when>
    <xsl:when test="sh:name!=''"><xsl:value-of select="sh:name"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="@rdf:about|@rdf:nodeID"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="/">
	<graphml>
		<key attr.name="url" attr.type="string" for="node" id="d3"/>
		<key attr.name="url" attr.type="string" for="edge" id="d7"/>
		<key for="node" id="d6" yfiles.type="nodegraphics"/>
		<key for="edge" id="d10" yfiles.type="edgegraphics"/>
		<graph id="G" edgedefault="directed">
			<xsl:apply-templates select="rdf:RDF"/>
		</graph>
	</graphml>
</xsl:template>

<xsl:template match="rdf:RDF">
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/ns/shacl#NodeShape']" mode="node"/>
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://www.w3.org/ns/shacl#NodeShape']" mode="edge"/>
</xsl:template>

<xsl:template match="rdf:Description" mode="node">
  <node id="{@rdf:about}">
		<data key="d3"><xsl:value-of select="@rdf:about"/></data>
		<data key="d6">
			<y:GenericNode configuration="com.yworks.entityRelationship.big_entity">
				<y:Geometry height="90.0" width="80.0" x="637.0" y="277.0"/>
				<y:Fill color="#E8EEF7" color2="#B7C9E3" transparent="false"/>
				<y:BorderStyle color="#000000" type="line" width="1.0"/>
				<y:NodeLabel alignment="center" autoSizePolicy="content" backgroundColor="#B7C9E3" configuration="com.yworks.entityRelationship.label.name" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasLineColor="false" height="18.1328125" horizontalTextPosition="center" iconTextGap="4" modelName="internal" modelPosition="t" textColor="#000000" verticalTextPosition="bottom" visible="true" width="44.25390625" x="17.873046875" y="4.0">
					<xsl:apply-templates select="." mode="label"/>
				</y:NodeLabel>
				<y:NodeLabel alignment="left" autoSizePolicy="content" configuration="com.yworks.entityRelationship.label.attributes" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasBackgroundColor="false" hasLineColor="false" height="46.3984375" horizontalTextPosition="center" iconTextGap="4" modelName="custom" textColor="#000000" verticalTextPosition="top" visible="true" width="65.541015625" x="2.0" y="30.1328125">
					<xsl:for-each select="key('blanks',sh:property/@rdf:nodeID)">
						<xsl:if test="position()!=1"><xsl:text>
</xsl:text></xsl:if><xsl:apply-templates select="." mode="label"/>
					</xsl:for-each>
				<y:LabelModel><y:ErdAttributesNodeLabelModel/></y:LabelModel><y:ModelParameter><y:ErdAttributesNodeLabelModelParameter/></y:ModelParameter></y:NodeLabel>
			</y:GenericNode>
		</data>
	</node>
</xsl:template>

<xsl:template match="rdf:Description" mode="edge">
  <xsl:variable name="subject-uri"><xsl:value-of select="@rdf:about"/></xsl:variable>
  <xsl:for-each select="key('blanks',sh:property/@rdf:nodeID)[exists(key('items',sh:node/@rdf:resource))]">
    <edge source="{$subject-uri}" target="{sh:node/@rdf:resource}">
			<data key="d10">
				<xsl:element name="y:PolyLineEdge">
					<y:LineStyle color="#000000" type="line" width="1.0"/>
					<y:Arrows source="none" target="standard"/>
					<y:EdgeLabel alignment="center" backgroundColor="#FFFFFF" configuration="AutoFlippingLabel" distance="2.0" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasLineColor="false" modelName="custom" preferredPlacement="anywhere" ratio="0.5" textColor="#000000" visible="true"><xsl:apply-templates select="." mode="label"/><y:LabelModel>
							<y:SmartEdgeLabelModel autoRotationEnabled="false" defaultAngle="0.0" defaultDistance="10.0"/>
						</y:LabelModel>
						<y:ModelParameter>
							<y:SmartEdgeLabelModelParameter angle="0.0" distance="30.0" distanceToCenter="true" position="center" ratio="0.5" segment="0"/>
						</y:ModelParameter>
						<y:PreferredPlacementDescriptor angle="0.0" angleOffsetOnRightSide="0" angleReference="absolute" angleRotationOnRightSide="co" distance="-1.0" frozen="true" placement="anywhere" side="anywhere" sideReference="relative_to_edge_flow"/>
					</y:EdgeLabel>
					<y:BendStyle smoothed="false"/>
				</xsl:element>
			</data>
		</edge>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
