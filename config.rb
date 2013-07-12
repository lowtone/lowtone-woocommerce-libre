# Require any additional compass plugins here.

wp_project_path = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", ".."))

wp_http_path = File.join(wp_project_path, "web")

lowtone_style_partials_path = File.join(wp_http_path, "wp-content", "libs", "lowtone-style", "assets", "styles", "sass", "partials")

# Add lowtone-style\assets\styles\sass\partials to import path:
# add_import_path lowtone_style_partials_path

# Set this to the root of your project when deployed:
http_path = "."
css_dir = "assets/styles"
sass_dir = "assets/styles/sass"
images_dir = "assets/images"
javascripts_dir = "assets/scripts"
fonts_dir = "assets/fonts"
cache_path = File.join(wp_project_path, ".sass-cache")

# You can select your preferred output style here (can be overridden via the command line):
# output_style = :expanded or :nested or :compact or :compressed

# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true

# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false

# If you prefer the indented syntax, you might want to regenerate this
# project again passing --syntax sass, or you can uncomment this:
# preferred_syntax = :sass
# and then run:
# sass-convert -R --from scss --to sass sass scss && rm -rf sass && mv scss sass
preferred_syntax = :scss

sass_options = {:debug_info=>true} # by Compass.app 


output_style = :compressed # by Compass.app 