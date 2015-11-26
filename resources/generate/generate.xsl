<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs f" 
    xmlns:f="com.oxygenxml.ns/model2dita/functions" version="2.0"
    xpath-default-namespace="http://thinkdita.org/ns/model2dita">
    
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet">
        <xd:desc>
            <xd:p>Generate DITA project from a model descriptor.</xd:p>
        </xd:desc>        
    </xd:doc>
    
    <xsl:param name="outputFolder" select="resolve-uri('test', /)"/>
    
    <xsl:function name="f:getName" as="xs:string">
        <xsl:param name="value" as="xs:string"/>
        <xsl:value-of select="translate(lower-case($value), ' ', '-')"/>
    </xsl:function>
    
    <xsl:function name="f:getPrefix" as="xs:string">
        <xsl:param name="value" as="xs:string"/>
        <xsl:value-of select="concat(substring($value, 1, 1), '_')"/>
    </xsl:function>
    
    <xsl:function name="f:getTopicName" as="xs:string">
        <xsl:param name="topic" as="element()"></xsl:param>
        <xsl:value-of select="
                concat(
                    f:getPrefix($topic/type),
                    if ($topic/filename/text()) 
                        then $topic/filename 
                        else concat(f:getName($topic/title),'.dita')
                ) 
            "/>
    </xsl:function>
    
    
    <xsl:template match="/">
        <!--<xsl:comment>outputFolder was specified as <xsl:value-of select="$outputFolder"/></xsl:comment>-->
        <xsl:result-document href="{$outputFolder}/{f:getName(/model/projectname)}.ditamap"
            doctype-public="-//OASIS//DTD DITA Map//EN" doctype-system="map.dtd"
            indent="yes">
            <xsl:apply-templates mode="map"/>
        </xsl:result-document>
        <xsl:apply-templates select="/model/topic" mode="topic"/>
    </xsl:template>


    <xsl:template match="model" mode="map">
        <map>
            <xsl:attribute name="xml:lang" select="/model/language"/>
            <title><xsl:value-of select="/model/projectname"/></title>
            <xsl:apply-templates select="topic[level=1]" mode="map"/>
        </map>
    </xsl:template>

    <xsl:template match="topic" mode="map">
        <xsl:variable name="this" select="."/>
        <xsl:variable name="level" select="level" as="xs:decimal"/>
        <xsl:variable name="nextLevel" select="$level + 1" as="xs:decimal"/>
        <topicref href="source/{f:getTopicName(.)}">
            <xsl:apply-templates select="
                following-sibling::topic[level=$nextLevel]
                    [preceding-sibling::topic[level=$level][1][. is $this]]"
                mode="map"/>
        </topicref>
    </xsl:template>
    
    <xsl:template match="topic" mode="topic">
        <xsl:result-document href="{$outputFolder}/source/{f:getTopicName(.)}"
            doctype-public="-//OASIS//DTD DITA Topic//EN" doctype-system="topic.dtd">
            <topic id="topic">
                <title><xsl:value-of select="title"/></title>
            </topic>            
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="topic[type='concept']" mode="topic">
        <xsl:result-document href="{$outputFolder}/source/{f:getTopicName(.)}"
            doctype-public="-//OASIS//DTD DITA Concept//EN" doctype-system="concept.dtd">
            <concept id="concept">
                <title><xsl:value-of select="title"/></title>
                <conbody>
                    <p></p>
                </conbody>
            </concept>            
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="topic[type='task']" mode="topic">
        <xsl:result-document href="{$outputFolder}/source/{f:getTopicName(.)}"
            doctype-public="-//OASIS//DTD DITA Task//EN" doctype-system="task.dtd">
            <task id="task">
                <title><xsl:value-of select="title"/></title>
                <taskbody>
                    <context>
                        <p/>
                    </context>
                    <steps>
                        <step>
                            <cmd/>
                        </step>
                    </steps>
                </taskbody>
            </task>            
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="topic[type='reference']" mode="topic">
        <xsl:result-document href="{$outputFolder}/source/{f:getTopicName(.)}"
            doctype-public="-//OASIS//DTD DITA Reference//EN" doctype-system="reference.dtd">
            <reference id="reference">
                <title><xsl:value-of select="title"/></title>
                <refbody>
                    <section>
                        <p></p>
                    </section>
                </refbody>
            </reference>            
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="topic[type='glossentry']" mode="topic">
        <xsl:result-document href="{$outputFolder}/source/{f:getTopicName(.)}"
            doctype-public="-//OASIS//DTD DITA Glossary//EN" doctype-system="glossary.dtd">
            <glossentry id="glossentry">
                <glossterm><xsl:value-of select="title"/></glossterm>
                <glossdef></glossdef>
            </glossentry>            
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>