include <sugardispenser_customize.scad>


portionerRadius = dispenserChamberOuterDiameter/2-wallThickness-tolerance;
extensionForHoldingClamps=5;        
actualCylinderHeight = dispenserChamberHeight + extensionForHoldingClamps;
cutoffHeightForHoldingClamps=(actualCylinderHeight / 2) - sugarChamberMaxRadius;
moveCutoff=-1 * actualCylinderHeight / 2 - extensionForHoldingClamps + (cutoffHeightForHoldingClamps / 2) - 0.1;

function CalculateRadius(height, expectedVolume) = sqrt(expectedVolume/(PI * height));
function CalculateHeight(radius, expectedVolume) = expectedVolume / (PI * radius * radius);
function CalculateVolume(g) = g / sugarDensity;
function CalculateSphereVolume(r) = (4/3) * PI * r * r * r;

Portioner(8);

module Portioner(gramms)
{
    difference()
    {
        MainCylinder(gramms);
        SugarChamber(gramms);
    }
}

module MainCylinder(gramms)
{
    rotate([90, 0, 0])
    union() {
       
        difference()
        {
            translate([0, 0, -extensionForHoldingClamps/2])
            union()
            {
                
                cylinder(h=actualCylinderHeight, r=portionerRadius, center=true);
            
                // notch for clamps
                translate([0, 0, moveCutoff])
                    cylinder(h=extensionForHoldingClamps, r2=portionerRadius + wallThickness / 2, r1=portionerRadius, center=true);
            }
            
            translate([0, 0, moveCutoff])
                CutOffBackside();
        }
       
        // Front
        capThickness = wallThickness * 3;
        translate([0, 0, dispenserChamberHeight / 2 + capThickness / 2])
            PortionerCap(gramms, width=capThickness);
    }    
}

module CutOffBackside()
{
    union()
    {
        slitHeight = 1;
        spaceFromSlitToMiddle = portionerRadius * 0.33;
        spaceBetweenSlits = 2 * spaceFromSlitToMiddle;
        
        // extension and cutoffs for clamping
        cylinder(h=cutoffHeightForHoldingClamps, r=portionerRadius - wallThickness, center=true);
        
        // cutoff notches when not on holding clamps
        difference()
        {
            cylinder(h=cutoffHeightForHoldingClamps, r=portionerRadius + wallThickness, center=true);
            cylinder(h=cutoffHeightForHoldingClamps + 0.1, r=portionerRadius, center=true);
            cube([dispenserChamberOuterDiameter + wallThickness + 0.1, spaceBetweenSlits, cutoffHeightForHoldingClamps], center=true);
        }
        
        // slits for making holding clamps flexible
        translate([0, spaceFromSlitToMiddle, 0])
            cube([dispenserChamberOuterDiameter + wallThickness, slitHeight, cutoffHeightForHoldingClamps], center = true);
        
        translate([0, spaceFromSlitToMiddle * -1, 0])
            cube([dispenserChamberOuterDiameter + wallThickness, slitHeight, cutoffHeightForHoldingClamps], center = true);
    }
}

module PortionerCap(gramms, width)
{
    inlayDepth = width * 0.33;
    capRadius=portionerRadius * 1.33 + wallThickness;
    
    difference()
    {
        // Cap
        color("#00ff00")
        cylinder(h=width, r=capRadius, center=true, $fn=12);

        // Text
        translate([0, 0, width / 2 - 0.1])
            color("#ff0000")
            linear_extrude(inlayDepth)
                text(str(gramms, "g"), size=10, halign="center", valign="center", font=dispenserFont);
    }
    
    // Little stopper
    color("#00ff00")
        translate([0, portionerRadius + 2 + wallThickness + tolerance * 2, -6])
            cube([2,4,6], center=true);
}

module SugarChamberSphericBottom()
{
    expectedVolume = CalculateVolume(gramms);
    defaultHeight = portionerRadius * 2 * 0.75;
    
    radiusByVolume = CalculateRadius(height=defaultHeight, expectedVolume=expectedVolume);
    radius = min(max(radiusByVolume, sugarChamberMinRadius), sugarChamberMaxRadius);
    
    bottomHalfSphereVolume = CalculateSphereVolume(radius) / 2;
    cylinderVolume = expectedVolume - bottomHalfSphereVolume;
        
    height = CalculateHeight(radius, cylinderVolume);
    
    makeSureTheCylinderPiercesTheTop = portionerRadius;
    moveSugarChamber = radius /* to have the tip of the sphere on 0|0 */
                       - radius/2 - height/2 /* because the sphere-cylinder union is not center=true it is already halfway in the portioner cylinder */
                       - tolerance;
    
    echo(str("radius: ", radius, " cylinder-height: ", height, " expected-volume: ", expectedVolume, " cylinder-volume: ", cylinderVolume, " half-sphere-volume: ", bottomHalfSphereVolume));
    
    translate([0, 0, moveSugarChamber])
    union()
    {
        cylinder(h=height + makeSureTheCylinderPiercesTheTop, r=radius, center=false);
        sphere(r=radius);
    }
}

module SugarChamber(gramms)
{
    expectedVolume = CalculateVolume(gramms);
    defaultHeight = portionerRadius * 2 * 0.75;
    
    radiusByVolume = CalculateRadius(height=defaultHeight, expectedVolume=expectedVolume);
    radius = min(max(radiusByVolume, sugarChamberMinRadius), sugarChamberMaxRadius);
    height = CalculateHeight(radius, expectedVolume);
    
    makeSureTheCylinderPiercesTheTop = portionerRadius;
    moveSugarChamber = (height / 2 + tolerance) - height;
    
    echo(str("radius: ", radius, " height: ", height));
    
    translate([0, 0, moveSugarChamber])
        cylinder(h=height + makeSureTheCylinderPiercesTheTop, r=radius, center=false);
}

