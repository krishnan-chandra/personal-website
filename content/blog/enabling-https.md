---
title: "Enabling HTTPS using Let's Encrypt"
date: 2017-09-23
author: "Krishnan Chandra"
draft: false
---

This weekend, I decided to try enabling HTTPS on this site (meaning getting certs for both krishnanchandra.com and krishnan.blog). I was previously hosting this site on Github Pages, but decided to switch to hosting on a Digital Ocean droplet because

1. Github Pages doesn't let you redirect multiple domains to the same website (although A records for the alternate domain can be pointed at Github Pages).
2. It was fairly difficult for me to set up HTTPS with Github Pages using a custom domain.

As a result, I spun up a cheap Digital Ocean droplet and decided to move my website onto there, fronted by Nginx. The SSL certificates were provided by [Let's Encrypt](https://letsencrypt.org/). I highly recommend checking them out if you're looking to just set up a simple static site for yourself and want to secure it using SSL. 

Fortunately, this was easy to do when following the [online guide](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-16-04). After some difficulty and wrangling with Nginx settings, I managed to get certificates set up for both of my domains using certbot. Now, whenever you visit this site you will automatically be served an HTTPS version of this page, regardless of whether you came to krishnanchandra.com or krishnan.blog!

