union () {
  difference () {
    cube ([24, 18, 18]);
    translate ([3, -0.5, -1]) {
      cube ([18, 19, 16]);
    }
  }
  translate ([42, 0, 18]) {
    rotate (a=-90.0, v=[0, 1, 0]) {
      difference () {
        cube ([24, 18, 18]);
        translate ([3, -0.5, -1]) {
          cube ([18, 19, 16]);
        }
      }
    }
  }
  translate ([0, 0, 18]) {
    difference () {
      cube ([24, 18, 24]);
      translate ([3, -0.5, -1]) {
        cube ([18, 19, 22]);
      }
    }
  }
}
