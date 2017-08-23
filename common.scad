// Common modules for use across models

epsilon=0.02;

module hollow_cylinder(h,d_inner,d_outer) {
  difference() {
    cylinder(h=h,d=d_outer);
    translate([0,0,-epsilon/2]) {
      cylinder(h=h+epsilon, d=d_inner);
    }
  }
}

module hollow_prism(h, lx_outer, lx_inner, ly_outer, ly_inner) {
  difference() {
    cube([lx_outer, ly_outer, h]);
    translate([(lx_outer-lx_inner)/2,(ly_outer-ly_inner)/2,-epsilon/2]) {
      cube([lx_inner, ly_inner,h+epsilon]);
    }
  }
}

module right_triangle(lx, ly) {
  polygon(points=[[0,0],
                  [lx,0],
                  [0,ly], 
                  [0,0]]);
}

