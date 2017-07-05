cutter_length = 100;
cutter_diameter = 15;
crayon_diameter = 10;
slit_thickness = 0.8;
wall_thickness = 5;
handle_length = cutter_length * 0.5;
handle_width = 25;
epsilon = 0.01;

union () {
     difference() {
          translate([-cutter_diameter/2, -cutter_diameter/2, 0]) {
               cube([cutter_diameter, cutter_diameter, cutter_length]);
          }
          translate([0, 0, wall_thickness + epsilon]) {
               cylinder(d=crayon_diameter, h=(cutter_length - wall_thickness));
          }
          translate([-cutter_diameter/2-epsilon, -slit_thickness/2, -epsilon]) {
               cube([cutter_diameter/2, slit_thickness, cutter_length+2*epsilon]);
          }
     }
     translate([0,cutter_diameter/2,0]) {
          cube([cutter_diameter/2,handle_width,handle_length]);
     }
     translate([0,-cutter_diameter/2-handle_width,0]) {
          cube([cutter_diameter/2,handle_width,handle_length]);
     }
         
}


