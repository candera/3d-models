use <../lib/common.scad>;

outer_d = 110;
thickness = 0.35 * 8;
nub_h = 10;

$fn=96*2;

module hollow_hemisphere() {
    difference() {
    sphere(d=outer_d);
    xy(below=0);
    sphere(d=outer_d-thickness*2);
  }
}

union() {
  difference() {
    union () {
      hollow_hemisphere();
      translate([0,0,outer_d/2-nub_h])
      {
        cylinder(d=outer_d/2, h=nub_h);
      }
    }
    translate([0,0,-0.01]) {
      difference() {
        cylinder(d=outer_d, h=thickness);
        cylinder(d=outer_d-thickness-0.7, h = thickness);
      }
    }
  }
  translate([outer_d + 5, 0, 0]) {
    difference() {
      hollow_hemisphere();
      translate([0,0,-0.01]) {
        difference() {
          cylinder(d=outer_d-thickness, h=thickness+0.35);
          cylinder(d=outer_d-4*thickness, h=thickness+0.35);
        }
      }
    }
  }
}
