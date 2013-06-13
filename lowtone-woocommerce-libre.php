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

					// Config

					if (!defined("LOWTONE_WOOCOMMERCE_LIBRE_APPEND_TEMPLATE"))
						define("LOWTONE_WOOCOMMERCE_LIBRE_APPEND_TEMPLATE", true);

					if (!defined("LOWTONE_WOOCOMMERCE_LIBRE_INCLUDE_STYLES"))
						define("LOWTONE_WOOCOMMERCE_LIBRE_INCLUDE_STYLES", true);

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