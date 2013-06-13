<?xml version="1.0" encoding="UTF-8"?>
<!--
	@author Paul van der Meijs <code@paulvandermeijs.nl>
	@copyright Copyright (c) 2012, Paul van der Meijs
	@version 1.0
 -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:wc="http://wordpress.lowtone.nl/woocommerce">


	<!-- Product -->

	<xsl:template match="post[type='product']">
		<xsl:param name="single" />
		
		<article id="{name}" itemscope="itemscope" itemtype="http://schema.org/Product">
			<xsl:attribute name="class">
				<xsl:text>post type-</xsl:text><xsl:value-of select="type" />

				<xsl:if test="0 = position()-1 mod number(../wc:woocommerce/columns)">
					<xsl:text> first</xsl:text>
				</xsl:if>

				<xsl:if test="0 = position() mod number(../wc:woocommerce/columns)">
					<xsl:text> last</xsl:text>
				</xsl:if>
			</xsl:attribute>

			<xsl:value-of select="wc:woocommerce/actions/before_shop_loop_item" disable-output-escaping="yes" />

			<a href="{permalink}">
				<xsl:value-of select="wc:woocommerce/actions/before_shop_loop_item_title" disable-output-escaping="yes" />

				<h3><xsl:value-of select="title" /></h3>

				<xsl:value-of select="wc:woocommerce/actions/after_shop_loop_item_title" disable-output-escaping="yes" />
			</a>

			<xsl:value-of select="wc:woocommerce/actions/after_shop_loop_item" disable-output-escaping="yes" />
		</article>
	</xsl:template>


	<!-- Single product -->

	<xsl:template match="post[type='product']" mode="single">
		<xsl:value-of select="wc:woocommerce/actions/before_single_product" disable-output-escaping="yes" />

		<article id="{name}" itemscope="itemscope" itemtype="http://schema.org/Product" class="post type-{type} single">

			<div class="one-half column alpha">
				<xsl:value-of select="wc:woocommerce/actions/before_single_product_summary" disable-output-escaping="yes" />
			</div>

			<div class="one-half column omega summary entry-summary">
				<xsl:value-of select="wc:woocommerce/actions/single_product_summary" disable-output-escaping="yes" />
			</div>

			<div class="one-whole column alpha omega">
				<xsl:value-of select="wc:woocommerce/actions/after_single_product_summary" disable-output-escaping="yes" />
			</div>

		</article>

		<xsl:value-of select="wc:woocommerce/actions/after_single_product" disable-output-escaping="yes" />
	</xsl:template>

</xsl:stylesheet>