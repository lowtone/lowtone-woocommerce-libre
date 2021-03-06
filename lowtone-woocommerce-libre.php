<?php
/*
 * Plugin Name: WooCommerce support for Libre
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
		lowtone\content\packages\Package;

	// Includes
	
	if (!include_once WP_PLUGIN_DIR . "/lowtone-content/lowtone-content.php") 
		return trigger_error("Lowtone Content plugin is required", E_USER_ERROR) && false;

	// Init

	Package::init(array(
			Package::INIT_PACKAGES => array("lowtone", "lowtone\\woocommerce", "lowtone\\style"),
			Package::INIT_MERGED_PATH => __NAMESPACE__,
			Package::INIT_SUCCESS => function() {
				if (!checkLibre())
					return false;

				add_theme_support("woocommerce");

				add_action("init", function() {

					if (!checkWooCommerce())
						return;

					global $woocommerce;

					add_action("wp_head", array($woocommerce, "init_checkout"), 9999);

					// Config

					if (!defined("LOWTONE_WOOCOMMERCE_LIBRE_APPEND_TEMPLATE"))
						define("LOWTONE_WOOCOMMERCE_LIBRE_APPEND_TEMPLATE", true);

					if (!defined("LOWTONE_WOOCOMMERCE_LIBRE_INCLUDE_STYLES"))
						define("LOWTONE_WOOCOMMERCE_LIBRE_INCLUDE_STYLES", true);

					// Disable redirect

					remove_filter("template_include", array($GLOBALS["woocommerce"], "template_loader"));

					// Disable WooCommerce pagination

					remove_action("woocommerce_after_shop_loop", "woocommerce_pagination");

					// Append template

					if (LOWTONE_WOOCOMMERCE_LIBRE_APPEND_TEMPLATE) {

						add_filter("libre_append_templates", function($templates, $template) {
							$templates[] = template();

							return $templates;
						}, 10, 2);

					}

					// Include styles
					
					if (LOWTONE_WOOCOMMERCE_LIBRE_INCLUDE_STYLES) {

						$stylesheet = stylesheet();

						$deps = array(
								"lowtone_style_grid",
							);

						wp_enqueue_style("lowtone_woocommerce_libre", $stylesheet, $deps);

					}

				});

				add_filter("libre_sidebar_meta", function($meta) {
					$meta["woocommerce_catalog"] = array(
							"woocommerce_catalog_sidebars", 
							"WooCommerce Catalog Sidebars", 
							__("WooCommerce Catalog", "lowtone_woocommerce_libre"), 
							__("This sidebar is displayed on the WooCommerce catalog page.", "lowtone_woocommerce_libre")
						);
					
					$meta["woocommerce_product"] = array(
							"woocommerce_product_sidebars", 
							"WooCommerce Product Sidebars", 
							__("WooCommerce Product", "lowtone_woocommerce_libre"), 
							__("This sidebar is displayed on the WooCommerce product page.", "lowtone_woocommerce_libre")
						);

					return $meta;
				});

				add_filter("libre_sidebars", function($sidebars) {
					global $wp_query;

					if (!("product" == $wp_query->get("post_type") || 
						"product_cat" == $wp_query->get("taxonomy") || 
						"product_tag" == $wp_query->get("taxonomy")))
							return $sidebars;

					$sidebars[] = is_singular() ? "woocommerce_product" : "woocommerce_catalog";
					
					return $sidebars;
				});

			}
		));

	// Functions
	
	function checkLibre() {
		return get_option("template") == "lowtone-libre";
	}

	function checkWooCommerce() {
		return class_exists("Woocommerce");
	}

	/**
	 * Locate the WooCommerce Libre template.
	 * @return string Returns the path to the template.
	 */
	function template() {
		foreach (array(get_stylesheet_directory(), get_template_directory()) as $dir) {
			if (!is_file($template = $dir . "/woocommerce/libre/index.xsl"))
				continue;

			return $template;
		}

		return __DIR__ . "/assets/templates/index.xsl";
	}

	function stylesheet() {
		$path = "styles/woocommerce.css";

		foreach (array(get_stylesheet_directory(), get_template_directory()) as $i => $dir) {
			if (!is_file($dir . DIRECTORY_SEPARATOR . $path))
				continue;
			
			return (0 == $i ? get_stylesheet_directory_uri() : get_template_directory_uri()) . "/" . $path;
		}

		return plugins_url("/assets/" . $path, __FILE__);
	}

}