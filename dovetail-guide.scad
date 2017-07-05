ratio = 6; // 6:1
angle = atan(1/ratio);
epsilon = 0.01;
overall_length = 110;
overall_width = 130;
overall_height = 110;
wall_thickness = 40;

difference() {
  cube([overall_length, overall_width, overall_height]);
  translate([wall_thickness,-epsilon,wall_thickness]) {
    cube([overall_length+2*epsilon,overall_width+2*epsilon,overall_height+2*epsilon]);
  }
  rotate([0,0,angle]) {
    translate([0, -overall_width, -epsilon]) {
      color([1,0,0,1]) {
        cube([overall_length*2, overall_width, overall_height*2]);
      }
    }
  }
  translate([0, overall_width, -epsilon]) {
    color([0,1,0,1]) {
      rotate([0,0,-angle]) {
        cube([overall_length*2, overall_width, overall_height*2]);
      }
    }
  }
}

