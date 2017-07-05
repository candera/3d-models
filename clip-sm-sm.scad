union () {
  difference () {
    cube ([11.7, 18, 18]);
    translate ([3, -0.5, -0.5]) {
      cube ([5.7, 19, 16]);
    }
  }
  translate ([29.7, 0, 18]) {
    rotate (a=-90.0, v=[0, 1, 0]) {
      difference () {
        cube ([11.7, 18, 18]);
        translate ([3, -0.5, -0.5]) {
          cube ([5.7, 19, 16]);
        }
      }
    }
  }
  translate ([0, 0, 18]) {
    cube ([11.7, 18, 11.7]);
  }
}
