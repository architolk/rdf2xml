# rdf2xml
Transforming RDF to XML, using XSL stylesheet to create the XML from the RDF/XML data

Usage:

```
java -jar rdf2xml <input1> <output.xml> <stylesheet.xsl> [input2.xml]
```

The first input can be any RDF serialization. The second input is optional and must be a valid XML document. The RDF input will be serialized to XML and will be combined with the optional second XML input. The stylesheet should expect a `<ROOT>` XML node as the root of the XML document to parse.

For example:

```
<ROOT>
  <rdf:RDF>
    <rdf:Description rdf:about="urn:example">
      <rdfs:label>An example</rdfs:label>
    </rdf:Description>
  </rdf:RDF>
  <some-xml>
    <text>This is the content of the second input</text>
  </some-xml>
</ROOT>
```
