// The inner diameter of the mold, in mm
innerDiameter = 70;

// The thickness of the walls, in mm;
wallThickness = 4;

// The interior height, in mm
height = 115;

// The amount of extra space between parts to allow a good fit, in mm
allowance = 0.4;

outerDiameter = innerDiameter + wallThickness * 2;

module wall() {
  difference() {
    difference() {
      cylinder($fn=48, d = outerDiameter, h = height + wallThickness);
      translate([0, 0, -0.01])
	cylinder($fn=48, d = innerDiameter + allowance, h = height + wallThickness + 0.02);
    }
    translate([0, -innerDiameter, -0.01]) {
      cube([innerDiameter * 2, innerDiameter * 2, height * 2]);
    }
  }
}

module base() {
  difference() {
    cylinder($fn=48, d = outerDiameter, h = wallThickness * 2);
    translate([0,0,wallThickness]) {
      difference() {
	cylinder($fn=48, d = outerDiameter+0.01, h = wallThickness+0.01);
	cylinder($fn=48, d = innerDiameter+0.01, h = wallThickness+0.01);
      }
    }
  }
}

union() {
  translate([outerDiameter + 1, 0, 0])
    wall();
  translate([outerDiameter * 1.5 + 1, 0, 0])
    wall();
  color([0, 0, 1])
    base();
}
