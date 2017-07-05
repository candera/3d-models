body_length = 17.25;
body_width = 6.75;
height = 13;

cavity_diameter = 5;
cavity_elongation = 2.0;

hole_diameter = 2.5;
hole_offset = 4;

lip_diameter = 1.3;

epsilon = 0.01;

$fn=48;

module body () {
  cube([body_length, body_width, height]);
}

module cavity() {
  translate([body_length*0.6,cavity_diameter*0.45,0]){
    scale([cavity_elongation,1,1]) {
      translate([0,-epsilon,-epsilon]) {
        union() {
          cylinder(h=height+2*epsilon, d=cavity_diameter);
          translate([0,-cavity_diameter/2,0]) {
            cube([body_length,cavity_diameter,height+2*epsilon]);
          }
        }
      }
    }
  }
}

module lip() {
  translate([body_length*0.62-lip_diameter*0.5-cavity_diameter*0.5,
             lip_diameter*0.05,
             -epsilon]) {
    rotate(a=-10, v=[0,0,1]) {
      scale([1.75,1,1]) {
        cylinder(h=height+2*epsilon,d=lip_diameter);
      }
    }
  }
}

module hole() {
  translate([body_length-hole_offset,0,height/2]) {
    rotate(a=-90,v=[1,0,0]) {
      cylinder(h=body_width*2,d=hole_diameter);
    }
  }
}

intersection() {
  scale([2,1,1]) {
    translate([body_width,0,-epsilon]) {
      cylinder(r=body_width, h=height+2*epsilon);
    }
  }
  union() {
    difference() {
      body();
      cavity();
      hole();
    }
    lip();
  }
}

