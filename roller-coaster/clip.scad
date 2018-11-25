include <../lib/common.scad>

extrusion_width = 0.4;

ball_d = inches(1);
wire_d = 1.75 + extrusion_width;
clip_t = 5;
clip_h = 5;
track_clearance = 0.2;
plate_h = 10;
plate_l = 20;
plate_t = clip_t;
plate_bore_d = 1.5;

$fn = 96;

if ($preview) 
#sphere(d = ball_d);

/*
  for (a = [0,90]) {
  rotate([0,0,a]) {
    translate([0,-(ball_d + wire_d) / 2, -clip_h / 2]) {
      difference() {
        cylinder(
          d = wire_d + clip_t * 2,
          h = clip_h);
        translate([0,0,-1]) {
          cylinder(
            d = wire_d + extrusion_width,
            h = clip_h + 2);
        }
        translate([0,
                   ((wire_d + clip_t + 2) / 2) + (wire_overlap * wire_d * 0.5),
                   clip_h/2-1]) {
          cube([wire_d + clip_t + 2,wire_d + clip_t + 2,clip_h + 3], center = true);
        }
      }
    }
  }
}
*/

union() {
  let (wire_center = (ball_d + wire_d) / 2)
  {
    translate([0,0,-clip_h /2]) {
      intersection() {
        difference() {
          cylinder(d = ball_d + wire_d + clip_t, h = clip_h);
          translate([0,0,-1]) {
            cylinder(d = ball_d + track_clearance * 2, h = clip_h + 2);
          }
          for (a = [10,80]) {
            rotate([0,0,-a]) {
              translate([0,wire_center,-1]) {
                #cylinder(d = wire_d,
                          h = clip_h + 2);
              }
            }
          }
        }
        cube([ball_d, ball_d, clip_h]);
      }
    }
    translate([-plate_t,(ball_d / 2) + track_clearance,-clip_h/2]) {
      difference() {
        cube([plate_t,plate_l,plate_h]);
        for (offset = [0.3,0.8]) {
          rotate([0,90,0]) {
            translate([-plate_h/2,plate_l * offset,-1]) {
              cylinder(d = plate_bore_d, h = plate_t + 2);
            }
          }
        }
      }
    }
  }
}
