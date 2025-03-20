package nl.architolk.rdf2xml;

import nl.architolk.rdf2xml.rtf.RtfReader;
import nl.architolk.rdf2xml.rtf.RtfHtml;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.DocumentType;
import org.jsoup.safety.Cleaner;
import org.jsoup.safety.Safelist;

// Usage:
// <xsl:variable name="html" xmlns:Rtf2html="nl.architolk.rdf2xml.Rtf2html" select="Rtf2html:rtf2html(.)"/>
//
// Class is not used directly in the java code, but via the code above in the xsl stylesheet

public class Rtf2html {

    public static String rtf2html(String rtf) {
      try {
        RtfReader reader = new RtfReader();
        reader.parse(rtf.replace("<","&lt;"));
        RtfHtml formatter = new RtfHtml();

        Cleaner cleaner = new Cleaner(Safelist.relaxed().addAttributes(":all","class"));
        Document doc = cleaner.clean(Jsoup.parse(formatter.format(reader.root, true)));
        doc.outputSettings().syntax(Document.OutputSettings.Syntax.xml);
        return doc.html();

      } catch (Exception e) {
        return rtf;
      }
    }
}
