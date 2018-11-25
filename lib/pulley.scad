/* A pulley shape. Includes chamfered bottom edges */

/* bearing_d = 30.5; */
/* bearing_h = 9; */
/* ledge_w = 3.5; */
/* pulley_min_d = bearing_d + 5; */
/* theta_top = 50;          // How much the top side of the pulley curves */
/* theta_bottom = theta_top;       // How much the bottom side curves */
/* lip_h = 2; */
/* chamfer_size = 0.4; */
/* shaft_d = 27; */
/* shaft_r = shaft_d / 2; */
/* shaft_steps = 20; */

curve_h = shaft_d * sin((theta_top + theta_bottom)/2);

overall_h = curve_h + 2 * lip_h;

// ledge_h = (overall_h - bearing_h) / 2;
ledge_h = 4;

function cat(L1, L2, L3) = [for(L=[L1, L2, L3], a=L) a];

module pulley(
  bearing_d = bearing_d,
  bearing_h = bearing_h,
  ledge_w = ledge_w,
  pulley_min_d = pulley_min_d,
  theta_top = theta_top,
  theta_bottom = theta_bottom,
  lip_h = lip_h,
  chamfer_size = chamfer_size,
  shaft_d = shaft_d,
  shaft_steps = shaft_steps,
  ledge_h = ledge_h) {

  pulley_min_r = pulley_min_d / 2;
  bearing_r = bearing_d / 2;
  shaft_r = shaft_d / 2;
  curve_h = shaft_r * (sin(theta_top) + sin(theta_bottom));
  overall_h = curve_h + 2 * lip_h;
  shaft_center_offset = shaft_r + pulley_min_r;

  pulley_top_r = pulley_min_r + ((1-cos(theta_top)) * shaft_r);
  pulley_bottom_r = pulley_min_r + ((1-cos(theta_bottom)) * shaft_r);
  
  rotate_extrude() {
    polygon(points=cat([[bearing_r - ledge_w+chamfer_size, 0],
                        [bearing_r - ledge_w             , chamfer_size],
                        [bearing_r - ledge_w             , ledge_h],
                        [bearing_r                       , ledge_h],
                        [bearing_r                       , overall_h],
                        [pulley_top_r                    , overall_h],
                        [pulley_top_r                    , overall_h - lip_h]],
                       [for (alpha=[theta_top:(theta_top + theta_bottom)/-shaft_steps:-theta_bottom])
                           [shaft_center_offset - (cos(alpha) * shaft_r),
                            lip_h + (overall_h / 2) + (sin(alpha) * shaft_r)]],
                       [[pulley_bottom_r                    , chamfer_size],
                        [pulley_bottom_r - chamfer_size     , 0]]
              ));
  }
}

/* $fn = 100; */
/* pulley(); */

