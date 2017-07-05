width = 20;
height = 5;
center_diameter = 15;
bolt_diameter = 1.5;
epsilon=0.01;
epsilon2=2*epsilon;

alignment_post_diameter = 0.75;
alignment_post_clearance = 0.2;
alignment_post_length=0.7;

gap=0.2;

bolt_distance=(width-center_diameter)/4;

$fn=96;

module unit_half() {
  rotate([0,0,180]) {
    translate([-width/2,-width/2,0]) {
      difference () {
        translate([width/2, width/2, 0]) {
          cylinder(d=width, h=height/2);
        }
        translate([width/2,width/2,-epsilon]) {
          cylinder(d=center_diameter, h=height/2+epsilon2);
        }
        translate ([-epsilon,bolt_distance,height/2]) {
          rotate([0,90,0]) {
            cylinder(d=bolt_diameter, h=width/2+epsilon2);
          }
        }
        translate ([-epsilon,width-bolt_distance,height/2]) {
          rotate([0,90,0]) {
            cylinder(d=bolt_diameter, h=width/2+epsilon2);
          }
        }
      }
    }
  }
}

difference() {
  union() {
    unit_half();
    translate ([(width/2-bolt_distance)*0.7, -(width/2-bolt_distance)*0.75, height/2]) {
      cylinder(d=alignment_post_diameter-alignment_post_clearance, h=alignment_post_length-alignment_post_clearance);
    }
  }
  translate ([(width/2-bolt_distance)*0.7, (width/2-bolt_distance)*0.75, height/2-alignment_post_length+epsilon]) {
    cylinder(d=alignment_post_diameter, h=alignment_post_length);
  }
  translate([-epsilon,-width/2-epsilon,-epsilon]) {
      cube([gap+epsilon2, width+epsilon2, height/2+epsilon2]);
  }

}
