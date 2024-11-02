<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:sh="http://www.w3.org/ns/shacl#"
  xmlns:fbm="http://bp4mc2.org/def/fbm#"
  xmlns:graphml="http://graphml.graphdrawing.org/xmlns"
  xmlns:y="http://www.yworks.com/xml/graphml"
>

<xsl:key name="resources" match="/ROOT/rdf:RDF/rdf:Description" use="@rdf:about|@rdf:nodeID"/>
<xsl:key name="mandatoryrole" match="/ROOT/rdf:RDF/rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/fbm#MandatoryConstraint']" use="fbm:restricts/(@rdf:resource|@rdf:nodeID)"/>
<xsl:key name="uniquerole" match="/ROOT/rdf:RDF/rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/fbm#UniquenessConstraint']" use="fbm:restricts/(@rdf:resource|@rdf:nodeID)"/>

<xsl:variable name="params" select="/ROOT/@params"/>

<xsl:template match="rdf:Description" mode="label">
  <xsl:variable name="slabel"><xsl:value-of select="replace(@rdf:about|@rdf:nodeID,'^.*(#|/)([^(#|/)]+)$','$2')"/></xsl:variable>
  <xsl:choose>
    <xsl:when test="fbm:name!=''"><xsl:value-of select="fbm:name"/></xsl:when>
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
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/fbm#Objecttype']" mode="group"/>
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/fbm#Facttype']" mode="group"/>
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/fbm#Valuetype']" mode="node"/>
  <xsl:apply-templates select="key('resources',rdf:Description/fbm:role/(@rdf:nodeID|@rdf:resource))" mode="edge"/>
</xsl:template>

<xsl:template match="rdf:Description" mode="group">
    <node id="{@rdf:about}">
  		<data key="d3"><xsl:value-of select="@rdf:about"/></data>
  		<data key="d6" yfiles.foldertype="group">
        <y:ProxyAutoBoundsNode>
          <y:Realizers active="0">
            <y:GroupNode>
              <y:Geometry height="60.0" width="90.0" x="316.0" y="379.0"/>
              <y:Fill color="#F5F5F5" transparent="false"/>
              <xsl:choose>
                <xsl:when test="rdf:type/@rdf:resource='http://bp4mc2.org/def/fbm#Facttype'">
                  <y:Fill hasColor="false" transparent="false"/>
                  <y:BorderStyle hasColor="false" type="line" width="1.0"/>
                  <y:Shape type="rectangle"/>
                </xsl:when>
                <xsl:otherwise>
                  <y:Fill color="#F5F5F5" transparent="false"/>
                  <y:BorderStyle color="#000000" type="line" width="1.0"/>
                  <y:Shape type="ellipse"/>
                </xsl:otherwise>
              </xsl:choose>
              <y:NodeLabel alignment="center" autoSizePolicy="node_width" borderDistance="0.0" fontFamily="Dialog" fontSize="15" fontStyle="plain" hasBackgroundColor="false" hasLineColor="false" height="21.666015625" horizontalTextPosition="center" iconTextGap="4" modelName="sides" modelPosition="n" textColor="#000000" verticalTextPosition="bottom" visible="true" width="90.0" x="0.0" xml:space="preserve" y="-21.666015625"><xsl:apply-templates select="." mode="label"/></y:NodeLabel>
              <y:State closed="false" closedHeight="60" closedWidth="100" innerGraphDisplayEnabled="false"/>
              <y:Insets bottom="15" bottomF="15.0" left="15" leftF="15.0" right="15" rightF="15.0" top="15" topF="15.0"/>
              <y:BorderInsets bottom="0" bottomF="0.0" left="0" leftF="0.0" right="0" rightF="0.0" top="0" topF="0.0"/>
            </y:GroupNode>
            <y:GroupNode>
              <y:Geometry height="60.0" width="90.0" x="316.0" y="379.0"/>
              <xsl:choose>
                <xsl:when test="rdf:type/@rdf:resource='http://bp4mc2.org/def/fbm#Facttype'">
                  <y:Fill hasColor="false" transparent="false"/>
                  <y:BorderStyle hasColor="false" type="line" width="1.0"/>
                  <y:Shape type="rectangle"/>
                </xsl:when>
                <xsl:otherwise>
                  <y:Fill color="#F5F5F5" transparent="false"/>
                  <y:BorderStyle color="#000000" type="line" width="1.0"/>
                  <y:Shape type="ellipse"/>
                </xsl:otherwise>
              </xsl:choose>
              <y:NodeLabel alignment="center" autoSizePolicy="node_width" borderDistance="0.0" fontFamily="Dialog" fontSize="15" fontStyle="plain" hasBackgroundColor="false" hasLineColor="false" height="21.666015625" horizontalTextPosition="center" iconTextGap="4" modelName="internal" modelPosition="c" textColor="#000000" verticalTextPosition="bottom" visible="true" width="87.0" x="0.0" xml:space="preserve" y="13.6669921875"><xsl:apply-templates select="." mode="label"/></y:NodeLabel>
              <y:State closed="true" closedHeight="60" closedWidth="100" innerGraphDisplayEnabled="false"/>
              <y:Insets bottom="5" bottomF="5.0" left="5" leftF="5.0" right="5" rightF="5.0" top="5" topF="5.0"/>
              <y:BorderInsets bottom="0" bottomF="0.0" left="0" leftF="0.0" right="0" rightF="0.0" top="0" topF="0.0"/>
            </y:GroupNode>
          </y:Realizers>
        </y:ProxyAutoBoundsNode>
  		</data>
      <graph edgedefault="directed" id="{@rdf:about}:">
        <xsl:for-each select="key('resources',fbm:role/(@rdf:nodeID|@rdf:resource))">
          <xsl:variable name="roleposition"><xsl:value-of select="position()"/></xsl:variable>
          <xsl:variable name="xpos"><xsl:value-of select="570+position()*30"/></xsl:variable>
          <node id="{@rdf:about|@rdf:nodeID}">
            <data key="d3"/>
            <data key="d6">
              <y:ShapeNode>
                <y:Geometry height="30" width="30" x="{$xpos}" y="455"/>
                <y:Fill color="#FFCC00" transparent="false"/>
                <y:BorderStyle color="#000000" raised="false" type="line" width="1.0"/>
                <y:NodeLabel alignment="center" autoSizePolicy="content" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasBackgroundColor="false" hasLineColor="false" height="18.1328125" horizontalTextPosition="center" iconTextGap="4" modelName="custom" textColor="#000000" verticalTextPosition="bottom" visible="true" width="11.587890625" x="9.2060546875" xml:space="preserve" y="5.93359375"><xsl:value-of select="$roleposition"/><y:LabelModel><y:SmartNodeLabelModel distance="4.0"/></y:LabelModel><y:ModelParameter><y:SmartNodeLabelModelParameter labelRatioX="0.0" labelRatioY="0.0" nodeRatioX="0.0" nodeRatioY="0.0" offsetX="0.0" offsetY="0.0" upX="0.0" upY="-1.0"/></y:ModelParameter></y:NodeLabel>
                <y:Shape type="rectangle"/>
              </y:ShapeNode>
            </data>
          </node>
          <xsl:for-each select="key('uniquerole',@rdf:about|@rdf:nodeID)"><xsl:sort select="@rdf:about|@rdf:nodeID"/>
            <node id="{@rdf:about|@rdf:nodeID}-{$roleposition}">
              <data key="d6">
                <y:ShapeNode>
                  <y:Geometry height="2" width="30" x="{$xpos}" y="{455-position()*6}"/>
                  <y:Fill color="#000000" transparent="false"/>
                  <y:BorderStyle hascolor="false" type="line" width="1.0"/>
                  <y:Shape type="rectangle"/>
                </y:ShapeNode>
              </data>
            </node>
          </xsl:for-each>
        </xsl:for-each>
      </graph>
  	</node>
</xsl:template>

<xsl:template match="rdf:Description" mode="node">
  <node id="{@rdf:about|@rdf:nodeID}">
    <data key="d3"/>
    <data key="d6">
      <y:ShapeNode>
        <y:Geometry height="30" width="30" x="{570+position()*30}" y="455"/>
        <y:Fill color="#F5F5F5" transparent="false"/>
        <y:BorderStyle color="#000000" raised="false" type="dashed" width="1.0"/>
        <y:NodeLabel alignment="center" autoSizePolicy="content" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasBackgroundColor="false" hasLineColor="false" height="18.1328125" horizontalTextPosition="center" iconTextGap="4" modelName="custom" textColor="#000000" verticalTextPosition="bottom" visible="true" width="11.587890625" x="9.2060546875" xml:space="preserve" y="5.93359375"><xsl:apply-templates select="." mode="label"/><y:LabelModel><y:SmartNodeLabelModel distance="4.0"/></y:LabelModel><y:ModelParameter><y:SmartNodeLabelModelParameter labelRatioX="0.0" labelRatioY="0.0" nodeRatioX="0.0" nodeRatioY="0.0" offsetX="0.0" offsetY="0.0" upX="0.0" upY="-1.0"/></y:ModelParameter></y:NodeLabel>
        <y:Shape type="ellipse"/>
      </y:ShapeNode>
    </data>
  </node>
</xsl:template>

<xsl:template match="rdf:Description" mode="edge">
  <xsl:variable name="targetarrow">
    <xsl:choose>
      <xsl:when test="exists(key('mandatoryrole',@rdf:about|@rdf:nonde))">circle</xsl:when>
      <xsl:otherwise>none</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <edge id="{@rdf:about|@rdf:nodeID}" source="{@rdf:about|@rdf:nodeID}" target="{fbm:playedBy/@rdf:resource}">
    <data key="d10">
      <y:PolyLineEdge>
        <y:Path sx="0.0" sy="0.0" tx="0.0" ty="0.0"/>
        <y:LineStyle color="#000000" type="line" width="1.0"/>
        <y:Arrows source="none" target="{$targetarrow}"/>
        <y:BendStyle smoothed="false"/>
      </y:PolyLineEdge>
    </data>
  </edge>
</xsl:template>

</xsl:stylesheet>
