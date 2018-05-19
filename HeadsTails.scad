coindia = 50;
rim = 2;
layerheight = 0.2;
fn = 72;

coin();

module coin(){
    translate([0,0,1.5])
    heads();
    translate([0,0,1])
    cylinder(d = coindia, h = 0.5, $fn=fn);
    translate([0,0,1])
    mirror([0,0,1])
    tails();
}


module heads(){
    intersection(){
        union(){
            intersection(){
                translate([0,0,-0.5])
                resize([coindia, coindia, 1.5])
                surface(file = "Heads.png", center=true, convexity = 20);
                cylinder(d= coindia-rim-1, h=1, $fn=fn);
            }
            for(rot = [1:3], x = [-coindia/2: coindia/7:coindia/2]){
                rotate(rot*60)
                translate([x, 0, layerheight/2*rot])
                cube([1, coindia, layerheight*rot], center=true);
            }
        }
        cylinder(d = coindia, h = 1, $fn=fn);
    }
    difference(){
        cylinder(d = coindia, h = 1, $fn=fn);
        cylinder(d = coindia-rim, h=4, $fn=fn, center=true);
    }
}

module tails(){
    intersection(){
        union(){
            intersection(){
                translate([0,0,-0.5])
                resize([coindia, coindia, 1.5])
                surface(file = "Tails.png", center=true, convexity = 20);
                cylinder(d= coindia-rim-1, h=1, $fn=fn);
            }
            for(rot = [1:2], x = [-coindia/2: coindia/7:coindia/2]){
                rotate(rot*90)
                translate([x, 0, layerheight/2*rot])
                cube([1, coindia, layerheight*rot], center=true);
            }
        }
        cylinder(d = coindia, h = 1, $fn=fn);
    }
    difference(){
        cylinder(d = coindia, h = 1, $fn=fn);
        cylinder(d = coindia-rim, h=4, $fn=fn, center=true);
    }
}

