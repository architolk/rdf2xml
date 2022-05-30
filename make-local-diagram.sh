#!/bin/bash
cd local
shopt -s nullglob
for FILE in *.ttl
do
	echo "Create diagram for: ${FILE%.*}"
  java -jar ../target/rdf2xml.jar "$FILE" "${FILE%.*}.graphml" ../rdf2graphml.xsl
  java -jar ../target/rdf2xml.jar "$FILE" "${FILE%.*}-uml.graphml" ../rdf2uml-graphml.xsl
done
