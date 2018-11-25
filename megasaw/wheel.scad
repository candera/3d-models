
$fn = 100;

bearing_d = 30.5;
bearing_h = 9;
ledge_w = 3.5;
pulley_min_d = bearing_d + 10;
theta_top = 50;          // How much the top side of the pulley curves
theta_bottom = 85;
lip_h = 2;
chamfer_size = 0.4;
shaft_d = 27;
shaft_r = shaft_d / 2;
shaft_steps = 20;

curve_h = shaft_d * sin((theta_top + theta_bottom)/2);

overall_h = curve_h + 2 * lip_h;

// ledge_h = (overall_h - bearing_h) / 2;
ledge_h = 4;
shaft_center_offset = shaft_r * cos((theta_top + theta_bottom)/2);

// DEBUG
// pulley_min_d = 200;
// DEBUG

include <../lib/pulley.scad>

pulley();

// Bushing
bearing_outer_rim = 2.5;
color([0,0,1])
translate([55, 0, 0])
difference() {
  cylinder(h=overall_h - bearing_h - lip_h, 
           d = bearing_d - 0.35);
  translate([0,0,-1]) {
    cylinder(h=overall_h, 
             d = bearing_d - bearing_outer_rim * 2);
  }
}
