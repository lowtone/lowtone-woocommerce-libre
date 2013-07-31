<?xml version="1.0" encoding="UTF-8"?>
<!--
	@author Paul van der Meijs <code@paulvandermeijs.nl>
	@copyright Copyright (c) 2012-2013, Paul van der Meijs
	@version 1.0
 -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:wc="http://wordpress.lowtone.nl/woocommerce">
	
	<!-- Products -->
	
	<xsl:template match="//query[query_vars/post_type = 'product' or query_vars/taxonomy = 'product_cat' or query_vars/taxonomy = 'product_tag']/posts">
		<xsl:variable name="hasPosts" select="boolean(count(post))" />
		<xsl:variable name="single" select="boolean(//query/@single)" />

		<div class="one-whole column alpha omega">
			<xsl:value-of select="wc:woocommerce/actions/before_main_content" disable-output-escaping="yes" />

			<xsl:if test="not($single)">
				<xsl:apply-templates select="wc:woocommerce/page_title" />

				<xsl:value-of select="wc:woocommerce/actions/archive_description" disable-output-escaping="yes" />
			</xsl:if>

			<xsl:choose>
				<xsl:when test="$single">
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="wc:woocommerce/actions/before_shop_loop" disable-output-escaping="yes" />
				</xsl:otherwise>
			</xsl:choose>
		</div>
		
		<div>
			<xsl:attribute name="class">
				<xsl:text>posts products</xsl:text>
				<xsl:if test="not($hasPosts)">
					<xsl:text> empty</xsl:text>
				</xsl:if>
				<xsl:text> one-whole column alpha omega</xsl:text>
			</xsl:attribute>
			
			<xsl:choose>
				<xsl:when test="$hasPosts">
					<xsl:choose>
						<xsl:when test="$single">
							<xsl:apply-templates select="post" mode="single" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="post" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<p class="no-items"><xsl:value-of select="locales/no_posts" /></p>
				</xsl:otherwise>
			</xsl:choose>
		</div>

		<div class="one-whole column alpha omega">
			<xsl:choose>
				<xsl:when test="$single">
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="wc:woocommerce/actions/after_shop_loop" disable-output-escaping="yes" />
				</xsl:otherwise>
			</xsl:choose>

			<xsl:value-of select="wc:woocommerce/actions/after_main_content" disable-output-escaping="yes" />
		</div>
	</xsl:template>


	<!-- Page title -->

	<xsl:template match="wc:woocommerce/page_title">
		<h1 class="page-title"><xsl:value-of select="." disable-output-escaping="yes" /></h1>
	</xsl:template>


	<!-- Product -->

	<xsl:template match="post[type='product']">
		<xsl:param name="single" />
		
		<article id="{name}" itemscope="itemscope" itemtype="http://schema.org/Product">
			<xsl:attribute name="class">
				<xsl:text>post type-</xsl:text><xsl:value-of select="type" />
				<xsl:text> </xsl:text><xsl:value-of select="../wc:woocommerce/product_class" />

				<xsl:if test="0 = (position()-1) mod number(../wc:woocommerce/columns)">
					<xsl:text> first</xsl:text>
				</xsl:if>

				<xsl:if test="0 = position() mod number(../wc:woocommerce/columns)">
					<xsl:text> last</xsl:text>
				</xsl:if>
			</xsl:attribute>
			
			<xsl:value-of select="wc:woocommerce/actions/before_shop_loop_item" disable-output-escaping="yes" />

			<a href="{permalink}">
				<xsl:value-of select="wc:woocommerce/actions/before_shop_loop_item_title" disable-output-escaping="yes" />

				<h3><xsl:value-of select="title" disable-output-escaping="yes" /></h3>

				<xsl:value-of select="wc:woocommerce/actions/after_shop_loop_item_title" disable-output-escaping="yes" />
			</a>

			<xsl:value-of select="wc:woocommerce/actions/after_shop_loop_item" disable-output-escaping="yes" />
		</article>

		<xsl:if test="0 = position() mod number(../wc:woocommerce/columns)">
			<xsl:call-template name="separator" />
		</xsl:if>
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


	<!-- Separator -->

	<xsl:template name="separator">
		<div class="separator"></div>
	</xsl:template>


	<!-- Side -->

	<xsl:template name="woocommerce_side">
		<xsl:param name="width">one-third</xsl:param>

		<xsl:choose>
			<xsl:when test="count(sidebars/sidebar[@id='woocommerce_product']/widgets/widget) &gt; 0">
				<xsl:apply-templates select="sidebars/sidebar[@id='woocommerce_product']">
					<xsl:with-param name="width" select="$width" />
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="count(sidebars/sidebar[@id='woocommerce_catalog']/widgets/widget) &gt; 0">
				<xsl:apply-templates select="sidebars/sidebar[@id='woocommerce_catalog']">
					<xsl:with-param name="width" select="$width" />
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="side">
					<xsl:with-param name="width" select="$width" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>