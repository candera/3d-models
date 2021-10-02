use <../lib/common.scad>
use <MCAD/trochoids.scad>

// origin = point of lowest descent

function cm(cm) = cm * 10;

total_height = cm(40);
ramp_angle = 65;
launch_angle = 30;
circular_radius = inches(3);

function arc_points(start, end, radius, step = 1, offset = [0,0]) = [
  for (angle=[start:step:end])
    [radius * cos(angle) + offset[0], radius * sin(angle) + offset[1]]
 ];

function rad2deg(rad) = rad * 180 / PI;

function cycloid_points(start, end, radius, step = 1, offset = [0,0]) = [
  for (t = [0:0.01:0.5])
    let (theta_rad = 2 * PI * (t - 0.25),
         theta = rad2deg(theta_rad),
         x = (2 * PI * radius * t) + (radius * cos(theta)),
         y = radius + (radius * sin(theta)))
      [x, y]
  ];
  

module circular_launch() {
  let (circ_start_h = cos(ramp_angle) * circular_radius,
       circ_start_w = sin(ramp_angle) * circular_radius,
       ramp_height = total_height - circ_start_h,
       ramp_width = ramp_height / tan(ramp_angle),
       ramp_points = [[0,0],
                      [ramp_width,-ramp_height]],
       arc_center_x = ramp_width + circular_radius * sin(ramp_angle),
       arc_center_y = -ramp_height + circular_radius * sin(ramp_angle),
       ramp_and_arc_points = cat(ramp_points, 
                                 arc_points(-90-ramp_angle-90, 
                                            -90+launch_angle, 
                                            circular_radius, 
                                            [arc_center_x, arc_center_y])))
    polygon(points = concat(ramp_and_arc_points,
                            [[ramp_width + circular_radius * (sin(ramp_angle) + cos(-90+launch_angle)),
                              -total_height - 5],
                             [0, -total_height - 5]]));
}

module circular_launch2() {
  let (circ_end_x = -circular_radius * sin(ramp_angle),
       circ_end_y = circular_radius - (circular_radius * cos(ramp_angle)),
       arc_points = arc_points(-90, -90-ramp_angle, circular_radius, step = -1, offset=[0, circular_radius]),
       ramp_height = total_height - circ_end_y,
       ramp_width = ramp_height / tan(ramp_angle),
       ramp_points = [[circ_end_x, circ_end_y],
                      [circ_end_x - ramp_width, total_height]
         ]
         )
    polygon(points = concat(arc_points
                            ,ramp_points
                            ,[[circ_end_x - ramp_width,-5],
                              [0, -5]]
              )
      );
   
}

// circular_launch2();

// polygon(points = cat([[0,0]], arc_points(90, -135, 100, step = -1)));


polygon(points = concat([[0,0]], 
                        cycloid_points(0, 0, 100),
                        [[0,0]]));
