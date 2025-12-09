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

<xsl:output indent="yes"/>

<xsl:key name="resources" match="/ROOT/rdf:RDF/rdf:Description" use="@rdf:about|@rdf:nodeID"/>
<xsl:key name="mandatoryrole" match="/ROOT/rdf:RDF/rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/fbm#MandatoryConstraint']" use="fbm:restricts/(@rdf:resource|@rdf:nodeID)"/>
<xsl:key name="uniquerole" match="/ROOT/rdf:RDF/rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/fbm#UniquenessConstraint']" use="fbm:restricts/(@rdf:resource|@rdf:nodeID)"/>
<xsl:key name="predicatesubject" match="/ROOT/rdf:RDF/rdf:Description[fbm:atPosition=1]" use="fbm:role/(@rdf:resource|@rdf:nodeID)"/>
<xsl:key name="predicate" match="/ROOT/rdf:RDF/rdf:Description" use="fbm:ordersRole/(@rdf:resource|@rdf:nodeID)"/>

<xsl:key name="node-geo" match="/ROOT/graphml:graphml/graphml:graph/graphml:node" use="graphml:data[@key='d3']"/>
<xsl:key name="role-geo" match="/ROOT/graphml:graphml/graphml:graph/graphml:node/graphml:graph/graphml:node" use="graphml:data[@key='d3']"/>
<xsl:key name="edge-geo" match="/ROOT/graphml:graphml/graphml:graph/graphml:edge" use="graphml:data[@key='d7']"/>

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
  <xsl:apply-templates select="rdf:Description/fbm:subtypeOf" mode="subtype"/>
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/fbm#SubsetConstraint']" mode="constraint"/>
</xsl:template>

<xsl:template match="rdf:Description" mode="predicatereading">
  <xsl:choose>
    <xsl:when test="exists(rdfs:label)"><xsl:value-of select="rdfs:label"/></xsl:when> <!-- Shorthand notation, use this -->
    <xsl:when test="not(matches(fbm:text,'\[.+\]'))"><xsl:value-of select="fbm:text"/></xsl:when> <!-- Only when objecttypes are not mentioned! -->
    <xsl:otherwise/> <!-- Don't do anything in other cases - we will use predicate reading on the whole fact type -->
  </xsl:choose>
</xsl:template>

<xsl:template match="rdf:Description" mode="group">
    <xsl:variable name="group-uri"><xsl:value-of select="@rdf:about"/></xsl:variable>
    <xsl:variable name="group-geo" select="key('node-geo',$group-uri)"/>
    <node id="{@rdf:about}">
  		<data key="d3"><xsl:value-of select="@rdf:about"/></data>
  		<data key="d6" yfiles.foldertype="group">
        <y:ProxyAutoBoundsNode>
          <y:Realizers active="0">
            <!-- Group node expanded (normal situation) -->
            <y:GroupNode>
              <xsl:choose>
                <xsl:when test="exists($group-geo/graphml:data/y:ProxyAutoBoundsNode/y:Realizers/y:GroupNode[y:State/@closed='false']/y:Geometry)"><xsl:copy-of select="$group-geo/graphml:data/y:ProxyAutoBoundsNode/y:Realizers/y:GroupNode[y:State/@closed='false']/y:Geometry"/></xsl:when>
      				  <xsl:otherwise><y:Geometry height="60.0" width="90.0" x="316.0" y="379.0"/></xsl:otherwise>
              </xsl:choose>
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
              <xsl:variable name="label"><xsl:apply-templates select="." mode="label"/></xsl:variable>
              <xsl:if test="rdf:type/@rdf:resource!='http://bp4mc2.org/def/fbm#Facttype' or $label!=@rdf:about">
                <y:NodeLabel alignment="center" autoSizePolicy="node_width" borderDistance="0.0" fontFamily="Dialog" fontSize="15" fontStyle="plain" hasBackgroundColor="false" hasLineColor="false" height="21.666015625" horizontalTextPosition="center" iconTextGap="4" modelName="sides" modelPosition="n" textColor="#000000" verticalTextPosition="bottom" visible="true" width="90.0" x="0.0" xml:space="preserve" y="-21.666015625"><xsl:apply-templates select="." mode="label"/></y:NodeLabel>
              </xsl:if>
              <xsl:variable name="rolepredicate">
                <xsl:for-each select="key('resources',key('resources',fbm:predicate/(@rdf:resource|@rdf:nodeID))/fbm:reading/(@rdf:resource|@rdf:nodeID))">
                  <xsl:apply-templates select="." mode="predicatereading"/>
                </xsl:for-each>
              </xsl:variable>
              <xsl:if test="$rolepredicate=''">
                <!-- Predicate reading(s) below the whole fact type -->
                <xsl:variable name="predicate">
                  <xsl:for-each select="key('resources',key('resources',fbm:predicate/(@rdf:resource|@rdf:nodeID))/fbm:reading/(@rdf:resource|@rdf:nodeID))">
                    <xsl:if test="position()!=1"><xsl:text>&#x0a;</xsl:text></xsl:if>
                    <xsl:value-of select="fbm:text"/>
                  </xsl:for-each>
                </xsl:variable>
                <y:NodeLabel alignment="center" autoSizePolicy="content" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasBackgroundColor="false" hasLineColor="false" height="18.1328125" horizontalTextPosition="center" iconTextGap="4" modelName="sides" modelPosition="s" textColor="#000000" verticalTextPosition="bottom" visible="true" width="197.0546875" x="-39.01025390625" xml:space="preserve" y="70.0"><xsl:value-of select="$predicate"/></y:NodeLabel>
              </xsl:if>
              <y:State closed="false" closedHeight="60" closedWidth="100" innerGraphDisplayEnabled="false"/>
              <xsl:choose>
                <xsl:when test="rdf:type/@rdf:resource='http://bp4mc2.org/def/fbm#Facttype'">
                  <y:Insets bottom="5" bottomF="5.0" left="5" leftF="5.0" right="5" rightF="5.0" top="5" topF="5.0"/>
                </xsl:when>
                <xsl:otherwise>
                  <y:Insets bottom="15" bottomF="15.0" left="15" leftF="15.0" right="15" rightF="15.0" top="15" topF="15.0"/>
                </xsl:otherwise>
              </xsl:choose>
              <y:BorderInsets bottom="0" bottomF="0.0" left="0" leftF="0.0" right="0" rightF="0.0" top="0" topF="0.0"/>
            </y:GroupNode>
            <!-- Group node no details (alternative view) -->
            <y:GroupNode>
              <xsl:choose>
                <xsl:when test="exists($group-geo/graphml:data/y:ProxyAutoBoundsNode/y:Realizers/y:GroupNode[y:State/@closed='true']/y:Geometry)"><xsl:copy-of select="$group-geo/graphml:data/y:ProxyAutoBoundsNode/y:Realizers/y:GroupNode[y:State/@closed='true']/y:Geometry"/></xsl:when>
      				  <xsl:otherwise><y:Geometry height="60.0" width="90.0" x="316.0" y="379.0"/></xsl:otherwise>
              </xsl:choose>
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
          <xsl:variable name="role-uri">
            <xsl:choose>
              <xsl:when test="@rdf:about!=''"><xsl:value-of select="@rdf:about"/></xsl:when>
              <xsl:when test="fbm:playedBy/@rdf:resource!=''"><xsl:value-of select="$group-uri"/>:<xsl:value-of select="fbm:playedBy/@rdf:resource"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="rdf:nodeID"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="role-geo" select="key('role-geo',$role-uri)"/>
          <xsl:variable name="xpos">
            <xsl:choose>
              <xsl:when test="$role-geo/graphml:data/y:ShapeNode/y:Geometry/@x!=''"><xsl:value-of select="$role-geo/graphml:data/y:ShapeNode/y:Geometry/@x"/></xsl:when>
              <xsl:otherwise><xsl:value-of select="570+position()*30"/></xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="ypos">
            <xsl:choose>
              <xsl:when test="$role-geo/graphml:data/y:ShapeNode/y:Geometry/@y!=''"><xsl:value-of select="$role-geo/graphml:data/y:ShapeNode/y:Geometry/@y"/></xsl:when>
              <xsl:otherwise>455</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="width">
            <xsl:choose>
              <xsl:when test="$role-geo/graphml:data/y:ShapeNode/y:Geometry/@width!=''"><xsl:value-of select="$role-geo/graphml:data/y:ShapeNode/y:Geometry/@width"/></xsl:when>
              <xsl:otherwise>30</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <node id="{@rdf:about|@rdf:nodeID}">
            <data key="d3"><xsl:value-of select="$role-uri"/></data>
            <data key="d6">
              <y:ShapeNode>
                <xsl:choose>
                  <xsl:when test="exists($role-geo/graphml:data/y:ShapeNode/y:Geometry)"><xsl:copy-of select="$role-geo/graphml:data/y:ShapeNode/y:Geometry"/></xsl:when>
                  <xsl:otherwise><y:Geometry height="30" width="{$width}" x="{$xpos}" y="{$ypos}"/></xsl:otherwise>
                </xsl:choose>
                <y:Fill color="#FFCC00" transparent="false"/>
                <y:BorderStyle color="#000000" raised="false" type="line" width="1.0"/>
                <y:NodeLabel alignment="center" autoSizePolicy="content" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasBackgroundColor="false" hasLineColor="false" height="18.1328125" horizontalTextPosition="center" iconTextGap="4" modelName="custom" textColor="#000000" verticalTextPosition="bottom" visible="true" width="11.587890625" x="9.2060546875" xml:space="preserve" y="5.93359375"><xsl:value-of select="rdfs:label"/><y:LabelModel><y:SmartNodeLabelModel distance="4.0"/></y:LabelModel><y:ModelParameter><y:SmartNodeLabelModelParameter labelRatioX="0.0" labelRatioY="0.0" nodeRatioX="0.0" nodeRatioY="0.0" offsetX="0.0" offsetY="0.0" upX="0.0" upY="-1.0"/></y:ModelParameter></y:NodeLabel>
                <y:Shape type="rectangle"/>
                <xsl:variable name="predicatedirty">
                  <xsl:for-each select="key('resources',key('predicate',key('predicatesubject',(@rdf:about|@rdf:nodeID))/(@rdf:about|@rdf:nodeID))/fbm:reading/(@rdf:resource|@rdf:nodeID))">
                    <xsl:if test="position()!=1"><xsl:text>&#xa;</xsl:text></xsl:if>
                    <xsl:apply-templates select="." mode="predicatereading"/>
                  </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="predicate"><xsl:value-of select="replace(replace($predicatedirty,'[&#xa;]+','&#xa;'),'[&#xa;]$','')"/></xsl:variable>
                <xsl:if test="$predicate!=''">
                  <y:NodeLabel alignment="center" autoSizePolicy="content" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasBackgroundColor="false" hasLineColor="false" height="18.1328125" horizontalTextPosition="center" iconTextGap="4" modelName="sides" modelPosition="s" textColor="#000000" verticalTextPosition="bottom" visible="true" width="83.91015625" x="-7.8818359375" xml:space="preserve" y="34.0"><xsl:value-of select="$predicate"/></y:NodeLabel>
                </xsl:if>
              </y:ShapeNode>
            </data>
          </node>
          <xsl:for-each select="key('uniquerole',@rdf:about|@rdf:nodeID)"><xsl:sort select="@rdf:about|@rdf:nodeID"/>
            <node id="{@rdf:about|@rdf:nodeID}-{$roleposition}">
              <data key="d6">
                <y:ShapeNode>
                  <y:Geometry height="2" width="{$width}" x="{$xpos}" y="{$ypos - position()*6}"/>
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
  <xsl:variable name="node-geo" select="key('node-geo',@rdf:about|@rdf:nodeID)"/>
  <node id="{@rdf:about|@rdf:nodeID}">
    <data key="d3"><xsl:value-of select="@rdf:about|@rdf:nodeID"/></data>
    <data key="d6">
      <y:ShapeNode>
        <xsl:choose>
          <xsl:when test="exists($node-geo/graphml:data/y:ShapeNode/y:Geometry)"><xsl:copy-of select="$node-geo/graphml:data/y:ShapeNode/y:Geometry"/></xsl:when>
          <xsl:otherwise><y:Geometry height="30" width="30" x="570" y="455"/></xsl:otherwise>
        </xsl:choose>
        <y:Fill color="#F5F5F5" transparent="false"/>
        <y:BorderStyle color="#000000" raised="false" type="dashed" width="1.0"/>
        <y:NodeLabel alignment="center" autoSizePolicy="content" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasBackgroundColor="false" hasLineColor="false" height="18.1328125" horizontalTextPosition="center" iconTextGap="4" modelName="custom" textColor="#000000" verticalTextPosition="bottom" visible="true" width="11.587890625" x="9.2060546875" xml:space="preserve" y="5.93359375"><xsl:apply-templates select="." mode="label"/><y:LabelModel><y:SmartNodeLabelModel distance="4.0"/></y:LabelModel><y:ModelParameter><y:SmartNodeLabelModelParameter labelRatioX="0.0" labelRatioY="0.0" nodeRatioX="0.0" nodeRatioY="0.0" offsetX="0.0" offsetY="0.0" upX="0.0" upY="-1.0"/></y:ModelParameter></y:NodeLabel>
        <xsl:variable name="values">
          <xsl:for-each select="key('resources',fbm:constraint/(@rdf:resource|@rdf:nodeID))[rdf:type/@rdf:resource='http://bp4mc2.org/def/fbm#ValueConstraint']/fbm:allowValue">
            <xsl:if test="position()!=1"><xsl:text>,</xsl:text></xsl:if>
            <xsl:value-of select="."/>
          </xsl:for-each>
        </xsl:variable>
        <xsl:if test="$values!=''">
          <y:NodeLabel alignment="center" autoSizePolicy="content" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasBackgroundColor="false" hasLineColor="false" height="18.1328125" horizontalTextPosition="center" iconTextGap="4" modelName="corners" modelPosition="ne" textColor="#000000" verticalTextPosition="bottom" visible="true" width="63.548828125" x="34.0" xml:space="preserve" y="-18.1328125"><xsl:text>{</xsl:text><xsl:value-of select="$values"/><xsl:text>}</xsl:text></y:NodeLabel>
        </xsl:if>
        <y:Shape type="ellipse"/>
      </y:ShapeNode>
    </data>
  </node>
</xsl:template>

<xsl:template match="rdf:Description" mode="edge">
  <xsl:variable name="targetarrow">
    <xsl:choose>
      <xsl:when test="rdf:type/@rdf:resource='http://bp4mc2.org/def/fbm#SupertypeRole'">white_delta</xsl:when>
      <xsl:when test="exists(key('mandatoryrole',@rdf:about|@rdf:nonde))">circle</xsl:when>
      <xsl:otherwise>none</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="statement-uri"><xsl:value-of select="@rdf:about|@rdf:nodeID"/></xsl:variable>
  <xsl:variable name="statement-geo" select="key('edge-geo',$statement-uri)"/>
  <xsl:if test="exists(key('resources',fbm:playedBy/@rdf:resource))">
    <edge id="{@rdf:about|@rdf:nodeID}" source="{@rdf:about|@rdf:nodeID}" target="{fbm:playedBy/@rdf:resource}">
      <data key="d7"><xsl:value-of select="$statement-uri"/></data>
      <data key="d8"><xsl:value-of select="@rdf:about|@rdf:nodeID"/></data>
      <data key="d10">
        <y:PolyLineEdge>
          <xsl:copy-of select="$statement-geo/graphml:data/y:PolyLineEdge/y:Path"/>
          <!-- <y:Path sx="0.0" sy="0.0" tx="0.0" ty="0.0"/> -->
          <y:LineStyle color="#000000" type="line" width="1.0"/>
          <y:Arrows source="none" target="{$targetarrow}"/>
          <y:BendStyle smoothed="false"/>
        </y:PolyLineEdge>
      </data>
    </edge>
  </xsl:if>
</xsl:template>

<xsl:template match="fbm:subtypeOf" mode="subtype">
  <xsl:variable name="statement-uri"><xsl:value-of select="../@rdf:about|@rdf:nodeID"/>.subtype</xsl:variable>
  <xsl:variable name="statement-geo" select="key('edge-geo',$statement-uri)"/>
  <edge id="{../@rdf:about|@rdf:nodeID}.subtype" source="{../@rdf:about|@rdf:nodeID}" target="{@rdf:resource|@rdf:nodeID}">
    <data key="d7"><xsl:value-of select="$statement-uri"/></data>
    <data key="d10">
      <y:PolyLineEdge>
        <xsl:copy-of select="$statement-geo/graphml:data/y:PolyLineEdge/y:Path"/>
        <!-- <y:Path sx="0.0" sy="0.0" tx="0.0" ty="0.0"/> -->
        <y:LineStyle color="#000000" type="line" width="1.0"/>
        <y:Arrows source="none" target="white_delta"/>
        <y:BendStyle smoothed="false"/>
      </y:PolyLineEdge>
    </data>
  </edge>
</xsl:template>

<xsl:template match="rdf:Description" mode="constraint">
  <xsl:variable name="constrainturi" select="@rdf:about|@rdf:nodeID"/>
  <!-- The constraint node -->
  <node id="{$constrainturi}">
    <data key="d3"/>
    <data key="d6">
      <y:ShapeNode>
        <y:Geometry height="20" width="20" x="400" y="455"/>
        <y:Fill color="#FFFFFF" transparent="false"/>
        <y:BorderStyle color="#000000" type="line" width="1.0"/>
        <y:NodeLabel alignment="center" autoSizePolicy="node_width" borderDistance="0.0" fontFamily="Dialog" fontSize="18" fontStyle="plain" hasBackgroundColor="false" hasLineColor="false" height="21.666015625" horizontalTextPosition="center" iconTextGap="4" modelName="internal" modelPosition="c" textColor="#000000" verticalTextPosition="bottom" visible="true" width="87.0" x="0.0" xml:space="preserve" y="13.6669921875">⊆</y:NodeLabel>
        <y:Shape type="ellipse"/>
      </y:ShapeNode>
    </data>
  </node>
  <!-- All edges to the constraint node -->
  <xsl:apply-templates select="key('resources',fbm:roleSequenceSubset/@rdf:nodeID)" mode="toconstraintedge">
    <xsl:with-param name="constraint" select="$constrainturi"/>
  </xsl:apply-templates>
  <!-- All edges from the constraint node -->
  <xsl:apply-templates select="key('resources',fbm:roleSequenceSuperset/@rdf:nodeID)" mode="fromconstraintedge">
    <xsl:with-param name="constraint" select="$constrainturi"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="rdf:Description" mode="fromconstraintedge">
  <xsl:param name="constraint"/>
  <xsl:variable name="role" select="rdf:first/(@rdf:resource|@rdf:nodeID)"/>
  <edge id="{$constraint}.to.{$role}" source="{$constraint}" target="{$role}">
    <data key="d10">
      <y:PolyLineEdge>
        <y:Path sx="0.0" sy="0.0" tx="0.0" ty="0.0"/>
        <y:LineStyle color="#000000" type="dashed" width="1.0"/>
        <y:Arrows source="none" target="standard"/>
        <y:BendStyle smoothed="false"/>
      </y:PolyLineEdge>
    </data>
  </edge>
  <xsl:apply-templates select="key('resources',rdf:rest/@rdf:nodeID)" mode="fromconstraintedge">
    <xsl:with-param name="constraint" select="$constraint"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="rdf:Description" mode="toconstraintedge">
  <xsl:param name="constraint"/>
  <xsl:variable name="role" select="rdf:first/(@rdf:resource|@rdf:nodeID)"/>
  <edge id="{$role}.to.{$constraint}" source="{$role}" target="{$constraint}">
    <data key="d10">
      <y:PolyLineEdge>
        <y:Path sx="0.0" sy="0.0" tx="0.0" ty="0.0"/>
        <y:LineStyle color="#000000" type="dashed" width="1.0"/>
        <y:Arrows source="none" target="none"/>
        <y:BendStyle smoothed="false"/>
      </y:PolyLineEdge>
    </data>
  </edge>
  <xsl:apply-templates select="key('resources',rdf:rest/@rdf:nodeID)" mode="toconstraintedge">
    <xsl:with-param name="constraint" select="$constraint"/>
  </xsl:apply-templates>
</xsl:template>

</xsl:stylesheet>
