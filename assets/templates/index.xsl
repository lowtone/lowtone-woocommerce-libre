<?xml version="1.0" encoding="UTF-8"?>
<!--
	@author Paul van der Meijs <code@paulvandermeijs.nl>
	@copyright Copyright (c) 2012, Paul van der Meijs
	@version 1.0
 -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


	<!-- Product -->

	<xsl:template match="post[type='product']">
		<xsl:param name="single" />
		
		<article id="{name}">
			<xsl:attribute name="class">
				<xsl:text>post type-</xsl:text><xsl:value-of select="type" />
				<xsl:if test="$single">
					<xsl:text> single</xsl:text>
				</xsl:if>
			</xsl:attribute>
			<div class="content">
				<xsl:value-of select="content" disable-output-escaping="yes" />
			</div>
		</article>
	</xsl:template>

</xsl:stylesheet>