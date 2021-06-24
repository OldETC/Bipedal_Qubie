// dc to dc mount
// velleman vma404
// slide in mount
// board size:
dcdcWidth=21.6;
dcdcLength=47.5;
dcdcThick=1.5;

// board slips in the wide way with slots on the narrow sides.abs
module dcdcSlots(){
    difference(){
        cube([3,dcdcWidth,8]);
        translate([2,-1,6])
            cube([5,dcdcWidth+2,1.5]);
    }
    translate([dcdcLength+2,0,0]){
        difference(){
            cube([3,dcdcWidth,8]);
            translate([-4,-1,6])
                cube([5,dcdcWidth+2,1.5]);
        }
    }
}    

module dcdcPlate(){
// the test of the mounts
    union(){
        cube([53,25,3]);
        translate([0,0,2.8])
            dcdcSlots();
    }
}
dcdcPlate();
//dcdcSlots();