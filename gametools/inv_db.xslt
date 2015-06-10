<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
		xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0">
  <xsl:output method="text"/>

  <xsl:template match="/">
    <xsl:text>function inventory_load ()&#xa;</xsl:text>
    <xsl:text>   inventory_ttx={&#xa;</xsl:text>
    <xsl:for-each select="//table:table-row[position()>1]">
      <xsl:if test="table:table-cell/text:p">
	<xsl:text>      {&#xa;</xsl:text>
	<xsl:for-each select="table:table-cell">
	  <xsl:if test="text:p/text()">
	    <xsl:text>         </xsl:text>
	    <xsl:value-of select="text:p"/>
	    <xsl:text>,&#xa;</xsl:text>
	  </xsl:if>
	</xsl:for-each>
	<xsl:text>      },&#xa;</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>   }&#xa;</xsl:text>
    <xsl:text>end&#xa;</xsl:text>
  </xsl:template>
</xsl:stylesheet>
