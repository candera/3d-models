include <../lib/common.scad>;
include <../lib/square_nut.scad>;
use <../lib/RatchetLib.scad>;

$fn = 100;

extrusion_width = 0.4;
layer_height = 0.2;
separation_gap = 0.55; // Space between parts so they don't stick

// Caps
cap_thickness = 4;
cap_dimple_thickness = 1; // These mate with the sockets
cap_clearance_hole_d = 5.5;
cap_counterbore_thickness = 3;
cap_counterbore_d = 9;
cap_screw_pilot_d = 2.5;
flange_width = 25;
flange_thickness = 4;
flanges = -1;
flange_hole_diameter = 3;

// inner (teeth) ring
inner_ring_diameter=45;		// outer diameter of the inner ring
inner_ring_height=17;		// height of the inner ring

// outer (arms) ring
// outer_ring_diameter=110;		// outer diameter of the outer ring
///outer_ring_height=21;		// height of the outer ring
outer_ring_thickness=4;		// thickness of the outer ring
//outer_ring_brim_thickness = 2;

// arms for outer ring (and cutting ratchet teeth on inner ring)
arms=8;					// total number of radially symmetric arms
tooth_multiplier = 1;    // How many teeth there are per arm
axle_d = 12;
// arm_l = 15;
arm_w = 5;
arm_h = inner_ring_height;
arm_bevel = 20;

// spring arms
spring_thickness = extrusion_width * 1;
spring_l = 0.9; // Proportion of arm length
spring_extra_separation = 0; // Extra separation for arms, which tend to stick in the sockets

// sockets
socket_thickness=3;


// Computed values
// Make enough space for the arms to swing out without hitting the sockets
arm_clearance = 2.5;
outer_ring_r = (inner_ring_diameter / 2) 
  + arm_w + spring_thickness 
  + axle_d
  + socket_thickness
  + outer_ring_thickness
  + arm_clearance;
outer_ring_diameter = outer_ring_r * 2;

// Make the outer ring high enough to accomodate the cap
outer_ring_height = inner_ring_height + (cap_dimple_thickness * 2) + (layer_height * 2);

// Make the brim wide enough not to interfere with the arms
outer_ring_brim_w = axle_d / 2;

// Brim goes all the way to the top
outer_ring_brim_thickness = outer_ring_height;


// =======================================================================


/* module wedge( */
/*   theta1 = 0, */
/*   theta2 = 180, */
/*   r = 10, */
/*   $fn = $fn) { */
/*   points = [ */
/*     [0, 0], */
/*     for (a = [theta1:(theta2-theta1)/$fn:theta2]) */
/*       [r * cos(a), r * sin(a)] */
/*     , [0,0]]; */
/*   polygon(points=points); */
/* } */

// Set the arm length based on what gives a 90-degree power transfer angle
function optimimum_arm_length(
  outer_ring_diameter = outer_ring_diameter,
  outer_ring_thickness = outer_ring_thickness,
  axle_d = axle_d,
  arm_w = arm_w
  ) =
  let (c = (outer_ring_diameter / 2) - outer_ring_thickness - (axle_d / 2),
       a = (inner_ring_diameter / 2) - (arm_w / 2))
  sqrt((c * c) - (a * a)) - (axle_d / 2);

arm_l = optimimum_arm_length();

module arm (
  axle_d = axle_d,
  arm_l = arm_l,
  arm_w = arm_w,
  arm_h = arm_h,
  arm_bevel = arm_bevel) {
  union() {
    axle_r = axle_d / 2;
    // axle
    cylinder(h = arm_h, d = axle_d);
    // arm
    linear_extrude(height=arm_h) {
      polygon(points = [[arm_w/2, 0],
                        [arm_w/2, axle_r + arm_l + (arm_w * sin(arm_bevel))],
                        [-arm_w/2, axle_r + arm_l],
                        [-arm_w/2, 0]]);
    }
  }
}

// The angle at which the arm is closest to pointing to the center
function min_rotation(
  outer_ring_diameter = outer_ring_diameter,
  outer_ring_thickness = outer_ring_thickness,
  inner_ring_diameter = inner_ring_diameter,
  axle_d = axle_d,
  arm_l = arm_l,
  arm_w = arm_w,
  arm_h = arm_h,
  arm_bevel = arm_bevel) = 
  let (inner_ring_r = inner_ring_diameter / 2,
       outer_ring_r = outer_ring_diameter / 2,
       axle_r = axle_d / 2,
       a = inner_ring_r,
       b1 = arm_l + axle_r,
       b2 = arm_w / 2,
       b = sqrt((b1 * b1) + (b2 * b2)),
       c = outer_ring_r - outer_ring_thickness - axle_r,
       arm_angle = atan2(arm_w/2, arm_l + axle_r))
  acos(((b * b) + (c * c) - (a * a)) / (2 * b * c))- arm_angle;

function max_rotation(
  outer_ring_diameter = outer_ring_diameter,
  outer_ring_thickness = outer_ring_thickness,
  inner_ring_diameter = inner_ring_diameter,
  axle_d = axle_d,
  arm_l = arm_l,
  arm_w = arm_w,
  arm_h = arm_h,
  arm_bevel = arm_bevel) = 
  let (inner_ring_r = inner_ring_diameter / 2,
       outer_ring_r = outer_ring_diameter / 2,
       axle_r = axle_d / 2,
       a = inner_ring_r,
       b1 = arm_l + axle_r + (arm_w * sin(arm_bevel)),
       b2 = arm_w / 2,
       b = sqrt((b1 * b1) + (b2 * b2)),
       c = outer_ring_r - outer_ring_thickness - axle_r,
       arm_angle = atan2(arm_w/2, arm_l + axle_r + (arm_w * sin(arm_bevel))))
  acos(((b * b) + (c * c) - (a * a)) / (2 * b * c)) + arm_angle;

module nth_axle_transform(
  n, 
  arms=arms,
  outer_ring_diameter = outer_ring_diameter,
  outer_ring_thickness = outer_ring_thickness,
  axle_d=axle_d) {
  
  alpha = n * (360 / arms);
  rotate(alpha) {
    translate([0, -((outer_ring_diameter / 2) - outer_ring_thickness - (axle_d / 2)), 0]) {
      children();
    }
  }
}

module outer(
  axle_d = axle_d,
  arm_l = arm_l,
  arm_w = arm_w,
  arm_h = arm_h,
  arm_bevel = arm_bevel,
  socket_thickness = socket_thickness) {

  outer_ring_r = outer_ring_diameter / 2;
  axle_r = axle_d / 2;
  arm_center_offset = outer_ring_r - axle_d/2 - outer_ring_thickness;

  difference() {
    union() {
      color([1, 0, 0]) {
        union() {
          // Outer wall
          difference() {
            cylinder(d=outer_ring_diameter, h=outer_ring_height);
            translate([0,0,-1])
              cylinder(r=outer_ring_r-outer_ring_thickness, h=outer_ring_height + 2);
          }
          // base reinforcing brim
          difference() {
            cylinder(d = outer_ring_diameter, h = outer_ring_brim_thickness);
            translate([0, 0, -1]) {
              cylinder(r = outer_ring_r - outer_ring_thickness - outer_ring_brim_w, h = outer_ring_brim_thickness + 2);
            }
          }
        }
      }

      color([0, 0, 1]) {
        union() {
          // Spring
          for (n = [0:arms]) {
            nth_axle_transform(n) {

              rotate(min_rotation() - atan2(axle_r + socket_thickness - (arm_w / 2), arm_l + axle_r) - 90) {
                translate([-arm_l * spring_l, -axle_d/2-socket_thickness, 0]) {
                  cube([arm_l * spring_l, spring_thickness, outer_ring_height]);
                }
              }
            }
          }
          difference() {
            // Socket body
            for (n = [0:arms]) {
              nth_axle_transform(n) {
                cylinder(d = axle_d + (socket_thickness * 2), h=outer_ring_height);
              }
            }
            // Arm cutouts
            for (n = [0:arms]) {
              nth_axle_transform(n) {
                union() {
                  translate([0,0,-1]) {
                    rotate(min_rotation())
                      arm(arm_h = outer_ring_height + 2,
                          arm_w = arm_w + (separation_gap * 2));
                  }
                  translate([0,0,-1]) {
                    rotate(max_rotation())
                      arm(arm_h = outer_ring_height + 2, 
                          arm_w = arm_w + (spring_thickness * 2));
                  }
                }
              }
            }
          }
        }
      }
    }
    //  Socket bores
    for (n = [0:arms]) {
      nth_axle_transform(n) {
        translate([0, 0, -1]) {
          cylinder(d = axle_d + (separation_gap * 2), h=outer_ring_height + 2);
        }
      }
    }
  }
}


module nth_arm(
  n = 0,
  arms = arms,
  rotation=min_rotation(),
  arm_h = arm_h,
  arm_l = arm_l,
  arm_w = arm_w) {

  nth_axle_transform(n, arms=arms) {
    rotate([0, 0, rotation]) {
      arm(
        arm_h = arm_h,
        arm_l = arm_l,
        arm_w = arm_w);
    }
  }
}

module inner(
  inner_ring_diameter = inner_ring_diameter,
  inner_ring_height = inner_ring_height) {
  
  inner_ring_r = inner_ring_diameter / 2;
  
  color([1, 1, 0]) {
    difference() {
      cylinder(r = inner_ring_r, h = inner_ring_height);
      translate([0, 0, -1]) {
        for (n = [0:arms*tooth_multiplier]) {
          nth_arm(n,
                  arms = arms * tooth_multiplier,
                  arm_h = inner_ring_height + 2, 
                  arm_l = arm_l + separation_gap,
                  arm_w = arm_w + separation_gap * 2);
        }
      }
    }
  }
}

module cap(
  outer_ring_diameter = outer_ring_diameter,
  outer_ring_thickness = outer_ring_thickness,
  outer_ring_brim_thickness = outer_ring_brim_thickness,
  cap_thickness = cap_thickness,
  cap_dimple_thickness = cap_dimple_thickness,
  cap_clearance_hole_d = cap_clearance_hole_d,
  cap_counterbore_d = cap_counterbore_d,
  cap_counterbore_thickness = cap_counterbore_thickness,
  flanges = flanges,
  flange_width = flange_width,
  flange_thickness = flange_thickness,
  flange_hole_diameter = flange_hole_diameter
  ) {
  difference() {
    union() {
      cylinder(d = outer_ring_diameter, h = cap_thickness);
      // nubs
      for (n = [0:arms]) {
        nth_axle_transform(n) {
          cylinder(d=axle_d, h = cap_dimple_thickness + cap_thickness);
        }
      }
      // Flanges
      for (angle = [0:360/flanges:360]) {
        rotate([0,0,angle]) {
          difference() {
            translate([0, -flange_width / 2, 0]) {
              difference() {
                cube([flange_width + outer_ring_diameter / 2, flange_width,  flange_thickness]);
                translate([(flange_width + outer_ring_diameter)/2, flange_width/2, -0.05]) {
                  cylinder(d=flange_hole_diameter, h = flange_thickness + 0.1);
                }
              }
            }
            translate([0,0,-0.05]) {
              cylinder(d=outer_ring_diameter, h = outer_ring_height + 0.1);
            }
          }
        }
      }
    }
    for (n = [0:arms]) {
      rotate((n+0.5)*360/arms) {
        translate([0, 
                   (outer_ring_diameter/2) 
                   + outer_ring_thickness 
                   - (outer_ring_brim_thickness/2), 
                   -1]) {
          union() {
            cylinder(h=cap_thickness + 2, d = cap_clearance_hole_d);
            cylinder(d1 = cap_counterbore_d, 
                     d2 = cap_clearance_hole_d,
                     h = cap_counterbore_thickness);
          }
        }
      }
    }

  }
}

module cap_with_holes() {
  difference() {
    union() {
      cap();
      cylinder(h=cap_thickness+cap_dimple_thickness, d = 28);
    }
    translate([0,0,-1]) {
      cylinder(h=cap_thickness + cap_dimple_thickness + 2, d = 24);
    }
  }
}

module outer_with_holes() {
  difference() {
    outer();
    // Pilot holes
    for (n = [0:arms]) {
      rotate([0, 0, ((n+0.5)/arms) * 360]) {
        translate([outer_ring_r 
                   + outer_ring_thickness 
                   - (outer_ring_brim_thickness/2),
                   0,
                   -1]) {
          cylinder(h=outer_ring_height + 2, d = cap_screw_pilot_d);
        }
      }
    }
  }
}

module ratchet_assembly() {
  let (washer_thickness = 1.5) {
    let (inner_height = inner_ring_height - 2 * washer_thickness) {
      with_square_nut(inner_ring_diameter * 0.5 - 5,
                      thickness = inner_height,
                      gap_w = separation_gap,
                      bore_d = inches(1/2),
                      pin_head_dia = 0,
                      pin_head_depth = 0) { 
        union() {
          difference() {
            inner(inner_ring_height = inner_height);
            difference() {
              cylinder(h=inner_ring_height+1, d = inner_ring_diameter + 1);
              cylinder(h=inner_ring_height+1, d = inner_ring_diameter - 2);
            }
            /* // Center bore */
            /* translate([0,0,-1]) { */
            /*   cylinder(h=inner_ring_height + 2, d = 9 + separation_gap, $fn = 48); */
            /* } */
          }

          outer_with_holes();

          for (n = [0:arms]) {
            nth_arm(n, rotation=min_rotation());
          }
        }
      }
    }
  }
}

ratchet_assembly();
translate([0, 0, -cap_thickness]) {
  cap_with_holes();
}



// outer();

// arm();
