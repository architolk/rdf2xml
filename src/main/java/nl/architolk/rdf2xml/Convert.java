package nl.architolk.rdf2xml;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Paths;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import org.apache.jena.rdf.model.Model;
import org.apache.jena.riot.RDFDataMgr;
import org.apache.jena.riot.RDFFormat;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Convert {

  private static final String PREXML = "<ROOT>";
  private static final String POSTXML = "</ROOT>";

  private static final Logger LOG = LoggerFactory.getLogger(Convert.class);

  public static void main(String[] args) {

    if (args.length >= 3) {

      LOG.info("Input file: {}",args[0]);
      LOG.info("Ouput file: {}",args[1]);
      LOG.info("Stylesheet: {}",args[2]);

      if (args.length == 4) {
        LOG.info("2nd input:  {}",args[3]);
      }

      try {
        Model model = RDFDataMgr.loadModel(args[0]);
        // A better solution would be to use pipes in seperate threads
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        buffer.write(PREXML.getBytes());
        RDFDataMgr.write(buffer, model, RDFFormat.RDFXML_PLAIN);
        if (args.length == 4) {

          TransformerFactory tf = TransformerFactory.newInstance();
          Transformer transformer = tf.newTransformer();
          transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
          transformer.transform(new StreamSource(new File(args[3])), new StreamResult(buffer));
          //buffer.write(Files.readAllBytes(Paths.get(args[3])));
        }
        buffer.write(POSTXML.getBytes());
        XmlEngine.transform(new StreamSource(new ByteArrayInputStream(buffer.toByteArray())),new StreamSource(new File(args[2])),new StreamResult(new File(args[1])));
        LOG.info("Done!");
      }
      catch (Exception e) {
        LOG.error(e.getMessage(),e);
      }
    } else {
      LOG.warn("Usage: rdf2xml <input> <output.xml> <stylesheet.xsl> [input-2]");
    }
  }
}
