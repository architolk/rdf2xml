package nl.architolk.rdf2xml;

import java.security.MessageDigest;

// Usage:
// <xsl:variable name="hash" xmlns:Utils="nl.architolk.rdf2xml.Utils" select="Utils:md5(.)"/>
//
// Class is not used directly in the java code, but via the code above in the xsl stylesheet

public class Utils {

    private static String byteToHex(byte num) {
        char[] hexDigits = new char[2];
        hexDigits[0] = Character.forDigit((num >> 4) & 0xF, 16);
        hexDigits[1] = Character.forDigit((num & 0xF), 16);
        return new String(hexDigits);
    }

    private static String encodeHexString(byte[] byteArray) {
        StringBuffer hexStringBuffer = new StringBuffer();
        for (int i = 0; i < byteArray.length; i++) {
            hexStringBuffer.append(byteToHex(byteArray[i]));
        }
        return hexStringBuffer.toString();
    }

    public static String md5(String text) {
      try {
        MessageDigest md = MessageDigest.getInstance("MD5");
        md.update(text.getBytes());
        return encodeHexString(md.digest());

      } catch (Exception e) {
        return text;
      }
    }
}
