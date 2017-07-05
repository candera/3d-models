epsilon=0.01;

slot_length=180;
slot_height=5;
slot_width=12;

curve_radius=(slot_width/2) + ((slot_length*slot_length)/(8*slot_width));

small_wall_thickness=2;
gap=1;

$fn=96;

module slot() {
  translate([-slot_length/2, 0, 0]) {
    cube([slot_length, slot_width, slot_height]);
  }
};

module cyl() {
  translate([0, curve_radius+small_wall_thickness, -epsilon]) {
    cylinder(r=curve_radius, h=slot_height+epsilon*2);
  }
}

module big_piece() {
  intersection() {
    cyl();
    slot();
  }
}

module small_piece() {
  difference () {
    slot();
    cyl();
    translate([-gap/2, -epsilon, -epsilon]) {
      cube([gap, slot_width, slot_height+epsilon*2]);
    }
  }
}

big_piece();

translate([0, -1, 0]) {
  small_piece();
}
  
