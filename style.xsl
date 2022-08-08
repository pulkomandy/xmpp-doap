<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:doap="http://usefulinc.com/ns/doap#"
	xmlns:xmpp="https://linkmauve.fr/ns/xmpp-doap#"
	xmlns:schema="https://schema.org/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
>

<xsl:template match="doap:Project">
	<html>
		<head>
			<link href="../style.css" type="text/css" rel="stylesheet"/>
			<title><xsl:value-of select="doap:name"/> - XMPP implementation support</title>
		</head>
		<body>
			<div class="header">
				<h1><xsl:apply-templates select="schema:logo"/> <xsl:value-of select="doap:name"/></h1>
				<b><xsl:value-of select="doap:shortdesc"/></b>
				<p><xsl:value-of select="doap:description"/></p>
				<p>
					<xsl:apply-templates select="doap:homepage"/>
					<xsl:apply-templates select="doap:download-page"/>
					<xsl:apply-templates select="schema:documentation"/>
				</p>
			</div>

			<div class="os">
				<p>Supported operating systems</p>
				<xsl:apply-templates select="doap:os" />
			</div>

			<table>
				<tr><th>XEP</th><th>Name</th><th>Latest version</th><th>Version implemented</th><th>Status</th><th>Since</th><th>Notes</th></tr>
				<xsl:apply-templates select="doap:implements/*"/>
			</table>
		</body>
	</html>
</xsl:template>

<xsl:template match="schema:logo">
	<img src="{@rdf:resource}" alt="logo" width="96" height="96" />
</xsl:template>

<xsl:template match="doap:homepage">
	<a class="button" href="{@rdf:resource}">Website</a>
</xsl:template>

<xsl:template match="doap:download-page">
	<a class="button" href="{@rdf:resource}">Download</a>
</xsl:template>

<xsl:template match="schema:documentation">
	<a class="button" href="{@rdf:resource}">Documentation</a>
</xsl:template>

<xsl:template match="doap:os">
	<div class="chip">
		<xsl:value-of select="."/>
	</div>
</xsl:template>

<xsl:template match="xmpp:SupportedXep">
	<!--
		Get the definition of the XEP that this block refers to.
		We will use that to extract the details of the latest revision and
		the one that is implemented, so that we can show that info as well
		as check if it is the latest revision that is being used.
	-->
	<xsl:variable
		name="xepnumber"
		select="substring-before(substring-after(xmpp:xep/@rdf:resource, 'https://xmpp.org/extensions/xep-'), '.')"
	/>
	<xsl:variable
		name="xeplist"
		select="document('https://xmpp.org/extensions/xeplist.xml')"
	/>
	<xsl:variable
		name="xep-descriptor"
		select="$xeplist/xep[number/text() = number($xep-number)]"
	/>
	<tr>
		<td>
			<a href="{xmpp:xep/@rdf:resource}">
			XEP-<xsl:value-of select="$xepnumber"/>
			</a>
		</td>
		<td>
			<a href="{xmpp:xep/@rdf:resource}" title="{$xep-descriptor/abstract/text()}">
				<xsl:value-of select="$xep-descriptor/abstract/text()"/>
			</a>
		</td>
		<td>
			<span class="{version-class}" title="{$xep-descriptor/last-revision/date/text()}">
				<xsl:value-of select="$xep-descriptor/last-revision/version/text()"/>
			</span>
		</td>
		<td>
			<xsl:choose>
				<xsl:when test="$xep-descriptor/last-revision/version/text() = xmpp:version">
					<xsl:attribute name="class">version-latest</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">version-outdated</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="xmpp:version"/>
		</td>
		<td><span class="{xmpp:status}"><xsl:value-of select="xmpp:status"/></span></td>
		<td><xsl:value-of select="xmpp:since"/></td>
		<td><xsl:value-of select="xmpp:note"/></td>
	</tr>
</xsl:template>

</xsl:stylesheet>
