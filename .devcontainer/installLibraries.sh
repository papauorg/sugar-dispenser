#!/bin/sh

set -e

git clone https://github.com/openscad/list-comprehension-demos.git ~/.local/share/OpenSCAD/libraries/list-comprehension-demos 
git clone https://github.com/openscad/scad-utils.git ~/.local/share/OpenSCAD/libraries/scad-utils 
git clone https://github.com/adrianschlatter/threadlib.git ~/.local/share/OpenSCAD/libraries/threadlib
curl https://raw.githubusercontent.com/MisterHW/IoP-satellite/refs/heads/master/OpenSCAD%20bottle%20threads/thread_profile.scad -o ~/.local/share/OpenSCAD/libraries/thread_profile.scad