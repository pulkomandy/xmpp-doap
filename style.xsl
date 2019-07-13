<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:doap="http://usefulinc.com/ns/doap#"
	xmlns:xmpp="https://linkmauve.fr/ns/xmpp-doap#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
>

<xsl:template match="doap:Project">
	<html>
		<head>
			<link href="https://raw.githubusercontent.com/pulkomandy/xmpp-doap/master/style.css" type="text/css" rel="stylesheet"/>
			<title>XMPP implementation support for <xsl:value-of select="doap:name"/></title>
		</head>
		<body>
			<xsl:apply-templates select="doap:logo"/>
			<div>
			<h1><xsl:value-of select="doap:name"/></h1>
			<p><xsl:value-of select="doap:shortdesc"/></p>
			<p><xsl:value-of select="doap:description"/></p>

			<p>
				<xsl:apply-templates select="doap:homepage"/>
				<xsl:apply-templates select="doap:download-page"/>
			</p>
			<p>Supported operating systems:
				<ul>
					<xsl:apply-templates select="doap:os" />
				</ul>
			</p>
			</div>

			<table>
				<tr><th>XEP</th><th>Version</th><th>status</th><th>Since</th><th>Notes</th></tr>
				<xsl:apply-templates select="xmpp:software/*"/>
			</table>
		</body>
	</html>
</xsl:template>

<xsl:template match="doap:logo">
	<img src="{@rdf:resource}" alt="logo" />
</xsl:template>

<xsl:template match="doap:homepage">
	<a href="{@rdf:resource}">website</a>
</xsl:template>

<xsl:template match="doap:download-page">
	<a href="{@rdf:resource}">download</a>
</xsl:template>

<xsl:template match="doap:os">
	<li><xsl:value-of select="."/></li>
</xsl:template>

<xsl:template match="xmpp:xep">
	<xsl:apply-templates select="xmpp:Xep"/>
</xsl:template>

<xsl:template match="xmpp:Xep">
	<tr class="{xmpp:status}">
		<td><xsl:value-of select="xmpp:number"/></td>
		<td><xsl:value-of select="xmpp:version"/></td>
		<td><xsl:value-of select="xmpp:status"/></td>
		<td><xsl:value-of select="xmpp:since"/></td>
		<td><xsl:value-of select="xmpp:note"/></td>
	</tr>
</xsl:template>

</xsl:stylesheet>
