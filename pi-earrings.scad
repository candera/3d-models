union() {
  translate([0,1,0]) {
    difference() {
      cylinder(h=1.0, r1=1.7, r2=1.7, $fn=48);
      translate([0,0,-0.1]) {
        cylinder(h=1.7, r1=1, rw=1, $fn=48);
      }
    }
  }
  scale([2, 2, 2]) {
    linear_extrude(height=1.0) {
      text("π", halign="center", valign="top");
    }
  }
}         
