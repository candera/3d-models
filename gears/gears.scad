include <../lib/common.scad>
include <../lib/square_nut.scad>
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

// ratio = 5/2;
ratio = 91/23;
teeth = 23;
circular_pitch = size / (ratio + 1) / teeth;
support_width = 26;
support_thickness = 0;

gap_w = 0.5; // Air space when parts need to be separate

bolt_height = 11.15;
bolt_count = 2;
bolt_diameter = 21.65;

threaded_rod_d = inches(1/2);
threaded_rod_tap_d = inches(27/64);

gear_thickness = bolt_height * 0.75;
combo_extra_thickness = 2; // Extra size for the small gear for clearance
pitch_diameter = teeth * circular_pitch / 180; // This is roughly the diameter of the smaller gear
bore_diameter = inches(27/64); // bolt_diameter + extrusion_width;
pin_diameter = inches(9/64);
pin_head_diameter = pin_diameter * 1.25;
pin_head_depth = 7; /* Not sure how to calculate this. It measures
                      * from the pitch diameter, which is something
                      * like halfway along the teeth. */
pin_count = bolt_count;

twist_angle = 30; // Nonzero for a helical gear

wedge_taper = 1; // Amount the top is smaller than the bottom
wedge_gap = 2; // How much space between the two wedge halves
wedge_tightness = 0; // How much bigger the wedge is than the hole
wedge_size = inches(0.75);
wedge_height = gear_thickness;

// Large gear holes
hole_quantities = [8, 16];
hole_distances = [0.5, 0.8]; // Percentage of radius
hole_radii = [0.15, 0.09]; // Percentage of gear size
hole_twists = [0, 0.5];

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

function gear_root_diameter(
  circular_pitch = circular_pitch,
  number_of_teeth = teeth,
  pressure_angle = 28,
  clearance = 0.2) =
  let(
	// Pitch diameter: Diameter of pitch circle.
	pitch_diameter  =  number_of_teeth * circular_pitch / 180,
	pitch_radius = pitch_diameter/2,
	// Base Circle
	base_radius = pitch_radius*cos(pressure_angle),
	// Diametrial pitch: Number of teeth per unit length.
	pitch_diametrial = number_of_teeth / pitch_diameter,
	// Addendum: Radial distance from pitch circle to outside circle.
	addendum = 1/pitch_diametrial,
	//Outer Circle
	outer_radius = pitch_radius+addendum,
	// Dedendum: Radial distance from pitch circle to root diameter
	dedendum = addendum + clearance,
	// Root diameter: Diameter of bottom of tooth spaces.
	root_radius = pitch_radius-dedendum
        )
  root_radius * 2;


module a_gear(ratio, teeth, holes, gear_thickness = gear_thickness) {
  module gear_half(gear_thickness = gear_thickness / 2) {
    gear(number_of_teeth=teeth,
         gear_thickness = gear_thickness + support_thickness,
         hub_thickness = gear_thickness + support_thickness,
         rim_thickness = gear_thickness,
         circular_pitch=circular_pitch,
         circles = holes,
         bore_diameter = 0,
         twist=sin(twist_angle) * gear_thickness / ratio);
  }
             
  difference() {
    translate([0,0,gear_thickness/2]) {
      union() {
        gear_half();
        mirror([0,0,1]) {
          gear_half();
        }
      }
    }
    echo("gear root diameter: ", gear_root_diameter(circular_pitch, teeth));
    /*
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
    */
  }
}

module small_gear(gear_thickness = gear_thickness) {
  a_gear(ratio = 1, teeth=teeth, holes = 0, gear_thickness = gear_thickness);
}

module large_gear(gear_thickness = gear_thickness, holes = 8) {
  a_gear(ratio = ratio, 
         teeth=teeth * ratio, 
         holes = holes, 
         gear_thickness = gear_thickness);
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

// small_gear();

function nut_size() = gear_root_diameter(circular_pitch, teeth) * 0.7 - 5;

module with_nut(thickness = gear_thickness) {
  let (nut_size = nut_size()) {
    with_square_nut(nut_size, thickness, gap_w = gap_w) {
      children();
    }
  }
}

module large_gear_with_bore_and_hub(spacer_height = 0, 
                                    spacer_d = 0, 
                                    spacer_sides = $fn) {
  difference() {
    union() {
      large_gear();
      translate([0,0,gear_thickness * 1.5 + spacer_height]) {
        difference() {
          cube([nut_size(), nut_size(), gear_thickness], center = true);
          rotate([90,0,0]) {
            cylinder(d=pin_diameter, h = nut_size() * 2, center = true);
          }
        }
      }
      translate([0,0,gear_thickness]) {
        cylinder(h = spacer_height, d = spacer_d, $fn = spacer_sides);
      }
    }
    translate([0,0,-1]) {
      cylinder(h=1000, d = bore_diameter);
    }
  }
}

module small_gear_with_square_hole() {
  difference() {
    small_gear();
    cube([nut_size(), nut_size(), gear_thickness * 2 + 1], center = true);
  }
}

module combo_gear() {
  difference() {
    union() {
      large_gear(holes=0);
      translate([0,0,gear_thickness]) {
        mirror([1,0,0]) {
          small_gear(gear_thickness = gear_thickness + combo_extra_thickness);
        }
      }
    }
    // pin bore
    translate([0,0,gear_thickness + pin_head_diameter / 2]) {
      rotate([0,90,0]) {
        union() {
          cylinder(h = pitch_diameter, d = pin_diameter, center=true);
          cylinder(h = pin_head_depth, d = pin_head_diameter, center=true);
          translate([0,0,(pitch_diameter - pin_head_depth + 3)/2]) {
            cylinder(h = pin_head_depth + 3, d = pin_head_diameter, center=true);
          }
        }
      }
    }
    // shaft bore
    translate([0,0,-1]) {
      cylinder(h = 1000, d = bore_diameter);
    }
    // Large gear holes
    for (i = [0:len(hole_distances)-1]) {
      let (
        gear_r = gear_root_diameter(number_of_teeth = teeth * ratio) /  2,
        radius = hole_radii[i] * gear_r,
        offset = hole_distances[i] * gear_r,
        twist = hole_twists[i],
        qty = hole_quantities[i]) {
        for (n = [0:qty-1]) {
          let (angle = (n + twist) * 360 / qty) {
            rotate([0,0,angle]) {
              translate([offset,0,0]) {
                cylinder(r = radius, h = (gear_thickness * 2) + 2, center=true);
              }
            }
          }
        }
      }
    }
  }
}

union() {
  combo_gear();

  translate([0,gear_root_diameter()*(ratio+2)/2, gear_thickness + combo_extra_thickness/2]) {
    // combo_gear();
  }
}

/*
small_gear_with_square_hole();

translate([0,
           (pitch_diameter / 2)
           + (pitch_diameter * ratio / 2)
           + (2 * extrusion_width)
           + 8,
           0]
  )
rotate([0,0,(ratio % 2) * (180 / teeth)]) {
  large_gear_with_bore_and_hub(spacer_height = 2, 
                               spacer_d = nut_size() * 1.5
                               // spacer_sides=6
    );
}

translate([0, -50, 0]) {
  square_nut(length = 40, 
             width = 40, 
             height = gear_thickness, 
             pin_d = inches(9/64),
             pin_head_dia = inches(18/64),
             pin_head_depth = 1,
             bore_d = inches(1/2));
}
*/

// translate([100, 0, 0]) square_nut(length=50, width = 50, height = 15);

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


