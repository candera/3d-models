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

ratio = 5/2;
teeth = 12;
circular_pitch = size / (ratio + 1) / teeth;
support_width = 26;
support_thickness = 0;

bolt_height = 11.15;
bolt_count = 2;
bolt_diameter = 21.65;

gear_thickness = bolt_height * bolt_count;
pitch_diameter = teeth * circular_pitch / 180; // This is roughly the diameter of the smaller gear
bore_diameter = bolt_diameter + extrusion_width;
pin_diameter = inches(1/8) + extrusion_width;
pin_head_diameter = pin_diameter * 1.4;
pin_head_depth = 10; /* Not sure how to calculate this. It measures
                      * from the pitch diameter, which is something
                      * like halfway along the teeth. */
pin_count = bolt_count;

wedge_taper = 1; // Amount the top is smaller than the bottom
wedge_gap = 2; // How much space between the two wedge halves
wedge_tightness = 0; // How much bigger the wedge is than the hole
wedge_size = inches(0.75);
wedge_height = gear_thickness;

module tapered_prism (
  w1, w2,
  l1, l2,
  h
  ) {
  w1h =  w1/2;
  w2h =  w2/2;
  l1h =  l1/2;
  l2h =  l2/2;

  polyhedron(
    points = [ [-w1h, -l1h, 0],
               [ w1h, -l1h, 0],
               [ w1h,  l1h, 0],
               [-w1h,  l1h, 0],
               [-w2h, -l2h, h],
               [ w2h, -l2h, h],
               [ w2h,  l2h, h],
               [-w2h,  l2h, h]],
    faces = [   [0,1,2,3],  // bottom
                [4,5,1,0],  // front
                [7,6,5,4],  // top
                [5,6,2,1],  // right
                [6,7,3,2],  // back
                [7,4,0,3]] // left
    );
}
    

module a_gear(ratio, teeth, holes) {
  difference() {
    gear(number_of_teeth=teeth,
         gear_thickness = gear_thickness + support_thickness,
         hub_thickness = gear_thickness + support_thickness,
         rim_thickness = gear_thickness,
         circular_pitch=circular_pitch,
         circles = holes,
         bore_diameter = 0
      );
    rotate([0,0,180/teeth]) {
      // Hex hole
      translate([0,0,-1]) {
        rotate([0,0,30]) {
          cylinder(h = gear_thickness + support_thickness + 2, 
                   d = bore_diameter,
                   $fn = 6);
        }
      }
      // Holes for pins
      for (pin_num=[0:pin_count-1]) {
        pin_height = (0.5 + pin_num) * (gear_thickness + support_thickness) / pin_count;
        rotate([0, 0, pin_num * 60]) {
          translate([(-pitch_diameter * ratio / 2),
                     0,
                     pin_height]) {
            rotate([0,90,0]) {
              union() {
                cylinder(h = pitch_diameter * ratio, d = pin_diameter);
                cylinder(h = pin_head_depth, d = pin_head_diameter);
                translate([0,0,pitch_diameter * ratio - pin_head_depth]) {
                  cylinder(h = pin_head_depth, d = pin_head_diameter);
                }
              }
            }
          }
        }
      }
    }
  }
}

module small_gear() {
  a_gear(ratio = 1, teeth=teeth, holes = 0);
}

module large_gear() {
  a_gear(ratio = ratio, teeth=teeth * ratio, holes = 8);
}

module wedge_socket() {
  translate([0,0,-0.01]) {
    tapered_prism(
      w1 = wedge_size,
      l1 = wedge_size,
      w2 = wedge_size - wedge_taper,
      l2 = wedge_size - wedge_taper,
      h = wedge_height + 0.02);
  }
}

module wedge() {
  difference() {
    tapered_prism(
      w1 = wedge_size + wedge_tightness,
      l1 = wedge_size + wedge_tightness,
      w2 = wedge_size - wedge_taper + wedge_tightness,
      l2 = wedge_size - wedge_taper + wedge_tightness,,
      h = wedge_height);
    translate([(wedge_size + wedge_tightness + 0.1) / -2,
               wedge_gap / -2,
               -0.1]) {
      cube([wedge_size + wedge_tightness + 0.1,
            wedge_gap,
            gear_thickness + 0.2]);
    }
    translate([0,0,-1]) {
      cylinder(h = gear_thickness + support_thickness + 2, d = bore_diameter);
    }

  }
}

small_gear();

translate([0,
           (pitch_diameter / 2)
           + (pitch_diameter * ratio / 2)
           + (2 * extrusion_width)
           + 8,
           0]
  )
rotate([0,0,(ratio % 2) * (180 / teeth)]) {
  large_gear();
}

/* translate([wedge_size, */
/*            - ((pitch_diameter / 2)  */
/*            + (pitch_diameter / 2)  */
/*            + (2 * extrusion_width) */
/*            + 4), */
/*            0] */
/*   ) */
/* wedge(); */

/* translate([-wedge_size, */
/*            - ((pitch_diameter / 2)  */
/*            + (pitch_diameter / 2)  */
/*            + (2 * extrusion_width) */
/*            + 4), */
/*            0] */
/*   ) */
/* wedge(); */


