include <../lib/common.scad>;

$fn = 96;
e=epsilon;

border = 2;
thickness = 1;
size = 20;
words="2017";
length = len(words)*size*0.8;
connector_width = 0.35*4;
font="Baskerville";

union () {
  translate([0,size/2+border-connector_width/2,thickness*0.5]) {
    cube([length, connector_width, thickness*0.5]);
  }
  difference() {
    cube([length, size + 2*border, thickness]);
    translate([0,border,-e]) {
      linear_extrude(height=thickness+2*e) {
        text(text=words, size=size, font=font);
      }
    }
  }
}
