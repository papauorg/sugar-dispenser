#!/bin/sh

set -e

rm -rf ./output
mkdir output

find ./3d-print -maxdepth 1 -type f -exec basename {} \; | sed 's/\.scad$//' | xargs -I {} openscad -o ./output/{}.stl ./3d-print/{}.scad