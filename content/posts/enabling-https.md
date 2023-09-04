---
title: "Enabling HTTPS using Let's Encrypt"
date: 2017-09-24
author: "Krishnan Chandra"
draft: false
---

This weekend, I decided to try enabling HTTPS on this site (meaning getting SSL certs for both krishnanchandra.com and krishnan.blog). I was previously hosting this site on Github Pages, but decided to switch to hosting on a Digital Ocean droplet because it was difficult to get Let's Encrypt set up with Github Pages and my custom domain(s).

Fortunately, this was easy to do when following the [online guide](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-16-04). After some difficulty and wrangling with Nginx settings, I managed to get certificates set up for both of my domains using certbot. Now, whenever you visit this site you will automatically be served an HTTPS version of this page, regardless of whether you came to krishnanchandra.com or krishnan.blog!

I highly recommend checking out Let's Encrypt and enabling HTTPS for your own website, if possible.

