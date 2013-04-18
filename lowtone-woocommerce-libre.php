<?php
/*
 * Plugin Name: WooCommerce Libre support
 * Plugin URI: http://wordpress.lowtone.nl/plugins/woocommerce-libre/
 * Description: Add WooCommerce support to the Libre theme.
 * Version: 1.0
 * Author: Lowtone <info@lowtone.nl>
 * Author URI: http://lowtone.nl
 * License: http://wordpress.lowtone.nl/license
 */
/**
 * @author Paul van der Meijs <code@lowtone.nl>
 * @copyright Copyright (c) 2011-2012, Paul van der Meijs
 * @license http://wordpress.lowtone.nl/license/
 * @version 1.0
 * @package wordpress\plugins\lowtone\woocommerce\libre
 */

namespace lowtone\woocommerce\libre {

	use lowtone\Util,
		lowtone\content\packages\plugins\Plugin;

	// Includes
	
	if (!include_once WP_PLUGIN_DIR . "/lowtone-content/lowtone-content.php") 
		return trigger_error("Lowtone Content plugin is required", E_USER_ERROR) && false;

	// Init

	Plugin::init(array(
			Plugin::INIT_PACKAGES => array("lowtone", "lowtone\\woocommerce"),
			Plugin::INIT_MERGED_PATH => __NAMESPACE__
		));

	add_action("init", function() {
		if (!checkWooCommerce())
			return;

		// Config

		if (!defined("LOWTONE_WOOCOMMERCE_LIBRE_APPEND_TEMPLATE"))
			define("LOWTONE_WOOCOMMERCE_LIBRE_APPEND_TEMPLATE", true);

		remove_filter("template_include", array($GLOBALS["woocommerce"], "template_loader"));

		add_filter("post_document_content", function($content) {
			if (!(is_single() && get_post_type() == "product"))
				return $content;

			return Util::catchOutput(function() {
				while (have_posts()) {
					the_post();

					woocommerce_get_template_part("content", "single-product");
				}
			});
		});

		if (LOWTONE_WOOCOMMERCE_LIBRE_APPEND_TEMPLATE) {

			add_filter("libre_append_templates", function($templates, $template) {
				$templates[] = __DIR__ . "/assets/templates/index.xsl";

				return $templates;
			}, 10, 2);

		}

	});

	// Functions

	function checkWooCommerce() {
		return class_exists("Woocommerce");
	}

}