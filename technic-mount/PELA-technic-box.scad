/*
PELA Slot Mount - 3D Printed LEGO-compatible PCB mount, vertical slide-in

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
use <../technic-bar/PELA-technic-bar.scad>
use <../technic-bar/PELA-technic-twist-bar.scad>


/* [Technic Corner] */

// Show the inside structure [mm]
cut_line = 0; // [0:1:100]

// Printing material (set to select calibrated knob, socket and axle hole fit)
material = 0; // [0:PLA, 1:ABS, 2:PET, 3:Biofila Silk, 4:Pro1, 5:NGEN, 6:NGEN FLEX, 7:Bridge Nylon, 8:TPU95, 9:TPU85/NinjaFlex]

// Is the printer nozzle >= 0.5mm? If so, some features are enlarged to make printing easier
large_nozzle = true;

// Total width [blocks]
w = 4; // [2:1:20]

// Distance from width ends of connector twist [blocks]
twist_w = 1; // [1:18]

// Total length [blocks]
l = 4; // [2:1:20]

// Distance from length ends of connector twist [blocks]
twist_l = 1; // [1:18]

// Height of the model [blocks]
h = 1; // [1:1:20]

// Interior fill style
center = 0; // [0:empty, 1:solid, 2:edge cheese holes, 3:top cheese holes, 4:all cheese holes]




///////////////////////////////
// DISPLAY
///////////////////////////////

technic_box(material=material, large_nozzle=large_nozzle, cut_line=cut_line, w=w, twist_w=twist_w, l=l, twist_l=twist_l, h=h, center=center);




///////////////////////////////////
// MODULES
///////////////////////////////////

module technic_box(material=undef, large_nozzle=undef, cut_line=undef, w=undef, twist_w=undef, l=undef, twist_l=undef, h=undef, center=undef) {

    assert(w >= 2, "w must be at least 2");
    assert(twist_w > 0, "twist_w must be at least 1");
    assert(l >= 2, "l must be at least 2");
    assert(twist_l > 0, "twist_l must be at least 1");
    assert(center >= 0, "center must be at least 0");
    assert(center <= 4, "center must be at most 4");

    tl = min(twist_l, ceil(l/2));
    l1 = tl;
    l3 = l1;
    l2 = max(0, l - l1 - l3);
    tw = min(twist_w, ceil(w/2));
    w1 = tw;
    w3 = w1;
    w2 = max(0, w - w1 - w3);

    difference() {
        union() {
            for (i = [1:h]) {
                translate([0, 0, block_height(i-1, block_height=block_height)]) {
                    technic_rectangle(material=material, large_nozzle=large_nozzle, l1=l1, l2=l2, l3=l3, w1=w1, w2=w2, w3=w3);
                }
            }
            
            if (center > 0) {
                difference() {
                    translate([block_width(0.5, block_width=block_width), block_width(0.5, block_width=block_width), 0]) {
                        cube([block_width(l-2, block_width=block_width), block_width(w-2, block_width=block_width), block_height(h, block_height)]);
                    }
                    
                    if (center > 1) {
                        cheese_holes(material=material, large_nozzle=large_nozzle, center=center, l=l, w=w, h=h, l1=l1, l2=l2, w1=w1, w2=w2);
                    }
                }
            }
        }
        
        translate([block_width(-0.5, block_width=block_width), block_width(-0.5, block_width=block_width), 0]) {
            cut_space(material=material, large_nozzle=large_nozzle, w=w, l=l, cut_line=cut_line, h=h, block_width=block_width, block_height=block_height, knob_height=knob_height);
        }
    }
}


module technic_rectangle(material=material, large_nozzle=large_nozzle, l1=undef, l2=undef, l3=undef, w1=undef, w2=undef, w3=undef) {

    assert(l1 > 0, "increase first l section to 1");
    assert(l2 >= 0, "increase second l section to 0");
    assert(l3 > 0,"increase third l section to 1");
    assert(w1 > 0, "increase first w section to 1");
    assert(w2 >= 0, "increase second w section to 0");
    assert(w3 > 0, "increase third w section to at least 1");

    ll = l1+l2+l3;
    ww = w1+w2+w3;

    technic_twist_bar(material=material, large_nozzle=large_nozzle, left=l1, center=l2, right=l3);

    rotate([0, 0, 90]) {
        technic_twist_bar(material=material, large_nozzle=large_nozzle, left=w1, center=w2, right=w3);
    }

    translate([0, block_width(ww-1), 0]) {
        technic_twist_bar(material=material, large_nozzle=large_nozzle, left=l1, center=l2, right=l3);
    }

    rotate([0, 0, 90]) {
        translate([0, -block_width(ll-1), 0]) {
            technic_twist_bar(material=material, large_nozzle=large_nozzle, left=w1, center=w2, right=w3);
        }
    }
}


module cheese_holes(material=undef, large_nozzle=undef, center=undef, l=undef, w=undef, h=undef, l1=undef, l2=undef, w1=undef, w2=undef) {
    
    if (l2 > 0 && center != 3) {
        side_cheese_holes(material=material, large_nozzle=large_nozzle, w=w, l1=l1, l2=l2, h=h, block_width=block_width, block_height=block_height);
    }
    
    if (w2 > 0 && center != 3) {
        end_cheese_holes(material=material, large_nozzle=large_nozzle, l=l, w1=w1, w2=w2, h=h, block_width=block_width, block_height=block_height);
    }
    
    if (w > 2 && l > 2 && center !=2) {
        bottom_cheese_holes(material=material, large_nozzle=large_nozzle, w=w, l=l, h=h, block_width=block_width, block_height=block_height);
        
        top_cheese_holes(material=material, large_nozzle=large_nozzle, w=w, l=l, h=h, block_width=block_width, block_height=block_height);
    }
}


module side_cheese_holes(material=undef, large_nozzle=undef, w=undef, l1=undef, l2=undef, h=undef, block_width=block_width, block_height=block_height) {
    
    for (i = [0:l2-1]) {
        for (j = [0:h-1]) {
            translate([block_width(l1+i, block_width=block_width), block_width(-0.5, block_width=block_width), block_height(0.5+j, block_height=block_height)]) {
                rotate([-90, 0, 0]) {
                    axle_hole(material=material, large_nozzle=large_nozzle, hole_type=2, radius=override_axle_hole_radius(material), length=block_width(w, block_width));
                }
            }
        }
    }    
}


module end_cheese_holes(material=undef, large_nozzle=undef, l=undef, w1=undef, w2=undef, h=undef, block_width=undef, block_height=undef) {

    translate([block_width(l-1), 0, 0]) {
        rotate([0, 0, 90]) {
            side_cheese_holes(material=material, large_nozzle=large_nozzle, w=l, l1=w1, l2=w2, h=h, block_width=block_width, block_height=block_height);
        }
    }
}


module bottom_cheese_holes(material=undef, large_nozzle=undef, w=undef, l=undef, h=undef, block_width=undef, block_height=undef) {

    for (i = [1:l-2]) {
        for (j = [1:w-2]) {
            translate([block_width(i, block_width=block_width), block_width(j, block_width=block_width), -defeather]) {
                 axle_hole(material=material, large_nozzle=large_nozzle, hole_type=2, radius=override_axle_hole_radius(material), length=block_height(h, block_height)+2*defeather);
            }
        }
    }    
}


module top_cheese_holes(material=undef, large_nozzle=undef, w=undef, l=undef, h=undef, block_width=undef, block_height=undef) {
    
    translate([block_width(0, block_width=block_width), block_width(w-1, block_width=block_width), block_height(h, block_height)]) {
        
        rotate([180, 0, 0]) {
            bottom_cheese_holes(material=material, large_nozzle=large_nozzle, w=w, l=l, h=h, block_width=block_width, block_height=block_height);
        }
    }
}
