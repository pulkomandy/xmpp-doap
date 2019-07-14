<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xi="http://www.w3.org/2001/XInclude"
	xmlns:doap="http://usefulinc.com/ns/doap#"
	xmlns:xmpp="https://linkmauve.fr/ns/xmpp-doap#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
	exclude-result-prefixes='xsl xi'>
<xsl:output method="xml" indent="yes"/>
<!--
	<xsl:template match="xep">
		<html>
			<head>
				<title>XEP support dashboard</title>
			</head>
			<body>
				<p>The following clients support this XEP:</p>
				<ul>
					<xsl:apply-templates select="doap:Project"/>
				</ul>
			</body>
		</html>
	</xsl:template>
-->

	<xsl:template match="doap:Project[xmpp:software/xmpp:Client/xmpp:supports/xmpp:SupportedXep/xmpp:xep/@rdf:resource = 'https://xmpp.org/extensions/xep-0004.html']">
		<li><xsl:value-of select="doap:name"/> (<xsl:value-of select="xmpp:software/xmpp:Client/xmpp:supports/xmpp:SupportedXep[xmpp:xep/@rdf:resource = 'https://xmpp.org/extensions/xep-0004.html']/xmpp:version"/>)</li>
	</xsl:template>

	<xsl:template match="xi:include[@href]">
		<xsl:apply-templates select="document(@href)" />
	</xsl:template>

	<xsl:template match="xi:include" />

</xsl:stylesheet>
