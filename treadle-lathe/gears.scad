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
size = 1800 * 13;

ratio = 29/13;
teeth = 13;
circular_pitch = size / (ratio + 1) / teeth;
support_width = 26;
support_thickness = 0;

nut_height = 11.15;
nut_count = 1.5; // Determines height
nut_diameter = 21.65;

gear_thickness = nut_height * nut_count;
pitch_diameter = teeth * circular_pitch / 180; // This is roughly the diameter of the smaller gear
shaft_diameter = inches(1/2);
pin_diameter = inches(9/64) + extrusion_width;
pin_head_diameter = pin_diameter * 1.4;
pin_head_depth = 10; /* Not sure how to calculate this. It measures
                      * from the pitch diameter, which is something
                      * like halfway along the teeth. */
pin_count = nut_count;

screw_clearance_diameter = inches(1/8);

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
    
module attachment_block() {
  
}

module a_gear(ratio, teeth, holes, rim_width = 5, clearance = 0.2) {
  // Diametrial pitch: Number of teeth per unit length.
  pitch_diametrial = teeth / pitch_diameter;

  // Addendum: Radial distance from pitch circle to outside circle.
  addendum = 1/pitch_diametrial;

  pitch_radius = pitch_diameter / 2;
  
  //Outer Circle
  outer_radius = pitch_radius + addendum;
  
  // Dedendum: Radial distance from pitch circle to root diameter
  dedendum = addendum + clearance;

  // Root diameter: Diameter of bottom of tooth spaces.
  root_radius = (pitch_radius-dedendum) * ratio;

  block_dimensions =
    let (
      height = gear_thickness, // (gear_thickness + nut_height) / 2,
      max_width = nut_diameter + 8,
      max_length = nut_diameter * 3,
      gear_interior = root_radius * 1.2,
      width = min(max_width, gear_interior),
      length = min(max_length, gear_interior)
      )
    [width, length, height];


  module block() {
    difference() {
      translate([0,0,block_dimensions[2]/2]) {
        difference() {
          // Base block
          cube(block_dimensions, center=true);
          // pin bore
          rotate([0, 90, 0]) {
            translate([0, 0, -1]) {
              cylinder(h = block_dimensions[2] + 2,
                       d = pin_diameter + extrusion_width * 2, 
                       center = true);
            }
          }
        }
      }
      // Nut bore
      translate([0, 0, -1]) {
        rotate([0,0,90]) {
          cylinder(d=nut_diameter, h=block_dimensions[2] + 2, $fn=6);
        }
      }
      /*
      // Screw bores
      rotate([0, 0, 0]) {
      for (factor = [-1,1]) {
      translate([0, factor * (bore_diameter + block_width) / 4 , pin_diameter * 1.5]) {
      cylinder(d = screw_clearance_diameter, h = pin_diameter * 3 + 2, center = true);
      }
      }
      }
      */
    }
  }

  /*
    translate([0,0,0.01 + gear_thickness - block_dimensions(0)[2]]) {
    color([0,1,0]) {
    difference() {
    union() {
    block(clearance = 0);
    let (base_height = ((gear_thickness - nut_height)) / 2 - 0.2)
    translate([0,0,base_height/2]) {
    cube([block_dimensions()[0], 
    block_dimensions()[1],
    base_height],
    center = true);
    }
    }
    // Bore hole
    translate([0,0,-1]) {
    cylinder(h = gear_thickness + support_thickness + 2, 
    d = shaft_diameter + extrusion_width);
    }
    }
    }
    }
  */
  
  difference() {
    gear(number_of_teeth=teeth,
         gear_thickness = gear_thickness + support_thickness,
         hub_thickness = gear_thickness + support_thickness,
         rim_thickness = gear_thickness,
         circular_pitch=circular_pitch,
         circles = holes,
         bore_diameter = 0,
         rim_width = rim_width,
         clearance = clearance
      );
    // Bore hole
    translate([0,0,-1]) {
      cylinder(h = gear_thickness + support_thickness + 2, 
               d = shaft_diameter + extrusion_width);
    }
    /*
    // Block hole
    translate([0, 0, -0.01 + gear_thickness - (block_dimensions(0)[2] * 0.5)]) {
    let (clearance = 0,
    dims = block_dimensions() + [clearance, clearance, 0.2]) {
    cube(dims, center=true);
    }
    }
    */
    // Pin clearance slot
    translate([0,0,gear_thickness/2 - 1]) {
      rotate([0,0,90]) {
        cube([pin_diameter + extrusion_width * 2, 
              nut_diameter + 6,
              gear_thickness + 4],
             center = true);
      }
    }
    // Nut bore
    translate([0, 0, -1]) {
      rotate([0,0,90]) {
        cylinder(d=nut_diameter + (extrusion_width * 2), h=gear_thickness + 2, $fn=6);
      }
    }

    
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

module small_gear() {
  a_gear(ratio = 1, teeth=teeth, holes = 0);
}

module large_gear(holes = 8, rim_width = 0) {
  a_gear(ratio = ratio, teeth=teeth * ratio, holes = holes, rim_width = rim_width);
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

module nut_drill_block() {
  difference() {
    translate([0,0,nut_height / 2]) {
      cube([nut_diameter + 35, nut_diameter + 15, nut_height], center=true);
    }
    translate([0,0,-1]) {
      cylinder(d=nut_diameter + extrusion_width * 3, h=nut_height + 2, $fn=6);
    }
    translate([0, (nut_diameter / 2) + 25/2, nut_height / 2]) {
      rotate([90,0,0]) {
        cylinder(d=pin_diameter, h=nut_diameter + 25);
      }
    }
  }
}

module dual_gear() {
  union() {
    rotate([0,0, (180 / teeth)]) {
      large_gear(holes=12, rim_width = -12);
    }
    rotate([0,0, (180 / (teeth * ratio))]) {
      translate([0,0,gear_thickness]) {
        small_gear();
      }
    }
  }
}

small_gear();

separation = (pitch_diameter / 2)
  + (pitch_diameter * ratio / 2)
  + (2 * extrusion_width)
  + 8;

translate([0, separation, 0]) {
  rotate([0,0,(ratio % 2) * (180 / teeth)]) {
    large_gear();
  }
}

/*
translate([separation, 0, 0]) {
  dual_gear();
}
*/


translate([-separation / ratio - 20 , 0, 0]) {
  nut_drill_block();
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

