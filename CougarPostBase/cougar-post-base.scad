/* Post base reinforcer for TM Cougar. Dimensions from
   https://drive.google.com/drive/u/0/folders/0B4y50yHPnOVeNzRyREZFdlA1VzQ
   */

width = 40;
height = 10.3;
center_diameter = 10.5 * 2;
bolt_diameter = 3;
epsilon=0.01;
epsilon2=2*epsilon;

alignment_post_diameter = 2;
alignment_post_clearance = 0.2;
alignment_post_length=0.7;

gap=0.4;

bolt_distance=(width-center_diameter)/4;

recess_diameter = bolt_diameter * 2;
recess_depth = bolt_diameter;

$fn=96;

module unit_half() {
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
          cylinder(d=bolt_diameter, h=width/2+epsilon2);
        }
      }
      // Bolt hole 2
      translate ([-epsilon,width/2-bolt_distance,height/2]) {
        rotate([0,90,0]) {
          cylinder(d=bolt_diameter, h=width/2+epsilon2);
        }
      }
      // Recess hole 1
      translate([sin(90*((width - center_diameter)/width))*width/2-recess_diameter,bolt_distance-width/2,height/2]) {
        rotate([0,90,0]) {
          cylinder(d=recess_diameter, h=recess_depth*10);
        }
      }
      // Recess hole 1
      translate([sin(90*((width - center_diameter)/width))*width/2-recess_diameter,-(bolt_distance-width/2),height/2]) {
        rotate([0,90,0]) {
          cylinder(d=recess_diameter, h=recess_depth*10);
        }
      }
      // Alignment hole
      rotate([0,0,30]) {
        translate ([(center_diameter + width)/4, 0, height/2+epsilon-alignment_post_length+alignment_post_clearance]) {
          cylinder(d=alignment_post_diameter, h=alignment_post_length);
        }
      }
      // Cut it in half
      translate([-100+gap, -50, -1]) {
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

module unit() {
  union() {
    unit_half();
    translate([0,0,height]) {
      mirror([0,0,1]) {
        unit_half();
      }
    }
  }
}

color([0.2,0.2,0.2]) {
  union() {
    //unit_half();
    unit();
    mirror([1,0,0]) unit();
  }
}
