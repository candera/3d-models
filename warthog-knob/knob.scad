cap_top_radius=11;
cap_top_height=4.4;
step_height = 0.7;
num_steps = 5;
step_width = cap_top_radius / num_steps;
epsilon = 0.01;
cap_well_depth = (num_steps)*step_height;
slot_width=0.9;

tolerance=0.1;

$fn=96;

module cap_top() {
  union () {
    difference () {
      cylinder(r=cap_top_radius, h=cap_top_height);
      // Concavity in top
      translate([0,0,cap_top_height-cap_well_depth]) {
        cylinder(r1=0, r2=cap_top_radius, h=cap_well_depth+epsilon);
      }
    }
    for (i=[1:num_steps]) {
      translate([0,0,cap_top_height-(i*step_height)+epsilon]) {
        difference() {
          cylinder(r=cap_top_radius - (i-1)*step_width, h=step_height);
          translate([0,0,-epsilon]) {
            cylinder(r=cap_top_radius - i*step_width,h=step_height+2*epsilon);
          }
          if (i != num_steps) {
            for(i=[0:3]) {
              rotate([0,0,i*45]) {
                cube([slot_width, 4*cap_top_radius, 20*step_height], center=true);
              }
            }
          }
        }
      }
    }
  }
}

post_wall_thickness=0.6;
post_outer_diameter=6;
post_inner_radius=(post_outer_diameter/2)-post_wall_thickness;
base_radius=12.1/2;
cap_bottom_height = 1;
post_height=3.1;
post_base_flare=0.5;
post_flare_height=0.5;

module cap_bottom() {
  union() {
    cylinder(r=cap_top_radius, h=cap_bottom_height);
    // Post hole
    translate([0,0,cap_bottom_height]) {
      difference() {
        union() {
          cylinder(r=post_inner_radius+post_wall_thickness,
                   h=post_height);
          cylinder(r2=post_inner_radius+post_wall_thickness,
                   r1=post_inner_radius+post_wall_thickness+post_base_flare, 
                   h=post_flare_height);
        }
        cylinder(r=post_inner_radius + tolerance, h=post_height+epsilon);
      }
    }
  }
}

base_plate_height=1;
stud_width=2.3;
stud_depth = 2.5;
max_stud_depth = 3.0;
stud_flare=1.2;
base_collar_size=0;

module base() {
  difference () {
    union() {
      cylinder(r=base_radius, h=base_plate_height);
      translate([0,0,base_plate_height]) {
        union () {
          cylinder(r=post_inner_radius, h=post_height);
          cylinder(r1=post_inner_radius+base_collar_size, 
                   r2=post_inner_radius,
                   h=base_collar_size);
        }
      }
    }
    /* cube([stud_width + tolerance, stud_width + tolerance, 2*stud_depth + tolerance],  */
    /*      center=true); */
    translate([0,0,-epsilon]) {
      //intersection() {
        hull() {
          cube([stud_width*stud_flare, stud_width*stud_flare, epsilon], center=true);
          translate([0, 0, stud_depth + (stud_depth/(stud_flare - 1))])
            cube([epsilon, epsilon, epsilon], center=true);
          //        }
          //cube([base_radius*2, base_radius*2, max_stud_depth*2], center=true);
      }
      //cylinder(r1=post_inner_radius, r2=stud_width/3, h=stud_depth*3/2);
      //cylinder(r1=post_inner_radius, r2=0, h=post_height);
    }
  }
}

module switch() {
  union() {
    cylinder(r=8, h=1.5);
    translate([0, 0, 2.5]) cube([1.9, 1.9, 2.5], center=true);
  }
 }

module assembly() {
  translate([0,0,base_plate_height+post_height]) {
    rotate([0,180,0]) cap_bottom();
    cap_top();
  }
  base();
}

module guard() {
  difference() {
    cylinder(r=cap_top_radius + 5, 
             h=base_plate_height + post_height + cap_top_height);
    translate([0,0,base_plate_height]) {
      cylinder(r=cap_top_radius + 3,
             h=base_plate_height + post_height + cap_top_height);
    }
    translate([0,0,-epsilon]) {
      cylinder(r=base_radius + 2, 
               h=base_plate_height + post_height + 2*epsilon);
    }
  }
}

// Layout for the guard prototype
assembly();
color([1,0,0,0.7]) {
  guard();
}

// This is the layout for printing:
// 
// translate([45, 0, 0]) cap_top();
// translate([20, 0, 0]) cap_bottom();
// base();

/* switch(); */
