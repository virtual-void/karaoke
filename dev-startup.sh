#!/bin/sh

export LANG=C
#rackup -p 5000
thin -p 5000 -R config.ru start
