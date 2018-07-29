module notch(l1 = 10, w1 = 5, overhang, n1 = 0.1, n2 = 0.15, a = 30) {
  w2 = (overhang == undef) ? w1 * 1.25 : w1 + overhang;
      
  polygon(points = [[0,0],
                    [0,l1],
                    [w1,l1],
                    [w1,l1*(1.0-n1)],
                    [w2,l1*(1.0-n1-n2)],
                    [w2,l1*(n1+n2)],
                    [w1,l1*n1],
                    [w1,0]
            ]);
}

module inner(outer_d = 20,
             inner_d = 10,
             h = 10,
             overhang = 1.25) {
  $fn=96;
  rotate_extrude(angle=360, convexity=10)
  translate([inner_d/2,0])
    notch(l1 = h, w1=(outer_d - inner_d)/2, overhang = overhang);  
}

module outer(outer_d = 20,
             inner_d = 10,
             h = 10,
             overhang = 1.25) {
  $fn=96;
  rotate_extrude(angle=360, convexity=10)
  translate([outer_d/2,0])
    scale([-1,1,1])
    notch(l1 = h, w1=(outer_d - inner_d)/2, overhang = overhang);  
}

module roller(d = 5,
              h = 10,
              overhang = -1.5) {
  $fn=96;
  rotate_extrude(angle=360, convexity=10)
    notch(l1 = h, w1 = d/2, overhang = overhang);
}

module bearing(inner_outer_d, 
               inner_inner_d,
               outer_outer_d,
               h,
               overhang = 1.5,
               clearance = 2,
               roller_d = 5,
               rollers = 6) {
  inner_outer_d = inner_outer_d + clearance / 2;
  alpha = sin(180/rollers);
  roller_r = (alpha * inner_outer_d / 2) / ( 1 - alpha);
  outer_inner_d = inner_outer_d + 4 * roller_r;
  union() {
    color([1.0,0,0,0.9]) 
      inner(outer_d = inner_outer_d - clearance / 2, inner_d = inner_inner_d, h = h, overhang = overhang);
    color([0,1.0,0,0.8])
      outer(outer_d = outer_outer_d, inner_d = outer_inner_d + clearance / 2, h = h, overhang = overhang);
    for (theta = [0:(360/rollers):360]) {
      rotate([0, 0, theta])
      translate([(inner_outer_d + outer_inner_d) / 4, 0])
        roller(d = ((outer_inner_d - inner_outer_d) / 2) - clearance, h = h, overhang = -overhang);
    }
  }
}

difference() {
  bearing(outer_outer_d=52,
          inner_outer_d=18,
          inner_inner_d=10,
          rollers=8,
          h=20,
          overhang=2,
          clearance=0.4);
  /* translate([0,0,-1]) */
  /* cube([100,100,100]); */
}
 
// inner(outer_d=20,inner_d=12,h=10, overhang = 1);
// outer(outer_d=40, inner_d=30, h= 10, overhang = 1);
// roller(d=10,h=10,overhang=1);

