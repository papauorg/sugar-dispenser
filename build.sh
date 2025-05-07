#!/bin/bash

set -e

echo "Clean output directory"
rm -rf ./output
mkdir output

echo "Build body stl"
# Create body stl file
openscad -o ./output/body.stl ./models/3d-print/body.scad


echo "Create portioners according to list in readme file"
scriptDir=$(dirname "$0")
configurations=$(sed -n '/## Available models/,/#/p' "$scriptDir/Readme.md" | grep -e '^|' | tail -n +3 | cut -d"|" -f2,4)

while IFS='|' read -r amount density; do
    gramms=$(echo "$amount" | xargs)  # remove leading/trailing whitespace
    kgl=$(echo "$density" | xargs)
    
    echo "Amount: $gramms. Density: $kgl"
    openscad -o ./output/portioner-${gramms}g-${kgl}kg_l.stl -q -D "gramms=$gramms;sugarDensityInKgPerLiter=$kgl;" ./models/3d-print/portioner.scad
done <<< "$configurations"
