#!/bin/sh

for f in $1/*.pdf
do
    echo "Processing $f resume..."
    rake score_cv:score filename="$f"
done
