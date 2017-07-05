union () {
  difference () {
    cube ([11.7, 18, 18]);
    translate ([3, -0.5, -1]) {
      cube ([5.7, 19, 16]);
    }
  }
  translate ([29.7, 0, 18]) {
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
      cube ([11.7, 18, 24]);
      translate ([3, -0.5, -1]) {
        cube ([5.7, 19, 22]);
      }
    }
  }
}
