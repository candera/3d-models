use <../lib/common.scad>;

$fn=96;
e=0.01;

// Defaults
wall_thickness=3.85;
taper=1/57;
gap=0.35;

function inches(in) = in * 25.4;

module tapered_hollow_cylinder(
  height,                       /* height */
  base_outer_d,                 /* outer diameter at the bottom */
  taper=taper,                  /* Ratio of mm/mm reduction in diameter as height increases.*/
  wall=wall_thickness           /* Difference between inner and outer radii */
  ) 
{
  base_inner_d = base_outer_d - (wall_thickness * 2);
  difference() {
    cylinder(h=height, d1=base_outer_d, d2=base_outer_d-(taper*height));
    translate([0,0,-e]) {
      cylinder(h=height+2*e, d1=base_inner_d, d2=base_inner_d-(taper*height));
    }
  }
}


/* The narrow part, including the plate that fits into the rabbit on
 * the wide part. Only one of outer_d and inner_d must be set. */
module narrow (
  height,                       /* Height, including the plate */
  outer_d,                      /* Outer diameter at *top* */
  inner_d,                      /* Inner diameter at *top* */
  wall_thickness=wall_thickness,
  taper=taper
  )
{
  if (outer_d == undef) {
    outer_d = inner_d + wall_thickness * 2;
  }
  else {
    inner_d = outer_d - wall_thickness * 2;
  }

  outer_r = outer_d/2;
  inner_r = inner_r/2;
  
  union() {
    tapered_hollow_cylinder(
      height,
      base_outer_r=outer_r+(taper*height));
  }
}

module join_plate (
  outer_d,
  inner_d,
  thickness=wall_thickness
  ) 
{
  difference() {
    cylinder(h=thickness, d=outer_d);
    translate([0,0,-e]) {
      cylinder(h=thickness+2*e, d=inner_d);
    }
  }

}

REDUCER_WIDE_PART=1;
REDUCER_NARROW_PART=2;
REDUCER_NARROW_PROFILE_ROUND=1;
REDUCER_NARROW_PROFILE_SQUARE=2;

/* A reducer coupling, in two parts */
module reducer (
  wide_height,
  wide_outer_d,
  wide_inner_d,
  wide_taper=taper,
  gap=0.35,               /* Spacing between rabbit and join plate. */
  narrow_height,
  narrow_outer_d,
  narrow_inner_d,
  narrow_taper=taper,
  wall_thickness=wall_thickness,
  parts=REDUCER_NARROW_PART + REDUCER_WIDE_PART,
  narrow_profile=REDUCER_NARROW_PROFILE_ROUND
  )
{
  wide_outer_d = wide_outer_d == undef ? wide_inner_d + wall_thickness * 2 : wide_outer_d;

  narrow_outer_d = narrow_outer_d == undef ? narrow_inner_d + wall_thickness * 2 : narrow_outer_d;
  
  spacing = wide_outer_d / 2 + 5;

  union () {
    rabbet_d= wide_outer_d
      -wall_thickness
      -(wide_taper*wide_height);
    
    // Wide part
    if (bit_test(parts, 0) == 1) {
      translate([-wide_outer_d/2-1,0,0]) {
        difference() {
          // Walls
          tapered_hollow_cylinder(
            height=wide_height,
            base_outer_d=wide_outer_d,
            wall_thickness=wall_thickness,
            taper=wide_taper);
          // Rabbet
          translate([0,0,wide_height-wall_thickness+e]) {
            cylinder(h=wall_thickness, 
                     d=rabbet_d);
          }
        }
      }
    }
    // Narrow part and plate
    if (bit_test(parts, 1) == 1) {
      translate([wide_outer_d/2+1,0,0]) {
        difference() {
          union() {
            base_outer_d=narrow_outer_d + (narrow_taper * narrow_height);
            // Nozzle
            if (narrow_profile == REDUCER_NARROW_PROFILE_ROUND) {
              tapered_hollow_cylinder(
                height=narrow_height,
                base_outer_d=base_outer_d,
                taper=narrow_taper,
                wall_thickness=wall_thickness);
            }
            else {
              translate([0,0,narrow_height/2]) {
                difference() {
                  cube([rabbet_d - wall_thickness*4, narrow_outer_d, narrow_height], center=true);
                }
              }
            }
            // Join plate
            difference() {
              cylinder(h=wall_thickness, 
                       d=rabbet_d - (gap * 2));
              translate([0,0,-e]) {
                cylinder(h=wall_thickness+2*e, 
                         d=base_outer_d-(wall_thickness/2));
              }
            }
          }
          if (narrow_profile == REDUCER_NARROW_PROFILE_SQUARE) {
            translate([0,0,narrow_height/2]) {
              cube([rabbet_d - wall_thickness*6, narrow_outer_d-wall_thickness*2, narrow_height+2*e], center=true);
            }
          }
        }
      }
    }
  }
}

/* This is the piece that has the hose that goes from the waste to the
 * bucket (input side). */
module inlet() { // export
  reducer(
    wide_height=38,
    wide_inner_d=inches(2.5),
    narrow_height=57,
    narrow_outer_d=37.4,
    parts=REDUCER_NARROW_PART+REDUCER_WIDE_PART
    );
}

/* This is the piece that goes from the bucket to suction (vacuum side) */
module outlet () { // export
  reducer(
    wide_height=38,
    wide_inner_d=inches(2.5),
    narrow_height=57,
    narrow_inner_d=34.7,
    narrow_taper=-taper,
    parts=REDUCER_NARROW_PART+REDUCER_WIDE_PART
    );
}

/* This is an adapter from my shop vacuum to a narrow nozzle for
 * evacuating plastic bags. */
module bag_pump() { // export
  reducer(
    wide_height=38,
    wide_inner_d=31.75,
    narrow_height=57,
    narrow_inner_d=5,
    wall_thickness = 0.35 * 6,
    parts=REDUCER_NARROW_PART + REDUCER_WIDE_PART,
    narrow_profile=REDUCER_NARROW_PROFILE_SQUARE    
    );
}

display(inches(6)) {
  text("inlet"); translate([0,inches(1.25),0]) inlet();
  text("outlet"); translate([0,inches(1.25),0]) outlet();
  text("bag"); translate([0,inches(1.25),0]) bag_pump();
}

