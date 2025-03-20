# rdf2xml

## RDF to XML
Transforming RDF to XML, using XSL stylesheet to create the XML from the RDF/XML data

Usage:

```
java -jar rdf2xml <input1> <output.xml> <stylesheet.xsl> [params] [input2.xml]
```

The first input can be any RDF serialization. The second input is optional and must be a valid XML document. The RDF input will be serialized to XML and will be combined with the optional second XML input. The stylesheet should expect a `<ROOT>` XML node as the root of the XML document to parse. The params parameter will be added to the ROOT of the parseable XML, so it can be used in the stylesheet as parameter.

For example:

```
<ROOT params='params'>
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

## XML transformation
This library can also be used to transform a regular XML file into something else, using a stylesheet.

Usage:

```
java -jar rdf2xml -xml <input.xml> <output.xml> <stylesheet.xsl>
```
