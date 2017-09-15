// &> /dev/null; openscad -o $1 $0; exit # An example of a self-rendering OpenSCAD file
// Settings for saw guide itself
/* ratio = 6; // 6:1 */
/* angle = atan(1/ratio); */
/* epsilon = 0.01; */
/* overall_length = 45; */
/* overall_width = 45; */
/* overall_height = 45; */
/* wall_thickness = 18; */
/* magnet_diameter = 8.2; */
/* magnet_thickness = 3.2; */

// Settings for marking gauge
ratio = 6; // 6:1
angle = atan(1/ratio);
epsilon = 0.01;
overall_length = 30;
overall_width = 30;
overall_height = 30;
wall_thickness = 5;
magnet_diameter = 8.2;
magnet_thickness = 0;


$fn=48;

/* Project notes:
   - The Lee Valley one is a bit different:
     http://www.leevalley.com/us/wood/page.aspx?cat=1,42884&p=41718.
     I like the integral clamp.

/* Printing notes:
   - The text did not turn out when facing down.
   - The little marking gauge looks like it needs to print on a raft -
     got a bit of lifting at the edges.
*/

module nubbed_cube() {
  union() {
    cube([overall_length*2, overall_width, overall_height*2]);
    translate([wall_thickness/2,overall_width+magnet_thickness-epsilon,wall_thickness/2]) {
      rotate([90,0,0]) {
        cylinder(d=magnet_diameter,h=magnet_thickness*2+overall_width);
      }
    }
    translate([overall_length-wall_thickness/2,overall_width+magnet_thickness-epsilon,wall_thickness/2]) {
      rotate([90,0,0]) {
        cylinder(d=magnet_diameter,h=magnet_thickness*2+overall_width);
      }
    }
    translate([wall_thickness/2,overall_width+magnet_thickness-epsilon,overall_height-wall_thickness/2]) {
      rotate([90,0,0]) {
        cylinder(d=magnet_diameter,h=magnet_thickness*2+overall_width);
      }
    }
  }
}

module guide() {
  difference() {
    cube([overall_length, overall_width, overall_height]);
    translate([wall_thickness,-epsilon,wall_thickness]) {
      cube([overall_length+2*epsilon,overall_width+2*epsilon,overall_height+2*epsilon]);
    }
    rotate([0,0,angle]) {
      translate([0, -overall_width, -epsilon]) {
        union () {
          color([1,0,0,1]) {
            nubbed_cube();
          }
        }
      }
    }
    translate([0, overall_width, -epsilon]) {
      color([0,1,0,1]) {
        rotate([0,0,-angle]) {
          nubbed_cube();
        }
      }
    }
    translate([overall_width/2,overall_length/2,-epsilon]) {
      mirror() {
        rotate([0,0,-90]) {
          linear_extrude(height=1) {
            text(text=str(ratio, ":1"),valign="bottom",halign="center");
          }
        }
      }
    }
  }
}

guide();
// nubbed_cube();


