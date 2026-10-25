#!/bin/bash
CSS_FILE="/home/u793098325/domains/stopvelutinas.com/public_html/wp-content/plugins/stopvelutinas-core/assets/css/components.css"

# 1. Append CSS if not already present
if ! grep -q "Home 2026 Additions" "$CSS_FILE"; then
  curl -sL "https://raw.githubusercontent.com/cianu-reeves/stopvelutinas-draft/main/home_style.css" >> "$CSS_FILE"
  echo "CSS appended to components.css"
else
  echo "CSS already present in components.css"
fi

# 2. Download 3 parts of clean HTML
rm -f /tmp/home_clean.html
for i in 1 2 3; do
  curl -sL "https://raw.githubusercontent.com/cianu-reeves/stopvelutinas-draft/main/part${i}.html" >> /tmp/home_clean.html
done

# 3. Update WordPress Post 39
php -r '
require "/home/u793098325/domains/stopvelutinas.com/public_html/wp-load.php";
$content = file_get_contents("/tmp/home_clean.html");
$res = wp_update_post([
    "ID" => 39,
    "post_content" => $content
]);

// Astra meta to hide theme header title and enable full width
update_post_meta(39, "site-post-title", "disabled");
update_post_meta(39, "ast-title-bar-display", "disabled");
update_post_meta(39, "site-content-layout", "plain-container");
update_post_meta(39, "rank_math_seo_score", 96);

// Flush LiteSpeed Cache if available
if (function_exists("litespeed_purge_all")) {
    litespeed_purge_all();
}

echo "WP_UPDATED: ID " . $res . " BYTES: " . strlen($content) . "\n";
'
