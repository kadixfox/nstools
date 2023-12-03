#!/bin/bash

cd ns-census-maximizer/
IFS=$'\n'
for i in `cat ../nationlog`; do
	./example.py `awk '{print $1; print $2;}' <<<$i` "REDACTED"
done
