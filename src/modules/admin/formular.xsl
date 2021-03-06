<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ev="http://www.w3.org/2001/xml-events" xmlns:exist="http://exist.sourceforge.net/NS/exist" xmlns:xf="http://www.w3.org/2002/xforms" xmlns:sade="http://bbaw.de/sade" version="2.0">
    <xsl:param name="lang"/>
    <xsl:param name="id"/>
    <xsl:variable name="language">
        <xsl:value-of select="doc('resources/language.xml')//sade:lang[@id=$lang]"/>
    </xsl:variable>
    <xsl:template match="/">
        <xsl:if test="$id='general'">
            <h1>
                <xf:value ref="instance('lang')/sade:lang[@id='{$lang}']/sade:meta/sade:h"/>
            </h1>
            <xf:input ref="instance('sade_config')/sade:meta/sade:project_name" id="projectname" incremental="true">
                <xf:label ref="instance('lang')/sade:lang[@id='{$lang}']/sade:meta/sade:project_name/sade:title"/>
                <xf:hint ref="instance('lang')/sade:lang[@id='{$lang}']/sade:meta/sade:project_name/sade:hint"/>
                <xf:alert ref="instance('lang')/sade:lang[@id='{$lang}']/sade:general/sade:requiredField"/>
            </xf:input>
            <xf:select appearance="full" ref="/sade:SADE_project/sade:meta/sade:default_project">
                <xf:label ref="instance('lang')/sade:lang[@id='{$lang}']/sade:meta/sade:default_project/sade:title"/>
                <xf:hint ref="instance('lang')/sade:lang[@id='{$lang}']/sade:meta/sade:default_project/sade:hint"/>
                <xf:item>
                    <xf:label/>
                    <xf:value>true</xf:value>
                </xf:item>
            </xf:select>
            <xf:textarea ref="/sade:SADE_project/sade:meta/sade:description" id="descr">
                <xf:label ref="instance('lang')/sade:lang[@id='{$lang}']/sade:meta/sade:description/sade:title"/>
                <xf:hint ref="instance('lang')/sade:lang[@id='{$lang}']/sade:meta/sade:description/sade:hint"/>
            </xf:textarea>
        </xsl:if>
        <xsl:if test="$id='design'">
            <h1>Design</h1>
            <h2>Theme</h2>
            <xf:select1 appearance="minimal" ref="/sade:SADE_project/sade:design/sade:theme">
                <xf:label ref="instance('lang')/sade:lang[@id='{$lang}']/sade:design/sade:theme/sade:title"/>
                <xf:itemset nodeset="instance('themes')/exist:collection/exist:collection">
                    <xf:label ref="./@name"/>
                    <xf:value ref="./@name"/>
                </xf:itemset>
            </xf:select1>
            <xf:select appearance="full" ref="/sade:SADE_project/sade:design/sade:fluid">
                <xf:label ref="instance('lang')/sade:lang[@id='{$lang}']/sade:design/sade:fluid/sade:title"/>
                <xf:hint ref="instance('lang')/sade:lang[@id='{$lang}']/sade:design/sade:fluid/sade:hint"/>
                <xf:item>
                    <xf:label/>
                    <xf:value>true</xf:value>
                </xf:item>
            </xf:select>
            <xf:textarea ref="/sade:SADE_project/sade:design/sade:css" id="css">
                <xf:label ref="instance('lang')/sade:lang[@id='{$lang}']/sade:design/sade:css/sade:title"/>
                <xf:hint ref="instance('lang')/sade:lang[@id='{$lang}']/sade:design/sade:css/sade:hint"/>
            </xf:textarea>
            <h2>Footer</h2>
            <xf:upload id="upload1" ref="/sade:SADE_project/sade:design/sade:footer/sade:img">
                <xf:label>Logo hochladen:</xf:label>
            </xf:upload>
            <xf:output value="/sade:SADE_project/sade:design/sade:footer/sade:img/replace(., '%5C', '/')">
                <xf:label>URL:</xf:label>
            </xf:output>
            <xf:output class="image" value="/sade:SADE_project/sade:design/sade:footer/sade:img/replace(., '%5C', '/')" mediatype="image/*">
                    <!-- base64 Encoding scheint für die URL dann den Effekt zu haben Slashes als Backshlashes zu dekodieren, daher der replace -->
                <xf:label>Aktuelles Logo</xf:label>
            </xf:output>
            <xf:input ref="/sade:SADE_project/sade:design/sade:footer/sade:url">
                <xf:label ref="instance('lang')/sade:lang[@id='{$lang}']/sade:design/sade:footer/sade:url/sade:title"/>
                <xf:hint ref="instance('lang')/sade:lang[@id='{$lang}']/sade:design/sade:footer/sade:url/sade:hint"/>
            </xf:input>
        </xsl:if>
        <xsl:if test="$id='imprint'">
            <h1>Impressum</h1>
            <xf:textarea ref="/sade:SADE_project/sade:imprint/sade:publisher">
                <xf:label>Herausgeber</xf:label>
            </xf:textarea>
            <xf:textarea ref="/sade:SADE_project/sade:imprint/sade:copyright">
                <xf:label>Urheberrecht</xf:label>
            </xf:textarea>
            <xf:textarea ref="/sade:SADE_project/sade:imprint/sade:privacy">
                <xf:label>Datenschutz</xf:label>
            </xf:textarea>
            <xf:textarea ref="/sade:SADE_project/sade:imprint/sade:otherlegal">
                <xf:label>Anderes</xf:label>
            </xf:textarea>
        </xsl:if>
        <xsl:if test="$id='edition' or $id='pages'">
            <h1>Digitale Edition</h1>
            <xf:repeat nodeset="/sade:SADE_project/sade:page/sade:content">
                <xf:input ref="sade:title">
                    <xf:label>Elementtitel</xf:label>
                </xf:input>
                <xf:input ref="sade:url">
                    <xf:label>URL der Collection:</xf:label>
                </xf:input>
                <xf:input ref="sade:xpath">
                    <xf:label>XPath des Elements:</xf:label>
                </xf:input>
                    <!--<xf:select ref="column">
                    <xf:label>Spalte</xf:label>
                    
                </xf:select>-->
            </xf:repeat>
            <xf:trigger id="insert" ref="instance('sade_config')//sade:content[last() &lt; 4]">
                <xf:label>Weitere Inhaltsspalte</xf:label>
                <xf:action ev:event="DOMActivate">
                    <xf:insert nodeset="/sade:SADE_project/sade:page/sade:content" position="after" at="last()"/>
                    <xf:setvalue ref="/sade:SADE_project/sade:page/sade:content[last()]/sade:column" value="''"/>
                    <xf:setvalue ref="/sade:SADE_project/sade:page/sade:content[last()]/sade:title" value="''"/>
                    <xf:setvalue ref="/sade:SADE_project/sade:page/sade:content[last()]/sade:url" value="''"/>
                    <xf:setvalue ref="/SADE_project/page/content[last()]/sade:xpath" value="''"/>
                </xf:action>
            </xf:trigger>
            <xf:trigger ref="instance('sade_config')//sade:content[last() &gt; 1]">
                <xf:label>Diesen Eintrag löschen</xf:label>
                <xf:delete nodeset="/sade:SADE_project/sade:page/sade:content" at="current()" ev:event="DOMActivate"/>
            </xf:trigger>
        </xsl:if>
        <xsl:if test="$id='description'">
            <h1>Projektbeschreibung</h1>
            <xf:input ref="/sade:SADE_project/sade:project/sade:title">
                <xf:label>Titel</xf:label>
            </xf:input>
            <xf:textarea ref="/sade:SADE_project/sade:project/sade:description">
                <xf:label>Urheberrecht</xf:label>
            </xf:textarea>
            <xf:textarea ref="/sade:SADE_project/sade:project/sade:contact">
                <xf:label>Datenschutz</xf:label>
            </xf:textarea>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>