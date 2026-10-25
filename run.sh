#!/bin/bash
rm -f /tmp/home_full.html
for i in 1 2 3 4; do
  curl -sL "https://raw.githubusercontent.com/cianu-reeves/stopvelutinas-draft/main/part${i}.html" >> /tmp/home_full.html
done

php -r '
require "/home/u793098325/domains/stopvelutinas.com/public_html/wp-load.php";
$content = file_get_contents("/tmp/home_full.html");
$res = wp_update_post([
    "ID" => 39,
    "post_content" => $content
]);
echo "POST_UPDATE_RESULT: " . $res . " BYTES: " . strlen($content) . "\n";
'
