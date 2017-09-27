/* Post base reinforcer for TM Cougar. Dimensions from
   https://drive.google.com/drive/u/0/folders/0B4y50yHPnOVeNzRyREZFdlA1VzQ
   */
use <../lib/common.scad>;

width = 50;
height = 9.7;
center_diameter = 19.5;
bolt_diameter = 3.5;
epsilon=0.01;
epsilon2=2*epsilon;
extrusion_width=0.4;

alignment_post_diameter = 2.7;
alignment_post_clearance = 0.7;
alignment_post_length=2;

gap=1;

bolt_distance=(width-center_diameter)/4;
bolt_hole_length = 20;

recess_diameter = 8.7;

bolt_clearance_diameter = bolt_diameter + extrusion_width;
recess_clearance_diameter = recess_diameter + 2 * extrusion_width;

$fn=96;

module unit(sides, half=false) {
  h = height / (half ? 2 : 1);
  union() {
    difference () {
      // Outer shell
      cylinder(d=width, h=h);
      // Inner hole
      translate([0,0,-epsilon]) {
        cylinder(d=center_diameter, h=h+epsilon2);
      }
      // Bolt hole 1
      translate ([-epsilon,bolt_distance-width/2,height/2]) {
        rotate([0,90,0]) {
          cylinder(d=bolt_clearance_diameter, h=width/2+epsilon2);
        }
      }
      // Bolt hole 2
      translate ([-epsilon,width/2-bolt_distance,height/2]) {
        rotate([0,90,0]) {
          cylinder(d=bolt_clearance_diameter, h=width/2+epsilon2);
        }
      }
      // Recess hole 1
      translate([bolt_hole_length/2,
                 bolt_distance-width/2,
                 height/2]) {
        rotate([0,90,0]) {
          cylinder(d=recess_clearance_diameter, h=width, $fn=sides);
        }
      }
      // Recess hole 2
      translate([bolt_hole_length/2,
                 -(bolt_distance-width/2),
                 height/2]) {
        rotate([0,90,0]) {
          cylinder(d=recess_clearance_diameter, h=width, $fn=sides);
        }
      }
      if (half) {
        // Alignment hole
        rotate([0,0,30]) {
          translate ([(center_diameter + width)/4, 0, height/2+epsilon-alignment_post_length+alignment_post_clearance]) {
            cylinder(d=alignment_post_diameter, h=alignment_post_length);
          }
        }
      }
      // Cut it in half
      translate([-100+gap/2, -50, -1]) {
        cube(100, 100, 100, center=false);
      }
    }
    if (half) {
      // Alignment post
      rotate([0,0,-30]) {
        translate ([(center_diameter + width)/4, 0, height/2]) {
          cylinder(d=alignment_post_diameter-alignment_post_clearance, h=alignment_post_length-alignment_post_clearance);
        }
      }
    }
  }
}

module round_half() { // export
  unit(sides=96, half=true);
}

module hex_half() { // export
  unit(sides=6, half=true);
}

module round() { // export
  unit(sides=96, half=false);
}

module hex() { // export
  unit(sides=6, half=false);
}

color([0.2,0.2,0.2]) {
  display(width*1.2, width, 2) {
    text("1/2 round"); round_half();
    text("1/2 hex");   hex_half();
    text("round"); round();
    text("hex"); hex();
  }
}
