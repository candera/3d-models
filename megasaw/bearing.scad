include <../lib/common.scad>;

$fn=96;

bearing_width=9;
bearing_diameter=30;
wall_thickness=3;
shaft_diameter=inches(1.0625);
housing_clearance=0.7;
bearing_clearance=0.5;
axle_diameter = 10;
epsilon = 0.01;
bearings = 3;
mounting_plate_width = inches(1);
mounting_plate_thickness = wall_thickness * 2;
mounting_plate_length = bearing_diameter * 3;

arm_width = bearing_width + 2 * wall_thickness + bearing_clearance * 2;
arm_length = bearing_diameter + wall_thickness + bearing_clearance;
arm_height = bearing_diameter;

module bearing(extra_d=0) {
  bearing_diameter = bearing_diameter + extra_d;
  color([0.8,0.8,0.8]) {
    union() {
      difference() {
        cylinder(d=bearing_diameter, h=bearing_width);
        translate([0,0,-epsilon]) {
          cylinder(d=axle_diameter, h=bearing_width+2*epsilon);
        }
      }
      translate([0,0,-2*wall_thickness]) {
        cylinder(d=axle_diameter, h=bearing_width+4*wall_thickness);
      }
    }
  }
}

module arm() {
  translate([(bearing_width+2*wall_thickness)/-2, shaft_diameter/2, 0]) {
    difference() {
      cube([arm_width, arm_length, arm_height]);
      translate([wall_thickness + bearing_clearance,0,-epsilon]) {
        cube([bearing_width+bearing_clearance*2, bearing_diameter, bearing_diameter+2*epsilon]);
      }
    }
  }
}

module housing() {
  inner_d = shaft_diameter + housing_clearance;
  h = bearing_diameter;
  difference() {
    cylinder(d=inner_d + wall_thickness * 2, h = h);
    translate([0,0,-epsilon]) {
      cylinder(d=inner_d, h = h+2*epsilon);
    }
  }
}

module mounting_flange() {
  cube([mounting_plate_width, mounting_plate_thickness, arm_height]);
}

module assembly() {
  union() {
    translate([mounting_plate_width/-2,shaft_diameter/2+arm_length-wall_thickness,0]) {
      mounting_flange();
    }
    difference() {
      union() {
        for (alpha = [0:360/bearings:360]) {
          rotate([0,0,alpha]) {
            arm();
          }
        }
        housing();
      }
      for (alpha = [0:360/bearings:360]) {
        rotate([0,0,alpha]) {
          translate([-bearing_width/2+bearing_clearance, (bearing_diameter+shaft_diameter)/2, bearing_diameter/2]) {
            union() {
              // Clearance holes into shaft
              translate([0,-bearing_diameter,-bearing_diameter*0.75/2]) {
                cube([bearing_width+2*bearing_clearance,bearing_diameter,bearing_diameter * 0.75]);
              }
              translate([bearing_clearance, 0, 0]) {
                rotate([0,90,0]) {
                  bearing(extra_d = -bearing_diameter);
                }
              }
            }
          }
        }
      }
    }
  }
}

assembly();

/* color([0.7,0.7,0.7]) { */
/*   cylinder(d=inches(1.0625), h = 50); */
/* } */

