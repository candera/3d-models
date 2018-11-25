include <../lib/common.scad>
include <../lib/pulley.scad>

$fn = 100;

overall_h = ledge_w + bearing_h;
wheel_r = bearing_d / 2 + 3.5;
outer_w = inches(1.5);
inner_w = bearing_d;
chamfer_size = 0.4;

module square_housing() {
  outer_w = outer_w * sqrt(2) / 2;
  inner_w = inner_w * sqrt(2) / 2;
  rotate([0,0,45])
  rotate_extrude($fn = 4) {
    polygon(points=[[inner_w + chamfer_size, 0],
                    [inner_w, chamfer_size],
                    [inner_w, overall_h],
                    [outer_w, overall_h],
                    [outer_w, chamfer_size],
                    [outer_w - chamfer_size, 0]
              ]);
  }
}

union() {
  pulley(theta = 0,
         lip_h = overall_h/2);
  square_housing();  
}
