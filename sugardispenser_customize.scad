use <threadlib/threadlib.scad>

$fn=100;

// settings
dispenserChamberOuterDiameter = 45;
verticalOuterDiameter = 32;
wallThickness = 2;
bottleOuterDiameter = 29;
bottleInnerDiameter = 14;
dispenserFont = "DejaVu Sans:style=Bold";
tolerance = 0.2;

//sugarChamberMaxRadius = ((dispenserChamberOuterDiameter / 2 - 2 * wallThickness) - tolerance);
sugarChamberMaxRadius = 12;
sugarChamberMinRadius = 5;

// calculated values
intersectionHeight = dispenserChamberOuterDiameter + 10;
dispenserChamberHeight = verticalOuterDiameter + 10;

// constants

// Density in g/mm³
sugarDensityInKgPerLiter = 0.67;
sugarDensity = sugarDensityInKgPerLiter * 1000 / 1000000;