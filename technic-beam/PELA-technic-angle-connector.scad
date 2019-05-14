/*
PELA technic angle - 3D Printed LEGO-compatible 30 degree bend

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

include <../material.scad>
include <../style.scad>
use <../PELA-block.scad>
use <../PELA-technic-block.scad>
use <PELA-technic-beam.scad>



/* [Render] */

// Show the inside structure [mm]
_cut_line = 0; // [0:1:100]

// Printing material (set to select calibrated knob, socket and axle hole fit)
<<<<<<< HEAD
_material = 0; // [0:PLA, 1:ABS, 2:PET, 3:Biofila Silk, 4:Pro1, 5:NGEN, 6:NGEN FLEX, 7:Bridge Nylon, 8:TPU95, 9:TPU85/NinjaFlex]
=======
material = 1; // [0:PLA, 1:ABS, 2:PET, 3:Biofila Silk, 4:Pro1, 5:NGEN, 6:NGEN FLEX, 7:Bridge Nylon, 8:TPU95, 9:TPU85/NinjaFlex]
>>>>>>> master

// Is the printer nozzle >= 0.5mm? If so, some features are enlarged to make printing easier
_large_nozzle = true;


/* [Technic Angle Connector] */

// Angle between the top and bottom parts of the connector [degrees]
_angle = 30; // [0:180]

// Length of the beam [blocks]
_l = 7; // [1:1:20]

// Width of the beam [blocks]
_w = 1; // [1:1:20]

// Top beam height [blocks]
_h_top = 1; // [1:1:30]

// Bottom beam height [blocks]
_h_bottom = 1; // [1:1:30]

// Add full width through holes spaced along the length for techic connectors
_side_holes = 2; // [0:disabled, 1:short air vents, 2:full width connectors, 3:short connectors]

// Horizontal clearance space removed from the outer horizontal surface to allow two parts to be placed next to one another on a 8mm grid [mm]
_skin = 0.1; // [0:0.02:0.5]


/* [Hidden] */

_block_height = 8;


///////////////////////////////
// DISPLAY
///////////////////////////////

technic_angle_connector(material=_material, large_nozzle=_large_nozzle, cut_line=_cut_line, angle=_angle, l=_l, w=_w, h_top=_h_top, h_bottom=_h_bottom, side_holes=_side_holes, skin=_skin);



///////////////////////////////////
// MODULES
///////////////////////////////////

module technic_angle_connector(material=undef, large_nozzle=undef, cut_line=undef,angle=undef, l=undef, w=undef, h_top=undef, h_bottom=undef, side_holes=undef, skin=undef) {

    assert(material!=undef);
    assert(large_nozzle!=undef);
    assert(cut_line!=undef);
    assert(angle >= 0, "Angle connector must be 0-180 degrees")
    assert(angle <= 180, "Angle connector must be 0-180 degrees")
    assert(l!=undef);
    assert(w!=undef);
    assert(h_top!=undef);
    assert(h_bottom!=undef);
    assert(side_holes!=undef);
    assert(skin!=undef);

    difference() {
        union() {
            translate([0, 0, block_height(h_bottom)]) {
                rotate([angle, 0, 0]) {
                    translate([0, block_width(0.5), -skin]) {
                        technic_beam(material=material, large_nozzle=large_nozzle, cut_line=0, l=l, w=w, h=h_top, side_holes=side_holes, skin=skin);
                    }
                }
            }

            translate([0, block_width(0.5), skin]) {
                    technic_beam(material=material, large_nozzle=large_nozzle, cut_line=0, l=l, w=w, h=h_bottom, side_holes=side_holes, skin=skin);
            }

            increment = 1;
            for (theta = [0 : increment : angle]) {
                pie_slice(material=material, large_nozzle=large_nozzle, theta=theta, increment=increment, l=l, w=w, h=h_bottom, skin=skin);
            }
        }

        translate([block_width(-0.5), -sin(angle)*block_width(h_top+1), 0]) {
           cut_space(material=material, large_nozzle=large_nozzle, w=l, l=w, cut_line=cut_line, h=h_bottom+1, block_height=_block_height, knob_height=_knob_height);
        }
    }
}



// theta-degree spacer between the two segments
module pie_slice(material=undef, large_nozzle=undef, theta=undef, increment=undef, l=undef, w=undef, h=undef, skin=undef) {
    
    assert(material!=undef);
    assert(large_nozzle!=undef);
    assert(theta!=undef);
    assert(increment!=undef);
    assert(l!=undef);
    assert(w!=undef);
    assert(h!=undef);
    assert(skin!=undef);
    
    translate([0, 0, block_width(h)]) {
        rotate([theta, 0 , 0]) {
            difference() {
                hull() {
                    technic_beam_slice(material=material, large_nozzle=large_nozzle, l=l, skin=skin);

                    rotate([increment, 0, 0]) {
                        technic_beam_slice(material=material, large_nozzle=large_nozzle, l=l, skin=skin);
                    }
                }

                for (n = [0:1:l-1]) {
                    translate([block_width(n), 0, 0]) {
                        hull() {
                            translate([0, 0, -_defeather]) {
                                technic_beam_slice_negative(material=material, large_nozzle=large_nozzle, w=w, l=0);
                            }

                            rotate([increment, 0, 0]) {
                                translate([0, 0, _defeather]) {
                                    technic_beam_slice_negative(material=material, large_nozzle=large_nozzle, w=w, l=0);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}