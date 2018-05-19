coindia = 50;
coinheight = 5;
layerheight = 0.2;
fn = 72;

mincointhickness = 1.2;

separation = 0.15;

flface = "Ttails.png";
flip = false;
afl = "outstls\\Hheads-head.stl";
bfl = "outstls\\Ttails-tail.stl";

part = "coin";

//coin();
//coinsupport();
//face(flimg = "Hheads.png");
//face(flimg = "Ttails.png", flip=true);

coinsides = 120;

part();

module part(){
    if (part == "face"){
        face(flimg = flface, flip = flip);
    } else if (part == "coinsupport"){
        coinsupport();
    } else if (part == "both"){
        coin(afl = afl, bfl = bfl);
        coinsupport();
    } else {
        // default to coins
        coin(afl = afl, bfl = bfl);
    }
}

module face(flimg = flface, flip=false){
    intersection(){
        if(flip){
            //mirror([0,0,0])
            translate([0,0,(coinheight-mincointhickness)/2])
            rotate([0,180,0])
            resize([coindia, coindia, (coinheight-mincointhickness)/2])
            surface(file = flimg, center=true, convexity = 25);
        } else {
            resize([coindia, coindia, (coinheight-mincointhickness)/2])
            surface(file = flimg, center=true, convexity = 25);
        }
        linear_extrude(coinheight)
        coinshape();
    }
}

module coinshape(){
    rotate(360/coinsides/2)
    circle(coindia/2, $fn = coinsides);
}

module rim(){
    rotate(360/coinsides/2)
    difference(){
        cylinder(d = coindia, h = coinheight, $fn = coinsides);
        translate([0,0,-1])
        cylinder(d = coindia-3.2, h = coinheight+2, $fn = coinsides);
    }
}

module coin(afl = "Hheads.stl", bfl = "Ttails.stl"){
    translate([0,coinheight/2, coindia/2])
    rotate([90,0,0])
    union(){
        // a side
        translate([0,0,(coinheight-mincointhickness)/2+mincointhickness])
        import(afl, convexity=25);
        
        // min thick middle
        if(mincointhickness > 0){
            translate([0,0,(coinheight-mincointhickness)/2])
            linear_extrude(mincointhickness)
            coinshape();
        }
        
        // b side
        import(bfl, convexity=25);
        
        rim();
        
    }
}

module coinsupport(){
    supportpoints = [
        [-coindia/3, coinheight*2, 0],  //0
        [coindia/3, coinheight*2, 0],  //1
        [coindia/3, -coinheight*2, 0],  //2
        [-coindia/3, -coinheight*2, 0],  //3
        [-coindia/2, coinheight/2, coindia/3],  //4
        [coindia/2, coinheight/2, coindia/3],  //5
        [coindia/2, -coinheight/2, coindia/3],  //6
        [-coindia/2, -coinheight/2, coindia/3]  //7
    ];
    
    supportfaces = [
        [3,2,1,0],
        [7,6,2,3], 
        [6,5,1,2],
        [4,7,3,0],
        [5,4,0,1],
        [4,5,6,7]
    ];
    difference(){
        polyhedron( supportpoints, supportfaces);
        translate([0,0,coindia/2])
        rotate([90,0,0])
        rotate(360/coinsides/2)
        cylinder(d = coindia+separation*2, h=coinheight+separation*2, $fn=coinsides, center=true);
        translate([0,0,coindia/2])
        rotate([90,0,0])
        rotate(360/coinsides/2)
        cylinder(d = coindia-6, h=coinheight*10, $fn=coinsides, center=true);
        rotate([0,90,0])
        cube([coindia, coindia, 1], center=true);
    }
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

module cylinder_outer(height,radius,fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);}
   
module circle_outer(radius,fn){
   fudge = 1/cos(180/fn);
   circle(r=radius*fudge,$fn=fn);}
