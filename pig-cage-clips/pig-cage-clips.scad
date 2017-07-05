grill_diameter=4.3;
clip_height=12;
wall_thickness=1.5;
foot_thickness=6;
epsilon=0.01;
inner_diameter=grill_diameter;
outer_diameter=inner_diameter + wall_thickness;
overhang_distance=1.5;
arm_length=20;
tolerance=0.35;

$fn=96;

module outline () {
  difference() {
    union() {
      circle(d=outer_diameter);
      translate([0,-outer_diameter/2,0]) {
        square(size=[inner_diameter/2+foot_thickness, outer_diameter]);
      }
    }
    circle(d=inner_diameter);
    translate([-outer_diameter-overhang_distance,-outer_diameter/2,0]) {
      square(size=[outer_diameter,outer_diameter]);
    }
  }
}

module foot () {
  linear_extrude(height=clip_height) {
    outline();
  }
}

module clip () {
  union() {
    foot();
    translate([outer_diameter+wall_thickness/2,0,0]) {
      rotate([0,0,180]) {
        foot();
      }
    }
  }
}

module connector_f () {
  union() {
    foot();
    difference() {
      translate([inner_diameter/2, -outer_diameter/2, clip_height]) {
        cube([foot_thickness, outer_diameter, arm_length]);
      }
      translate([inner_diameter/2+foot_thickness*1/3+epsilon, -outer_diameter/2-epsilon, clip_height+arm_length-outer_diameter+epsilon]) {
        cube([foot_thickness/3+2*epsilon, outer_diameter+2*epsilon, outer_diameter+2*epsilon]);
      }
    }
  }
}

module connector_m () {
  union() {
    foot();
    union() {
      translate([inner_diameter/2, -outer_diameter/2, clip_height]) {
        cube([foot_thickness, outer_diameter, arm_length-outer_diameter]);
      }
      translate([inner_diameter/2+foot_thickness*1/3+tolerance/2+epsilon, -outer_diameter/2-epsilon, clip_height+arm_length-outer_diameter+epsilon]) {
        cube([foot_thickness/3+2*epsilon-tolerance, outer_diameter+2*epsilon, outer_diameter+2*epsilon]);
      }
    }
  }
}


/* union () { */
/*   translate([outer_diameter+0.4, 0, 0])  */
/*     clip(); */
/*   foot(); */
/* } */

union () {
  connector_m();
  translate([0, outer_diameter+0.5, 0]) {
    connector_f();
  }
}

