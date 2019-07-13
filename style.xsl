<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:doap="http://usefulinc.com/ns/doap#"
	xmlns:xmpp="xmpp:linkmauve.fr/protocols/xmpp-software"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
>

<xsl:template match="doap:Project">
	<html>
		<head>
			<link href="style.css" type="text/css" rel="stylesheet"/>
			<title>XMPP implementation support for <xsl:value-of select="doap:name"/></title>
		</head>
		<body>
			<h1><xsl:value-of select="doap:name"/></h1>
			<xsl:apply-templates select="doap:logo"/>
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

			<table>
				<tr><th>XEP</th><th>Version</th><th>status</th><th>Since</th><th>Notes</th></tr>
				<xsl:apply-templates select="xmpp:xmpp-software"/>
			</table>
		</body>
	</html>
</xsl:template>

<xsl:template match="xmpp:type"/>

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

<xsl:template match="xmpp:extension">
	<tr class="{@status}">
		<td><xsl:value-of select="@number"/></td>
		<td><xsl:value-of select="@version"/></td>
		<td><xsl:value-of select="@status"/></td>
		<td><xsl:value-of select="@since"/></td>
		<td><xsl:value-of select="@note"/></td>
	</tr>
</xsl:template>

</xsl:stylesheet>
