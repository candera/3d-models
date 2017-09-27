use <../lib/common.scad>;
use <../lib/dovetails.scad>;

epsilon = 0.001;

/* box_length=80; */
/* box_width=box_length * 0.6; */
/* box_height=box_length / 3; */
/* wall_thickness = 2; */

box_length=60;
box_width=40;
box_height=box_length / 3;
wall_thickness = 2;
top_thickness = wall_thickness * 1.5;

bottom_rabbet_depth = wall_thickness / 2;
bottom_rabbet_height = wall_thickness;

// How big the hinge pin is compared to the wall thickness
hinge_proportion = 0.6;

$fn = 24;

// How much space we leave around the tails/pins so they fit
fit_gap = 0.35;

tail_count = round(box_height / 5 / wall_thickness);
angle = 15;

module miter_profile(length, height) {
  w = length;
  h = height;
  polygon(points = [[0,0],
                    [w,0],
                    [w-h,h],
                    [h,h]]);
}

module end_beveled_board(length, width, thickness) {
  translate([0,0,0]) {
    rotate([90,0,90]) {
      linear_extrude(height=width) {
        miter_profile(length, thickness);
      }
    }
  }
}

module tail_board(length, width, thickness) {
  tail_width = width * 0.5 / tail_count - fit_gap;
  pin_width = pin_width(tail_width = tail_width, tail_count=tail_count, board_width=box_height);
  board_with_dovetail_tails(
    board_length=length,
    board_width=width,
    board_thickness=thickness,
    tail_length=thickness,
    tail_width=tail_width,
    pin_width=pin_width,
    tail_count=tail_count,
    angle=angle
    );
}

module pin_board(length, width, thickness) {
  tail_width = width * 0.5 / tail_count;
  pin_width = pin_width(tail_width = tail_width, tail_count=tail_count, board_width=box_height);
  board_with_dovetail_pins(
    board_length=length,
    board_width=width,
    board_thickness=thickness,
    pin_length=thickness,
    tail_width=tail_width,
    pin_width=pin_width,
    pin_count=tail_count + 1,
    angle=angle
    );
}


module mitered_dovetail_tail_board(length, width, thickness) {
  union() {
    tail_board(length, width, thickness);
    end_beveled_board(length, width, thickness);
  }
}

module mitered_dovetail_pin_board(length, width, thickness) {
  union() {
    translate([0,0,thickness]) {
      mirror([0,0,-1]) {
        pin_board(length, width, thickness);
      }
    }
    end_beveled_board(length, width, thickness);
  }
}


module side() { 
  union() {
    difference() {
      //mitered_dovetail_tail_board(box_length, box_height, wall_thickness);
      tail_board(box_length, box_height, wall_thickness);
      // Bottom rabbet
      translate([-epsilon*2,wall_thickness-epsilon,wall_thickness - bottom_rabbet_depth+epsilon]) {
        cube([bottom_rabbet_height+epsilon, box_length-2*wall_thickness+2*epsilon, bottom_rabbet_depth]);
      }
    }
    // hinge pin
    translate([box_height-wall_thickness/2,wall_thickness * 1.5,wall_thickness]) {
      cylinder(h=wall_thickness, d=wall_thickness * hinge_proportion);
    }
    // lid support
    translate([box_height-wall_thickness*2, wall_thickness*3, wall_thickness]) {
      r = wall_thickness / 2;
      h= box_length-wall_thickness*5;
      translate([wall_thickness,h,0])
        mirror([1,0,0]) {
        rotate([90, 0, 0]) {
          quarter_cylinder(r=r, h=h);
        }
      }
    }
  }
}

module front() { // export
  difference() {
    //mitered_dovetail_pin_board(box_width, box_height, wall_thickness);
    translate([0,0,wall_thickness]) {
      mirror([0,0,1]) {
        pin_board(box_width, box_height, wall_thickness);
      }
    }
    // Bottom rabbet
    translate([-epsilon,wall_thickness+epsilon,wall_thickness - bottom_rabbet_depth+epsilon]) {
      cube([bottom_rabbet_height+epsilon, box_width-2*wall_thickness+2*epsilon, bottom_rabbet_depth]);
    }
  }
}

module left() { // export
  side();
}

module right() { // export
  translate([box_height, 0, 0]) {
    mirror([1,0,0]) {
      side();
    }
  }
}

module back() { // export
  front();
}

module lid() { // export
  l = box_length-wall_thickness;
  w = box_width-wall_thickness;
  difference() {
    union() {
      translate([0, top_thickness/2, 0]) {
        cube([w, l-top_thickness/2, top_thickness]);
      }
      translate([0,top_thickness/2,top_thickness/2]) {
        rotate([0,90,0]) {
          cylinder(r=top_thickness/2, h=w);
        }
      }
      cube([w,top_thickness/2,top_thickness/2]);
    }
    translate([-wall_thickness/2, top_thickness/2, top_thickness/2]) {
      rotate([0, 90, 0]) {
        cylinder(h=wall_thickness+fit_gap, d = fit_gap + wall_thickness * hinge_proportion);
      }
    }
    translate([w-wall_thickness/2, top_thickness/2, top_thickness/2]) {
      rotate([0, 90, 0]) {
        cylinder(h=wall_thickness+fit_gap, d = fit_gap + wall_thickness * hinge_proportion);
      }
    }
  }

}

display(box_width, 10, 2) {
  text("lid"); lid();
  text("left"); left();
  text("right"); right();
  text("front"); front();
  text("back"); back();
}
