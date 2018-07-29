bearing_d = 30.5;
bearing_r = bearing_d / 2;
bearing_h = 9;
ledge_w = 3.5;
wheel_r = 30;
theta = 100; // How much of the shaft we encompass in degrees
lip_h = 2;
chamfer_size = 0.4;
shaft_d = 27;
shaft_r = shaft_d / 2;
shaft_steps = 20;

curve_h = shaft_d * sin(theta/2);

overall_h = curve_h + 2 * lip_h;

// ledge_h = (overall_h - bearing_h) / 2;
ledge_h = 4;
shaft_center_offset = shaft_r * cos(theta/2);

function cat(L1, L2, L3) = [for(L=[L1, L2, L3], a=L) a];

module outline() {
  polygon(points=cat([[bearing_r - ledge_w+chamfer_size, 0],
                      [bearing_r - ledge_w             , chamfer_size],
                      [bearing_r - ledge_w             , ledge_h],
                      [bearing_r                       , ledge_h],
                      [bearing_r                       , overall_h],
                      [wheel_r                         , overall_h],
                      [wheel_r                         , overall_h - lip_h]],
                     [for (alpha=[theta/2:-theta/shaft_steps:-theta/2])
                         [wheel_r + shaft_center_offset - (cos(alpha) * shaft_r),
                          overall_h / 2 + (sin(alpha) * shaft_r)]],
                     [[wheel_r                         , chamfer_size],
                      [wheel_r - chamfer_size          , 0]]
            ));
}

$fn = 100;
rotate_extrude()
  outline();

