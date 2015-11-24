<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*:level">
        <xsl:copy>
            <xsl:value-of select="min((number(.)+1, 4))"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="*:title">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
            <xsl:text>${caret}</xsl:text>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>