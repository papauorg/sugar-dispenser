include <sugardispenser_customize.scad>

DispenserBody();

// Sugardispendser Base Body
module DispenserBody()
{
    union(){
        BottleCapWithThread();
        CylinderIntersection();
        FunnelToBottle();
    }
}

module FunnelToBottle()
{
    translate([0,0,intersectionHeight / 1.5 * -1])
    union() {
        difference() {
            cylinder(h=15, r1=bottleOuterDiameter / 2, r2 = verticalOuterDiameter / 2, center=true);
            cylinder(h=15.1, r1=bottleInnerDiameter / 2 - wallThickness, r2 = sugarChamberMaxRadius * 1.10, center=true);
        }
        translate([0,0,-12.5])
        difference() {
            cylinder(h=10, r=bottleInnerDiameter / 2, center=true);
            cylinder(h=10.1, r=bottleInnerDiameter / 2 - wallThickness, center=true);
        }
    }
    
}

module BottleCapWithThread()
{
    translate([0, 0, intersectionHeight/2])
    nut("PCO-1881", turns=2, Douter=verticalOuterDiameter);
}

module CylinderIntersection() {
    difference() {
        union() {
            // Dispenserchamber
            rotate([90, 0, 0])
            union()
            {
                cylinder(h=dispenserChamberHeight, r=dispenserChamberOuterDiameter / 2, center=true);
                
                translate([-3.1, dispenserChamberOuterDiameter / 2 -tolerance, verticalOuterDiameter/2 - tolerance])
                    cube([2, 11, 5+tolerance]);
                
                translate([-3.1, dispenserChamberOuterDiameter / 2 -tolerance -40, verticalOuterDiameter/2 - tolerance])
                    cube([2, 11, 5+tolerance]);
            }
            
            // sugar-channel
            difference()
            {
                cylinder(h=intersectionHeight, r=verticalOuterDiameter/2, center=true);
                FunnelToMaxRadiusBelowThread();
            }
            
            //FunnelToMaxRadiusBelowThread();
     

        }
        union() {
            // Dispenserchamber
            rotate([90, 0, 0])
                cylinder(h=dispenserChamberHeight +1, r=dispenserChamberOuterDiameter / 2 - wallThickness, center=true);
            
            // sugar-channel
            cylinder(h=intersectionHeight +1, r=sugarChamberMaxRadius*1.10, center=true);
        }
    }
}

module FunnelToMaxRadiusBelowThread()
{
    funnelHeight=(intersectionHeight - dispenserChamberOuterDiameter) / 2 + 0.1;
    funnelHeightMovement = (intersectionHeight / 2) - funnelHeight / 2 + 0.1;
    color("#000066")
    translate([0, 0, funnelHeightMovement])
    cylinder(h=funnelHeight, r1=sugarChamberMaxRadius * 1.1, r2=verticalOuterDiameter/2-wallThickness, center=true);
}