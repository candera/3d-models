include <common.scad>;

module square_nut(length = 10,
                  width = 10,
                  height = 10,
                  pin_d = 0,
                  pin_head_dia = 6,
                  pin_head_depth = 4,
                  bore_d = 0) { 
  rotate([90,0,0]) {
    difference() {
      rotate([90, 0, 0]) {
        union() {
          cube([length, width, height], center=true);
        }
      }
      // bore
      rotate([90,0,0]) {
        translate([0,0,-1]) {
          cylinder(h=height + 10, d = bore_d, center = true);
        }
      }
      // pin bore
      translate([0, 0, -1]) {
        cylinder(h=width + 4, d = pin_d, center=true);
      }
      // pin head
      translate([0, 0, (pin_head_depth-length)/2 - 0.01]) {
        cylinder(h=pin_head_depth, d = pin_head_dia, center=true);
      }
    }
  }
}

module with_square_nut(size, thickness, gap_w = 0.5, notch_w = 5, notch_d = 2, bore_d = 0, pin_head_dia = 0, pin_head_depth = 0, pin_d = inches(9/64)) {
  union() {
    translate([0,0,thickness/2]) {
      square_nut(length = size,
                 width = size,
                 height = thickness,
                 pin_d = pin_d,
                 pin_head_dia = pin_head_dia,
                 pin_head_depth = pin_head_depth,
                 bore_d = bore_d
        );
    }
    difference() {
      children();
      translate([0,0,(thickness/2)-1]) {
        square_nut(length=size + gap_w * 2,
                   width=size + gap_w * 2,
                   height=thickness + 4,
                   pin_d = 0,
                   pin_head_dia = 0,
                   pin_head_depth = 0
          );
      }
      for (angle = [-90, 90]) {
        rotate([0,0,angle]) {
          translate([size/2 + gap_w + notch_d/2 - 0.01, 0, thickness / 2 ]) {
            cube([notch_d, notch_w, thickness + 2], center = true);
          }
        }
      }
    }
  }
}

