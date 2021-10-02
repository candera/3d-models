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

// 3D rectangle with cylindrical rounded corners. Scale gives an optional flare to the top.
module rounded_prism(width, length, height, radius, scale=1) {
  translate([width/2, length/2]) {
    linear_extrude(height=height, scale=scale) {
      translate([-width/2, -length/2]) {
        rounded_rectangle(width, length, radius);
      }
    }
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

// Returns a volume that contains all of the points above or below the
// specified z
module xy(above, below)
{
  d = 10000;
  if (below == undef)
    translate([0,0,above+d/2]) cube([d,d,d] ,center=true);
  else
    translate([0,0,below-d/2]) cube([d,d,d], center=true);
}

// Lays things out in a line with labels
// TODO: Lay them out in a grid instead
module display(w, l=10, padding=2) {
  for (n = [0:2:$children-1]) {
    translate([(w + padding) * n/2, 0, 0]) {
      translate([0, l, 0]) {
        children(n+1);
      }
      color([0,0,0])
        children(n);
    }
  }
}

module quarter_cylinder(r, h) {
  difference() {
    translate([0,0,h/2]) {
      cylinder(r=r, h=h, center=true);
    }
    translate([-r*2-epsilon,-r*2,-epsilon]) {
      cube([r*2,r*4,h*2]);
    }
    translate([-r*2-epsilon,-r*2,-epsilon]) {
      cube([r*4,r*2,h*2]);
    }

  }
}

function bit_test(val, bit) = floor(val / (pow(2,bit))) % 2;

function inches(in) = in * 25.4;

// Concatenate two vectors. TODO: Make it work with N vectors. Here's
// what it looks like with three:
// function cat(L1, L2, L3) = [for(L=[L1, L2, L3], a=L) a];
function cat(L1, L2) = [for(L=[L1, L2], a=L) a];
