/* Post base reinforcer for TM Cougar. Dimensions from
   https://drive.google.com/drive/u/0/folders/0B4y50yHPnOVeNzRyREZFdlA1VzQ
   */

width = 50;
height = 9.7;
center_diameter = 19.0;
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

recess_diameter = 8.6;

bolt_clearance_diameter = bolt_diameter + extrusion_width;
recess_clearance_diameter = recess_diameter + extrusion_width;

$fn=96;

module unit_half(sides) {
  union() {
    difference () {
      // Outer shell
      cylinder(d=width, h=height/2);
      // Inner hole
      translate([0,0,-epsilon]) {
        cylinder(d=center_diameter, h=height/2+epsilon2);
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
      // Alignment hole
      rotate([0,0,30]) {
        translate ([(center_diameter + width)/4, 0, height/2+epsilon-alignment_post_length+alignment_post_clearance]) {
          cylinder(d=alignment_post_diameter, h=alignment_post_length);
        }
      }
      // Cut it in half
      translate([-100+gap/2, -50, -1]) {
        cube(100, 100, 100, center=false);
      }
    }
    // Alignment post
    rotate([0,0,-30]) {
      translate ([(center_diameter + width)/4, 0, height/2]) {
        cylinder(d=alignment_post_diameter-alignment_post_clearance, h=alignment_post_length-alignment_post_clearance);
      }
    }
  }
}

module round_unit_half() { // export
  unit_half(sides=96);
}

module hex_unit_half() { // export
  unit_half(sides=6);
}

color([0.2,0.2,0.2]) {
  round_unit_half();
  translate([width/2 + 2,0,0]) {
    hex_unit_half();
  }
}
