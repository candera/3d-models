include <../lib/common.scad>;

$fn = 96;

e = epsilon;
e2 = 2 * epsilon;

// Dimensions of phone itself
s5_l = 142;
s5_w = 73;
s5_h = 8.5;
s5_r = 10; // Corner radius

wall_thickness = 2;

bezel_projection = 2; /* This is the amount the top bezel projects over the face of the phone */
bezel_height = 1;

// Overall case width
case_l = s5_l + wall_thickness*2;
case_w = s5_w + wall_thickness*2;
case_r = s5_r + wall_thickness;
case_vertical_r = 8.6;

// Holes for ports. Coordinate system is in reference to the
// lower-left edge of the phone as it sits face down and indicates the
// center of the hole for x and y, and the edge nearest the face for
// z. (It's just easier to measure that way.) Alignment = 0 for short
// edge holes and 90 for long edge holes.
port_z = 1.7;
button_margin = 1;
button_spacing = 0.25;
button_recess = wall_thickness*0.65;

s5_charge_w = 23;
s5_charge_h = 6;
s5_charge_r = 2.5;
s5_charge_x = s5_w/2;
s5_charge_y = 0;
s5_charge_z = port_z;
s5_charge_align = 0;

s5_mic_w = 3;
s5_mic_h = s5_mic_w;
s5_mic_r = s5_mic_w/2;
s5_mic_x = 51.5;
s5_mic_y = 0;
s5_mic_z = port_z;
s5_mic_align = 0;

s5_power_w = 13;
s5_power_h = 3;
s5_power_r = 1;
s5_power_x = 0;
s5_power_y = 101;
s5_power_z = port_z;
s5_power_align = 90;

s5_volume_w = 22.4;
s5_volume_h = 3;
s5_volume_r = 1;
s5_volume_x = s5_w;
s5_volume_y = 110;
s5_volume_z = port_z;
s5_volume_align = 90;

s5_phones_w = 6;
s5_phones_h = s5_phones_w;
s5_phones_r = s5_phones_w/2;
s5_phones_x = 18;
s5_phones_y = s5_l;
s5_phones_z = port_z;
s5_phones_align = 0;

// Not totally sure what this one is. On the top edge, looks like IR and baro?
s5_other_w = 8;
s5_other_h = 3;
s5_other_r = 1.5;
s5_other_x = 53;
s5_other_y = s5_l;
s5_other_z = port_z;
s5_other_align = 0;

// Alice's giant battery
battery_h = 11.5; // How much it projects behind the phone
battery_w = 61;
battery_l = 85;
battery_cutout_w = 16;
battery_cutout_l = 11;
battery_x = 5.2;
battery_y = 17.2;

// There are two openings at/near the camera. Not sure what the lower
// one is for. Flash?
camera_w = 13.4;
camera_top_l = camera_w;
camera_x = (s5_w - camera_w) / 2;
camera_top_y = s5_l - 10.9 - camera_w;
camera_top_r = 2.7; // Corner radius

camera_bottom_l = 6.5;
camera_spacing = 2.9; // Gap between top and bottom camera
camera_bottom_y = camera_top_y - camera_spacing - camera_bottom_l;

back_h = battery_h + wall_thickness;

top_extra = 5;
top_h = s5_h + top_extra;

module port(w, l, h, r, x, y, z, align) {
  h = h*2;
  translate([x, y, z])
    translate([0, 0, l/2]) 
    rotate([90, 0, align])
    translate([-w/2,-l/2,-h/2]) 
    rounded_prism(w, l, h, r);

}

// This is a sort of template for the body that includes protrusions
// for the buttons and ports that will need to be holes in anything
// that wraps around it.

module camera_port() {
  w = camera_w;
  l = camera_top_y - camera_bottom_y + camera_top_l;
  translate([camera_x, camera_bottom_y]) {
    translate([w/2, l/2, s5_h]) {
      linear_extrude(height=back_h+1,scale=1.5) {
        translate([-w/2, -l/2]) 
          rounded_rectangle(width=w, height=l, radius=camera_top_r);
      }
    }
  }
}

module battery() {
  translate([battery_x, battery_y, s5_h]) {
    difference() {
      cube([battery_w, battery_l, battery_h]);
      translate([-e,-e,-e]) {
        cube([battery_cutout_w+e2, battery_cutout_l+e2, battery_h+e2]);
      }
    }
  }
}

module s5_body () {
  union() {
    rounded_prism(s5_w, s5_l, s5_h, s5_r);
    port(s5_charge_w, s5_charge_h, wall_thickness+1, s5_charge_r, e+s5_charge_x, s5_charge_y, s5_charge_z, s5_charge_align);
    port(s5_mic_w,    s5_mic_h,    wall_thickness+1, s5_mic_r,    e+s5_mic_x,    s5_mic_y,    s5_mic_z,    s5_mic_align);
    port(s5_phones_w, s5_phones_h, wall_thickness+1, s5_phones_r, e+s5_phones_x, s5_phones_y, s5_phones_z, s5_phones_align);
    port(s5_other_w,  s5_other_h,  wall_thickness+1, s5_other_r,  e+s5_other_x,  s5_other_y,  s5_other_z,  s5_other_align);
    port(s5_power_w,  s5_power_h,  wall_thickness+1, s5_power_r,  e+s5_power_x,  s5_power_y,  s5_power_z,  s5_power_align);
    port(s5_volume_w, s5_volume_h, wall_thickness+1, s5_volume_r, e+s5_volume_x, s5_volume_y, s5_volume_z, s5_volume_align);
    port(s5_power_w+button_margin*2,
         s5_power_h+button_margin*2,
         button_recess,
         s5_power_r, 
         e+s5_power_x,
         s5_power_y,
         s5_power_z-button_margin,
         s5_power_align);
    port(s5_volume_w+button_margin*2,
         s5_volume_h+button_margin*2,
         button_recess,
         s5_volume_r, 
         e+s5_volume_x, 
         s5_volume_y, 
         s5_volume_z-button_margin, 
         s5_volume_align);
    camera_port();
    battery();      
  }
}

module hollow_rounded_prism(width, length, height, breadth, radius) {
  difference() {
    rounded_prism(width, length, height, radius);
    translate([breadth, breadth, -epsilon]) {
      rounded_prism(width-breadth*2, length-breadth*2, height + epsilon*2, radius-breadth);
    }
  }
}

module top_bezel_profile() {
  w = wall_thickness+bezel_projection;
  h = bezel_height;
  polygon(points = [[0,0],
                    [w,0],
                    [w-h,h],
                    [h,h]]);
}

module top_bezel_straight(length) {
  translate([0,length,0]) {
    rotate([90,0,0]) {
      linear_extrude(height=length) {
        top_bezel_profile();
      }
    }
  }
}

module top_bezel_curved(radius) {
  r = radius-bezel_projection-wall_thickness;
  rotate_extrude(angle=90) {
    translate([r, 0, 0]) {
      top_bezel_profile();
    }
  }
}

module top_bezel2() {
  bw = wall_thickness+bezel_projection; // bezel width
  r = case_r;
  w = case_w-2*r;
  l = case_l-2*r;
  union() {
    /* W  */ translate([0,r,0]) top_bezel_straight(l);
    /* SW */ translate([r,r,0]) rotate([0,0,180]) top_bezel_curved(r);
    /* S  */ translate([r,bw,0]) rotate([0,0,-90]) top_bezel_straight(w);
    /* SE */ translate([w+r,r,0]) rotate([0,0,-90]) top_bezel_curved(r);
    /* E  */ translate([w+2*r-bw,r,0]) top_bezel_straight(l);
    translate([0, s5_l+r, 0]) {
      mirror([0,1,0]) {
        /* NE */ translate([r,r+2*bw,0]) rotate([0,0,180]) top_bezel_curved(r);
        /* N  */ translate([r,3*bw,0]) rotate([0,0,-90]) top_bezel_straight(w);
        /* NW */ translate([w+r,r+2*bw,0]) rotate([0,0,-90]) top_bezel_curved(r);
      }
    }
  }
}

module top_bezel() {
  hollow_rounded_prism(width = s5_w+wall_thickness*2, 
                       length = s5_l+wall_thickness*2, 
                       height = wall_thickness, 
                       breadth = wall_thickness + bezel_projection, 
                       radius = s5_r+wall_thickness);
}

module charge_hole () {
  translate([-s5_charge_w/2, wall_thickness*5,0]) {
    rotate([90, 0, 0]) {
      rounded_prism(s5_charge_w, s5_charge_h, wall_thickness * 10, s5_charge_r);
    }
  }
}

module top_wall() {
  hollow_rounded_prism(width = case_w, 
                       length = case_l, 
                       height = top_h,
                       breadth = wall_thickness,
                       radius = case_r);
}

module top() {
  difference() {
    union () {
      mirror([0,0,1]) top_bezel2();
      top_wall();
    }
    translate([wall_thickness, wall_thickness, -e]) s5_body();
  }
}

// Coordinates: SW corner of *case* at origin, interior side at phone
// plane lying face down on x-y axis, so back is in positive z
// direction.
module bottom() {
  difference() {
    pillowed_prism(width=case_w,
                   length=case_l,
                   height=back_h*2,
                   h_radius=case_r,
                   v_radius=case_vertical_r);
    translate([-e,-e,-e]) {
      hollow_rounded_prism(width=case_w+e2,
                           length=case_l+e2,
                           height=top_extra+e,
                           breadth=wall_thickness+e,
                           radius=case_r);
    }
    translate([0,0,-5000]) cube([10000,10000,10000], center=true);
    translate([wall_thickness, wall_thickness, -s5_h-e]) s5_body();
  }
}

// Goes into the button recess so you can still operate the buttons.
// Parameters are for the size of the port, not the button.
module button(width, length, height, radius) {
  union() {
    translate([button_margin, button_margin, button_recess]) {
      rounded_prism(width-button_spacing, length-button_spacing, height, radius);
    }
    rounded_prism(width-button_spacing+button_margin*2,
                  length-button_spacing+button_margin*2,
                  button_recess*0.5,
                  radius);
  }
}

module case() {
  difference() {
    union() {
      top();
      translate([0,0,s5_h])
      {
        bottom();
      }
    }
  }
}

// The very back of the phone
module back1() { // export
  translate([0,0,-battery_h]) {
    difference() {
      bottom();
      xy(below=battery_h-e);
    }
  }
}

// The curved part of the back from where the battery ends
module back2() { // export
  translate([0,0,-top_extra]) {
    difference() {
      bottom();
      xy(below=top_extra-e);
      xy(above=battery_h-e2);
    }
  }
}

// The bit up to the overhang on the back
module back3() { // export
  difference() {
    bottom();
    xy(above=top_extra-e);
  }
}

module front1() { // export
  top();
}

module power_button() { // export
  button(s5_power_w, s5_power_h, wall_thickness, s5_power_r); 
}

module volume_button() { // export
  button(s5_volume_w, s5_volume_h, wall_thickness, s5_volume_r);
}

module title(s) {
  translate([0, 0, 20]) color([0,0,0]) text(s);
}

union() {
  back1();
  title("back1");
}
translate([case_w + 2, 0, 0] ) {
  back2();
  title("back2");
}
translate([case_w * 2 + 4, 0, 0]) {
  back3();
  title("back3");
}
translate([case_w * 3 + 6, 0, 0]) {
  front1();
  title("front1");
}
translate([0, case_l + 2, 0]) {
  power_button();
  title("power");
}
translate([case_w + 2, case_l + 2, 0]) {
  volume_button();
  title("vol");
}
/* /\* color([0.4, 0.4, 0.4, 1]) { *\/ */
/* /\*   translate([wall_thickness, wall_thickness, 0]) { *\/ */
/* /\*     s5_body();  *\/ */
/* /\*   }  *\/ */
/* /\* } *\/ */

/* // case(); */
/* // bottom(); */
/* // pillowed_prism(100, 50, 20, 10, 5); */




/* translate([case_l,0,0]) { */
/*   rotate([0,0,90]) { */

/*     difference() { */
/*       bottom(); */
/*       xy(above=battery_h-e2); */
/*     } */

/*     translate([case_w * 2 + 4, 0, -battery_h]) { */
/*       difference() { */
/*         bottom(); */
/*         xy(below=battery_h); */
/*       } */
/*     } */

/*     translate([case_w + 2, 0, bezel_height]) top(); */

/*     translate([case_w * 1.5, case_l/2]) { */
/*       button(s5_power_w, s5_power_h, wall_thickness, s5_power_r); */
/*       translate([0,s5_volume_h*2,0]) { */
/*         button(s5_volume_w, s5_volume_h, wall_thickness, s5_volume_r); */
/*       } */
/*     } */
/*   } */
/* } */


// Exports: case layer2
