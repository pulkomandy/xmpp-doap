<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:doap="http://usefulinc.com/ns/doap#"
	xmlns:xmpp="https://linkmauve.fr/ns/xmpp-doap#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
>

<xsl:template match="doap:Project">
	<html>
		<head>
			<link href="../style.css" type="text/css" rel="stylesheet"/>
			<title><xsl:value-of select="doap:name"/> - XMPP implementation support</title>
		</head>
		<body>
			<xsl:apply-templates select="doap:logo"/>
			<div class="header">
				<h1><xsl:value-of select="doap:name"/></h1>
				<b><xsl:value-of select="doap:shortdesc"/></b>
				<p><xsl:value-of select="doap:description"/></p>
				<p>
					<xsl:apply-templates select="doap:homepage"/>
					<xsl:apply-templates select="doap:download-page"/>
				</p>
			</div>

			<div class="os">
				<p>Supported operating systems</p>
				<xsl:apply-templates select="doap:os" />
			</div>

			<table>
				<tr><th>XEP</th><th>Version</th><th>Status</th><th>Since</th><th>Notes</th></tr>
				<xsl:apply-templates select="doap:implements/*"/>
			</table>
		</body>
	</html>
</xsl:template>

<xsl:template match="doap:logo">
	<img src="{@rdf:resource}" alt="logo" />
</xsl:template>

<xsl:template match="doap:homepage">
	<a class="button" href="{@rdf:resource}">Website</a>
</xsl:template>

<xsl:template match="doap:download-page">
	<a class="button" href="{@rdf:resource}">Download</a>
</xsl:template>

<xsl:template match="doap:os">
	<div class="chip">
		<xsl:value-of select="."/>
	</div>
</xsl:template>

<xsl:template match="xmpp:SupportedXep">
	<tr>
		<td>
			<a href="{xmpp:xep/@rdf:resource}">
			XEP-<xsl:value-of select="substring-before(substring-after(xmpp:xep/@rdf:resource, 'https://xmpp.org/extensions/xep-'), '.')"/>
			</a>
		</td>
		<td><xsl:value-of select="xmpp:version"/></td>
		<td><span class="{xmpp:status}"><xsl:value-of select="xmpp:status"/></span></td>
		<td><xsl:value-of select="xmpp:since"/></td>
		<td><xsl:value-of select="xmpp:note"/></td>
	</tr>
</xsl:template>

</xsl:stylesheet>
