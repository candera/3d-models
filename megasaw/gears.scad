include <../lib/common.scad>
include <MCAD/involute_gears.scad>

// bevel_gear_pair();
// gear(circular_pitch=100);
//test_double_helix_gear();
// meshing_double_helix();

$fn = 36;

extrusion_width = 0.4;

// If the circular_pitch matches, I think the gears will mesh.

// This determines the distance between centers
size = 2400 * 13;

ratio = 6/2;
teeth = 24;
circular_pitch = size / (ratio + 1) / teeth;
support_width = 26;
support_thickness = 0;
gear_thickness = 12;
pitch_diameter = teeth * circular_pitch / 180; // This is roughly the diameter of the smaller gear
bore_diameter = inches(5/16) + extrusion_width;

module a_gear(teeth, holes) {
  difference() {
    gear(number_of_teeth=teeth,
       gear_thickness = gear_thickness + support_thickness,
       hub_thickness = gear_thickness + support_thickness,
       rim_thickness = gear_thickness,
       circular_pitch=circular_pitch,
       circles = holes,
       bore_diameter = 0
    );
    translate([0,0,-1]) {
      cylinder(h = gear_thickness + support_thickness + 2, d = bore_diameter);
    }
  }
}

module small_gear() {
  a_gear(teeth=teeth, holes = 0);
}

module large_gear() {
  a_gear(teeth=teeth * ratio, holes = 8);
}

small_gear(); 
translate([0,
           (pitch_diameter / 2) 
           + (pitch_diameter * ratio / 2) 
           + (2 * extrusion_width)
           + 4,
           0]
  )
  rotate([0,0,(ratio % 2) * (180 / teeth)])
  large_gear();
