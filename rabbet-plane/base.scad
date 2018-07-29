include <../lib/common.scad>;

overall_length = 240;
overall_width = 26;
overall_height = 60;
through_slot_length = 30;
ejection_hole_diameter = 30;
ejection_mouth_width = 5;
iron_position = 75;
iron_bed_angle = 45;
iron_clearance_angle = 20;
iron_narrow_width = 10;
iron_wide_length = 38;
iron_thickness = 3;
epsilon = 0.01;
wedge_angle = 10;
wedge_opening = 5;
wedge_length = 90;
wedge_width = iron_narrow_width * 0.8;
wedge_knob_radius = 11.7;
// 0.0 means the wedge is meant to go all the way to the bottom of the
// plane. 1.0 means that it stops at th etop of the ejection hole.
wedge_protrusion = 0.2; 

module wedge_poly(opening, theta1, theta2, length) {
  polygon([[0, 0],
           [opening,0],
           [length*cos(theta1)+opening, length*sin(theta1)],
           [length*cos(theta2), length*sin(theta2)]]);
}

module wedge_position() {
    translate([0, cos(iron_bed_angle)*through_slot_length*wedge_protrusion, sin(iron_bed_angle)*through_slot_length*wedge_protrusion]) {
      translate([overall_width/2-iron_narrow_width/2,iron_position,-epsilon]) {
        rotate([90,0,0]) {
          rotate([0,90,0]) {
            children();
          }
        }
      }
    }
}

module plane_body( 
  slot_width = inches(0.75) + 0.35,
  slot_depth = 5,
  slot_offset = 6,
  mouth_width = iron_thickness * 0.2) {
  difference() {
    // Plane body
    cube([overall_width-2*epsilon,overall_length,overall_height]);
    // Ejection hole
    translate([0, cos(iron_bed_angle+90)*ejection_hole_diameter/2.5, sin(iron_bed_angle+90)*ejection_hole_diameter/2.5]) {
      translate([0, cos(iron_bed_angle)*through_slot_length/2, sin(iron_bed_angle)*through_slot_length/2]) {
        translate([-epsilon,iron_position,0]) {
          rotate([0,90,0]) {
            cylinder(r1=ejection_hole_diameter/2,r2=ejection_hole_diameter/2,h=overall_width+2*epsilon);
          }
        }
      }
    }
    // Iron bed slot
    translate([-epsilon,iron_position,-epsilon]) {
      rotate([-iron_bed_angle, 0, 0]) {
        cube([overall_width,iron_thickness+mouth_width,iron_wide_length+iron_thickness*sin(iron_bed_angle)+2]);
      }
      /* rotate([90,0,0]) { */
      /*   rotate([0,90,0]) { */
      /*     linear_extrude(height=overall_width+2*epsilon) { */
      /*       wedge_poly(ejection_mouth_width,iron_bed_angle,iron_bed_angle+iron_clearance_angle,through_slot_length); */
      /*     } */
      /*   } */
      /* } */
    }
    // Wedge hole
    wedge_position() {
      linear_extrude(height=iron_narrow_width) {
        wedge_poly(wedge_opening, iron_bed_angle, iron_bed_angle+wedge_angle, wedge_length);
      }
    }
    // Reinforcement slot 1
    translate([-epsilon, -epsilon, overall_height - slot_width - slot_offset]) {
      cube([slot_depth+epsilon, overall_length+2*epsilon, slot_width]);
    }
    // Reinforcement slot 2
    translate([overall_width-slot_depth, -epsilon, overall_height - slot_width - slot_offset]) {
      cube([slot_depth+epsilon, overall_length+2*epsilon, slot_width]);
    }
    /* // Alignment hole 1 */
    /* translate([-epsilon, overall_length/4, overall_height/2]) { */
    /*   rotate([0,90,0]) { */
    /*     cylinder(d=1.75+0.35, h=100); */
    /*   } */
    /* } */
  }
}

/* I have to to this because I haven't figured out how to make the
 * export comment work when there are parameters. */
module plane_body2() { // export
  plane_body();
}

module wedge() { // export
  union() {
    translate([wedge_length*cos(iron_bed_angle+wedge_angle/2),wedge_length*sin(iron_bed_angle+wedge_angle/2)]) {
      // TODO: Make diameter parametric
      cylinder(h=wedge_width,r=wedge_knob_radius);
    }
    linear_extrude(height=wedge_width) {
      wedge_poly(wedge_opening, iron_bed_angle, iron_bed_angle+wedge_angle, wedge_length);
    }
  }
}

module both() {
  color([0.5,0.3,0,1]) plane_body();
  wedge_position() {
    color([1,0,0,1]) wedge();
  }
}

module body_right() {
  difference() {
    translate([0,0,overall_width/2]) {
      rotate([0,90,0]) {
        plane_body();
      }
    }
    xy(below=0);
  }
}

module body_left() {
  difference() {
    translate([overall_height,0,-overall_width/2]) {
      rotate([0,-90,0]) {
        plane_body();
      }
    }
    xy(below=0);
  }
}

display(overall_height * 1.3, 10, 2) {
  text("body"); plane_body();
  text("wedge"); wedge();
}
