use <../lib/common.scad>;

$fn=96;
e=0.01;

module post_receiver( // export
  d = 11.85,
  h = 6.3,
  brim_d = 22.5,
  brim_h = 0.2,
  recess_w = 4.5,
  wall_t = 1.5
  )
{
  union() {
    // Brim
    difference() {
      cylinder(d = brim_d, h = brim_h);
      translate([0, 0, -e]) {
        cylinder(d = d, h = brim_h + 2 * e);
      }
    }
    // Walls
    difference() {
      // Outer wall
      cylinder(d = d, h = h);
      translate([0,0,-e]) {
        difference() {
          // Inner wall
          cylinder(d = d - wall_t + e, h = h + 2 * e);
          // Right side of post recess
          translate([recess_w/2, -d/2, 0]) {
            cube([d,d,h], center=false);
          }
          // Left side of post recess;
          mirror([1,0,0]) {
            translate([recess_w/2, -d/2, 0]) {
              cube([d,d,h], center=false);
            }
          }
        }
      }
    }
  }
}

module unit() { //export
  post_receiver();
}

unit();
