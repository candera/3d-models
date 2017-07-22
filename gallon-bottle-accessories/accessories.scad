use <threads.scad>;

$fn=96;
wall_thickness=2.5;
bottle_inner_d=27.4;
bottle_outer_d=35;
thread_depth=1.1;
// thread_width=3.28;
thread_width=3.75; 
thread_pitch=4; // Per revolution
cap_inner_height=9.6;
air_inlet_d=6;
spout_height=30;
funnel_height=60;
stop_ring_height=5;
extrusion_width=0.35;
stop_ring_spacing=extrusion_width/2;
output_height=90;
e=0.02;
e2=e/2;

module hollow_cylinder(h,d_inner,d_outer) {
  difference() {
    cylinder(h=h,d=d_outer);
    translate([0,0,-e2]) {
      cylinder(h=h+e, d=d_inner);
    }
  }
}

module spout() {
  hollow_cylinder(h=spout_height,
                  d_outer=bottle_inner_d,
                  d_inner=bottle_inner_d-wall_thickness);
}

module funnel() {
  difference() {
    cylinder(h=funnel_height,d1=bottle_inner_d, d2=bottle_inner_d+funnel_height);
    translate([0,0,-e2]){
      cylinder(h=funnel_height+e,d1=bottle_inner_d-wall_thickness, d2=bottle_inner_d+funnel_height-wall_thickness);
    }
  }
}

module lip() {
  difference() {
    rotate_extrude(angle=360) {
      translate([(bottle_inner_d+funnel_height-wall_thickness)/2,0,0]) {
        circle(wall_thickness);
      }
    }
    translate([0,0,funnel_height+wall_thickness/2]) {
      cube([2*funnel_height,2*funnel_height,2*funnel_height], center=true);
    }
  }
}

module funnel() {
  translate([0,0,spout_height+funnel_height]) {
    rotate([180,0,0]) {
      union() {
        spout();
        translate([0,0,spout_height]) {
          funnel();
        }
        translate([0,0,spout_height+funnel_height]) {
          lip();
        }
      }
    }
  }
}

module stop_ring() {
  hollow_cylinder(h=stop_ring_height, 
                  d_inner=bottle_inner_d-wall_thickness+stop_ring_spacing,
                  d_outer=bottle_inner_d+wall_thickness+stop_ring_spacing);
}

module output() {
  difference() {
    hollow_cylinder(h=output_height,
                    d_inner=bottle_inner_d-wall_thickness,
                    d_outer=bottle_inner_d);
    translate([0,0,output_height-bottle_inner_d/2]) {
      rotate([45,0,0]) {
        translate([0,0,output_height/2]) {
          cube([bottle_inner_d*10, bottle_inner_d*10, output_height], center=true);
        }
      }
    }
  }
}

module air_inlet() {
  hollow_cylinder(h=output_height,
                  d_inner=air_inlet_d,
                  d_outer=air_inlet_d+wall_thickness);
}

module pourspout() {
  union() {
    output();
    translate([0,
               (air_inlet_d + wall_thickness - bottle_inner_d)/2,
               0]) {
      air_inlet();
    }
  }
}

module cap() {
  union() {
    hollow_cylinder(h=bottle_inner_d*1.75,
                    d_inner=bottle_inner_d + extrusion_width,
                    d_outer=bottle_inner_d + extrusion_width + wall_thickness * 2);
    cylinder(h=wall_thickness*2, d=bottle_inner_d + extrusion_width + wall_thickness * 2);
  }
}

module threaded_cap() {
  union() {
    translate([0, 0, cap_inner_height+wall_thickness]) {
      hollow_cylinder(h=wall_thickness*2,
                      d_outer=bottle_outer_d+wall_thickness+thread_width+extrusion_width,
                      d_inner=bottle_inner_d+extrusion_width/2);
    }
    difference() {
      hollow_cylinder(h=cap_inner_height+wall_thickness,
                      d_inner=bottle_outer_d+extrusion_width/2,
                      d_outer=bottle_outer_d+wall_thickness+thread_width+extrusion_width);
      translate([0,0,-e]) {
        metric_thread(diameter=bottle_outer_d+thread_width+extrusion_width,
                      pitch=thread_pitch,
                      length=cap_inner_height*2,
                      thread_size=thread_width);
      }
    }
  }
}

/* funnel(); */

/* pourspout(); */
/* translate([bottle_inner_d+2*wall_thickness,0,0]) stop_ring(); */
/* translate([-(bottle_inner_d+2*wall_thickness),0,0]) cap(); */

threaded_cap();
