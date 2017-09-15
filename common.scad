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

// A 2D rectangle with rounded corners
module rounded_rectangle(width, height, radius) {
  r = radius;
  x1 = r;
  y1 = r;
  x2 = width - r;
  y2 = height - r;
  hull() {
    translate([x1, y1, 0]) circle(radius);
    translate([x2, y1, 0]) circle(radius);
    translate([x1, y2, 0]) circle(radius);
    translate([x2, y2, 0]) circle(radius);
  }
}

// 3D rectangle with cylindrical rounded corners
module rounded_prism(width, length, height, radius) {
  linear_extrude(height=height) {
    rounded_rectangle(width, length, radius);
  }
}

// A squished sphere with the specified radii
module squashed_sphere(h_radius, v_radius) {
  resize([h_radius*2, h_radius*2, v_radius*2]) {
    sphere(r=h_radius);
  }
}

// 3D rectangle with spherical rounded corners
module pillowed_prism(width, length, height, h_radius, v_radius) {
  x1 = h_radius;
  y1 = x1;
  x2 = width - h_radius;
  y2 = length - h_radius;
  hull() {
    translate([x1, y1,  height/2-v_radius]) squashed_sphere(h_radius, v_radius);
    translate([x2, y1,  height/2-v_radius]) squashed_sphere(h_radius, v_radius);
    translate([x1, y2,  height/2-v_radius]) squashed_sphere(h_radius, v_radius);
    translate([x2, y2,  height/2-v_radius]) squashed_sphere(h_radius, v_radius);
    translate([x1, y1, -height/2+v_radius]) squashed_sphere(h_radius, v_radius);
    translate([x2, y1, -height/2+v_radius]) squashed_sphere(h_radius, v_radius);
    translate([x1, y2, -height/2+v_radius]) squashed_sphere(h_radius, v_radius);
    translate([x2, y2, -height/2+v_radius]) squashed_sphere(h_radius, v_radius);
  }
}
