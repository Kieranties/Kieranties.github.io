#!/bin/bash

# Simple script to install Ruby/Jekyll

# Update distro
sudo apt-get update -y && sudo apt-get upgrade -y

# Install ruby
sudo apt-add-repository ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get install ruby2.3 ruby2.3-dev build-essential dh-autoreconf

# Additonal requirements for nokogiri
sudo apt-get install zlib1g-dev

# Additional requirements for github-pages
sudo apt-get install libcurl4-openssl-dev

# Update gems
sudo gem update

# Install jekyll
sudo gem install jekyll bundler

# Check we're all good
jekyll -v