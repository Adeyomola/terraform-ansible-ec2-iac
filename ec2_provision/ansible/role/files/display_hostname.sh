#!/bin/bash
sudo echo "<!DOCTYPE html>
<html lang="en">
<body> $(dnsdomainname -f) </body>
</html>" > /var/www/html/index.html
