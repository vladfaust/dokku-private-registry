#!/bin/sh

echo "Generating httpasswd for $AUTH_USER"
htpasswd -Bbn "$AUTH_USER" "$AUTH_PASSWORD" > /htpasswd
