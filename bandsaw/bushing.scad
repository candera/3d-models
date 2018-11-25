use <../lib/common.scad>;

extrustion_width = 0.4;
$fn=48;

height=inches(1);
inner_diameter = inches(27/64);
key_width = inches(5/32);
key_projection = inches(5/32);

outer_diameter = inches(3/4) - extrustion_width - inches(1/16);

module keyed_bushing(
  height=height,
  inner_diameter = inner_diameter,
  outer_diameter = outer_diameter,
  key_width = key_width,
  key_projection = key_projection) {
  union() {
    outer_r = outer_diameter / 2;
    inner_r = inner_diameter / 2;
    key_overlap = (outer_r - inner_r) / 2;
    translate([outer_r - key_overlap, -key_width/2, 0]) {
      cube([key_projection + key_overlap, key_width, height]);
    }
    difference() {
      cylinder(d=outer_diameter, h=height);
      translate([0,0,-0.1]) {
        cylinder(d=inner_diameter, h=height+0.2);
      }
    }
  }
}

// Pulley to 5/8 shaft
keyed_bushing(
  outer_diameter = inches(5/8),
  height = inches(1.125),
  inner_diameter = inches(5/16),
  key_width = inches(5/32),
  key_projection = inches(3/32));

translate([inches(1), 0, 0]) 
// Pulley to 1/2 shaft
keyed_bushing(
  outer_diameter = inches(5/8),
  height = inches(1.125),
  inner_diameter = inches(27/64),
  key_width = inches(5/32),
  key_projection = inches(3/32));

