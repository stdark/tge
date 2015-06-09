import graph;
import settings;
outformat="png";
unitsize(1bp);
size(1000,1000, IgnoreAspect);
real dx=10;
real dy=40;
real w=64;
real hw=w/2;
real qw=w/4;
//real h=32;
real h=64;
real hh=h/2;
real qh=h/4;
for (int j=0; j <10; ++j){
dy =40 +j*h+j*10;
for (int i=0; i <10; ++i){
dx=10+i*w+i*10;
//vertical
//draw((dx,dy)--(dx+qw,dy+hh)--(dx+qw+hw,dy+hh)--(dx+w,dy)--(dx+qw+hw,dy-hh)--(dx+qw,dy-hh)--cycle);
//horizontal
draw((dx,dy)--(dx+hw,dy-qh)--(dx+w,dy)--(dx+w,dy+hh)--(dx+hw,dy+hh+qh)--(dx,dy+hh)--cycle);
}
}