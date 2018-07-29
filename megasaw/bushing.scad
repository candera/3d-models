include <../lib/common.scad>;

$fn = 96;

shaft_diameter=inches(1.0625);
housing_clearance=0.3;
h = shaft_diameter * sqrt(2);
wall_thickness = 3;
epsilon = 0.01;
plate_thickness = wall_thickness * 2;
plate_length = h;

plate_x = shaft_diameter/2+wall_thickness*2+housing_clearance;
plate_y = shaft_diameter+wall_thickness*2+housing_clearance*2;

union() {
  translate([0,0,(plate_length-h)/2]) {
    difference() {
      union() {
        translate([0,plate_y / -2,0]) {
          cube([plate_x, plate_y, h]);
        }
        cylinder(d=shaft_diameter+wall_thickness*2+housing_clearance*2, h=h);
      }
      translate([0,0,-epsilon]) {
        cylinder(d=shaft_diameter+housing_clearance*2, h=h+2*epsilon);
      }
    }
  }
  translate([shaft_diameter/2+housing_clearance+wall_thickness*2,plate_y/-2,0]) {
    cube([plate_thickness, plate_y, plate_length]);
  }
}
