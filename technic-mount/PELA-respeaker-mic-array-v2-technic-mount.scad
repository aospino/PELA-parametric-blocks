/*
PELA Technic Board Mount - 3D Printed LEGO-compatible PCB mount used for including printed ciruit boards in technic models

This is a library module used by other models

Published at https://PELAblocks.org

By Paul Houghton
Twitter: @mobile_rat
Email: paulirotta@gmail.com
Blog: https://medium.com/@paulhoughton

Creative Commons Attribution ShareAlike NonCommercial License
    https://creativecommons.org/licenses/by-sa/4.0/legalcode

Design work kindly sponsored by
    https://www.futurice.com

All modules are setup for stateless functional-style reuse in other OpenSCAD files.
To this end, you can always pass in and override all parameters to create
a new effect. Doing this is not natural to OpenSCAD, so apologies for all
the boilerplate arguments which are passed in to each module or any errors
that may be hidden by the sensible default values. This is an evolving art.
*/

include <../style.scad>
include <../material.scad>
use <../PELA-block.scad>
use <../PELA-technic-block.scad>
use <../pin/PELA-technic-pin.scad>
use <../technic-beam/PELA-technic-beam.scad>
use <../technic-beam/PELA-technic-twist-beam.scad>
use <../knob-mount/PELA-box-enclosure.scad>
use <PELA-technic-box.scad>
use <PELA-technic-mount.scad>


/* [Render] */

// Show the inside structure [mm]
cut_line = 0; // [0:1:100]

// Printing material (set to select calibrated knob, socket and axle hole fit)
_material = 0; // [0:PLA, 1:ABS, 2:PET, 3:Biofila Silk, 4:Pro1, 5:NGEN, 6:NGEN FLEX, 7:Bridge Nylon, 8:TPU95, 9:TPU85/NinjaFlex]

// Is the printer nozzle >= 0.5mm? If so, some features are enlarged to make printing easier
large_nozzle = true;

// Select parts to render
render_modules = 2; // [0:mount, 1:cover, 2:mount and cover]



/* [Board] */

// Board space diameter [mm]
diameter = 71.4; // [0:0.1:300]

// Board space height (1.7, 11.5 with one daughter board) [mm]
thickness = 1.7; // [0:0.1:300]



/* [Enclosure] */

// Distance from length ends of connector twist [blocks]
twist_l = 3; // [1:18]

// Distance from width ends of connector twist [blocks]
twist_w = 3; // [1:18]

// Closeness of board fit lengthwise [blocks]
l_pad = 0; // [0:tight, 1:+1 block, 2:+2 blocks]

// Closeness of board fit widthwise [blocks]
w_pad = 0; // [0:tight, 1:+1 block, 2:+2 blocks]

// Height of the enclosure [blocks]
h = 2; // [1:1:20]

// Interior fill style
center = 2; // [0:empty, 1:solid, 2:edge cheese holes, 3:top cheese holes, 4:all cheese holes, 5:socket panel, 6:knob panel, 7:flat planel]

// Step in from board space edges to support the board [mm]
innercut = 4; // [0:0.1:100]

// Step down from board bottom to give room board components [mm]
undercut = 0; // [0:0.1:100]

// Presence of sockets if center is "socket panel"
center_sockets = true;

// Presence of knobs if center is "knob panel"
center_knobs = true;

// Size of hole in the center of knobs if "center" or "cover center" is "knob panel"
knob_vent_radius = 0.0; // [0.0:0.1:3.9]

// Text label
text = "Respeaker";

// Depth of text etching into top surface
text_depth = 0.5; // [0.0:0.1:2]

// Add surface texture to reduce echoes inside the enclosure
anechoic = true;


/* [Enclosure Left Cut] */

// Distance from the front of left side hole [mm]
left_enclosure_cutout_y = 4; // [0:0.1:200]

// Width of the left side hole [mm]
left_enclosure_cutout_width = 0; // [0:0.1:200]

// Depth of the left side hole [mm]
left_enclosure_cutout_depth = 24; // [0:0.1:200]

// Distance from bottom of the left side hole [mm]
left_enclosure_cutout_z = 4; // [0:0.1:200]

// Height of the left side hole [mm]
left_enclosure_cutout_height = 8; // [0:0.1:200]



/* [Enclosure Right Cut] */

// Distance from the front of right side hole [mm]
right_enclosure_cutout_y = 4; // [0:0.1:200]

// Width of the right side hole [mm]
right_enclosure_cutout_width = 0; // [0:0.1:200]

// Depth of the right side hole [mm]
right_enclosure_cutout_depth = 24; // [0:0.1:200]

// Distance from bottom of the right side hole [mm]
right_enclosure_cutout_z = 4; // [0:0.1:200]

// Height of the right side hole [mm]
right_enclosure_cutout_height = 8; // [0:0.1:200]



/* [Enclosure Front Cut] */

// Distance from the left of front side hole [mm]
front_enclosure_cutout_x = 20; // [0:0.1:200]

// Width of the front side hole [mm]
front_enclosure_cutout_width = 32; // [0:0.1:200]

// Depth into the part of the front cut [mm]
front_enclosure_cutout_depth = 24; // [0:0.1:200]

// Distance from bottom of the front side hole [mm]
front_enclosure_cutout_z = 8; // [0:0.1:200]

// Height of the front side hole [mm]
front_enclosure_cutout_height = 16; // [0:0.1:200]



/* [Enclosure Back Cut] */

// Distance from the left of back side hole [mm]
back_enclosure_cutout_x = 4; // [0:0.1:200]

// Width of the back side hole [mm]
back_enclosure_cutout_width = 0; // [0:0.1:200]

// Depth of the back side hole [mm]
back_enclosure_cutout_depth = 24; // [0:0.1:200]

// Distance from bottom of the back side hole [mm]
back_enclosure_cutout_z = 4; // [0:0.1:200]

// Height of the back side hole [mm]
back_enclosure_cutout_height = 8; // [0:0.1:200]



/* [Cover] */

// Text label
cover_text = "Futurice";

// Interior fill style
cover_center = 5; // [0:empty, 1:solid, 2:edge cheese holes, 3:top cheese holes, 4:all cheese holes, 5:socket panel, 6:knob panel, 7:flat planel]

// Height of the cover [blocks]
cover_h = 1; // [1:1:20]

// Presence of sockets if "cover center" is "socket panel"
cover_sockets = true;

// Presence of knobs if "cover center" is "knob panel"
cover_knobs = true;




/* [Hidden] */

// Basic unit vertical size of each block
block_height = 8; // This is not adjuestable due to twist beam technic hole rotation



///////////////////////////////
// DISPLAY
///////////////////////////////

l = fit_mm_to_blocks(diameter, l_pad);

difference() {
    technic_mount_and_cover(render_modules=render_modules, material=material, large_nozzle=large_nozzle, cut_line=cut_line, length=diameter, width=diameter, thickness=0, h=h, cover_h=cover_h, l_pad=l_pad, w_pad=w_pad, twist_l=twist_l, twist_w=twist_w, center_sockets=center_sockets, center_knobs=center_knobs, cover_sockets=cover_sockets, cover_knobs=cover_knobs, knob_vent_radius=knob_vent_radius, solid_first_layer=solid_first_layer, innercut=innercut, undercut=undercut, center=center, cover_center=cover_center, text=text, cover_text=cover_text, text_depth=text_depth, left_enclosure_cutout_y=left_enclosure_cutout_y, left_enclosure_cutout_width=left_enclosure_cutout_width, left_enclosure_cutout_depth=left_enclosure_cutout_depth, left_enclosure_cutout_z=left_enclosure_cutout_z, left_enclosure_cutout_height=left_enclosure_cutout_height, right_enclosure_cutout_y=right_enclosure_cutout_y, right_enclosure_cutout_width=right_enclosure_cutout_width, right_enclosure_cutout_depth=right_enclosure_cutout_depth, right_enclosure_cutout_z=right_enclosure_cutout_z, right_enclosure_cutout_height=right_enclosure_cutout_height, front_enclosure_cutout_x=front_enclosure_cutout_x, front_enclosure_cutout_width=front_enclosure_cutout_width, front_enclosure_cutout_depth=front_enclosure_cutout_depth, front_enclosure_cutout_z=front_enclosure_cutout_z, front_enclosure_cutout_height=front_enclosure_cutout_height, back_enclosure_cutout_x=back_enclosure_cutout_x, back_enclosure_cutout_width=back_enclosure_cutout_width, back_enclosure_cutout_depth=back_enclosure_cutout_depth, back_enclosure_cutout_z=back_enclosure_cutout_z, back_enclosure_cutout_height=back_enclosure_cutout_height);

    union() {
        translate([block_width(-0.5+l/2), block_width(-0.5+l/2), block_height(h) - thickness]) {
            cylinder(d=diameter, h=block_height(h), $fn=256);
        }

        color("orange") translate([block_width(-0.5+l/2), block_width(-0.5+l/2), -skin]) {
            anechoic_cylinder_negative_space();
        }

        color("pink") translate([block_width(-0.5+3), block_width(-1.5-10)-skin, 2]) {
            cube([block_width(4), block_width(3), block_height(cover_h)]);
        }
    }
}


module anechoic_cylinder_negative_space() {
    d = diameter-2*innercut;
    ah = block_height(0.5);
    angle_increment = 360/45;
    
    if (anechoic) {
        difference() {
            cylinder(d=d, h=block_height(h)+2*skin, $fn=256);

            for (i=[0:angle_increment:360]) {
                rotate([0, 0, i]) {
                    for (j=[0.5:0.5:h-0.5]) {
                        translate([0, (d-ah)/2, block_height(j)]) {
                            rotate([-90, 0, 0]) {
                                cylinder(h=ah/2, d1=0, d2=ah);
                            }
                        }
                    }
                }
            }
        }
    } else {
        cylinder(d=d, h=block_height(h)+2*skin, $fn=256);
    }
}


if (render_modules == 0 || render_modules == 2) {
    color("blue") translate([block_width(-0.5+l/2), block_width(-0.5+l/2), 0]) {
        cylinder(d=diameter-2*innercut, h=2, $fn=256);
    }
}
