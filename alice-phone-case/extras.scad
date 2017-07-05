epsilon=0.01;
ring_r=4;
ring_t=1.5;
ring_h=5;
letter_size=4;

$fn=48;

module case () {
  // import("s4_case_template.stl");
  import("stl_fixed_s4_case_template/fixed.stl");
}

module eyelet () {
  difference() {
    scale([3,1,1]) {
      union() {
        cylinder(r=ring_r, h=ring_h);
        translate([-ring_r,0,0]) {
          cube([ring_r*2, ring_r, ring_h]);
        }
      }
    }
    translate([0,0,-epsilon]) {
      scale([1,1,1+epsilon]) {
        union() {
          translate([-ring_r,-ring_r/2,0]) {
            cube([ring_r*2, ring_r, ring_h]);
          }
          translate([-ring_r,0,0]) {
            cylinder(r=ring_r/2, h=ring_h+2*epsilon);
          }
          translate([ring_r,0,0]) {
            cylinder(r=ring_r/2, h=ring_h+2*epsilon);
          }

        }
      }
    }
          
                 

    /* translate([0,0,-epsilon]) */
    /*   cylinder(r=ring_r-ring_t, h=ring_h+2*epsilon); */
    
  }
}

module monogram () {
  linear_extrude(height=5) {
    text("A", font="Comic Sans MS");
  }
}

module unit () {
  difference () {
    case();
    translate([-20,-5,-1]) {
      scale([letter_size, letter_size, letter_size]) {
        rotate([0,0,-90]) {
          mirror() {
            monogram();
          }
        }
      }
    }
  }
}

union() {
//  case();
  //monogram();
  eyelet();
}
