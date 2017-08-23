include <../common.scad>;

extrusion_width=0.36;
inside_width=18;
wall_thickness=extrusion_width*4;
outside_width=inside_width+wall_thickness*2;
barb_extension=1.25;
barb_slope=3;
barb_length=barb_extension*barb_slope;
length=25;
height=30;

module barb() {
  difference() {
    scale([1,3,1]) {
      linear_extrude(height=length) {
        right_triangle(lx=wall_thickness*2,ly=wall_thickness*2);
      }
    }
    translate([-epsilon,wall_thickness*3,-epsilon/2])
      cube([wall_thickness*3,wall_thickness*10,height+epsilon]);
  }
}

module barb() {
  linear_extrude(height=length) {
    polygon([[0,0],
             [wall_thickness+barb_extension,0],
             [wall_thickness,barb_length],
             [0,barb_length]]);
  }
}

union() {
  difference() {
    cube([outside_width, height, length]);
    translate([(outside_width-inside_width)/2,
               -epsilon,
               -epsilon/2]) {
      cube([inside_width, height-wall_thickness+epsilon, length+epsilon]);
    }
  }
  mirror([0,1,0]) {
    barb();
  }
  translate([outside_width,0,0]) {
    mirror([0,1,0]) {
      mirror([1,0,0]) {
        barb();
      }
    }
  }
}
