import graph;
import settings;
outformat="png";
unitsize(1bp);
size(1000,1000, IgnoreAspect);
real dx=0;
real dy=64;
real w=64;
real hw=w/2;
real qw=w/4;
real h=32;
//real h=64;
real hh=h/2;
real qh=h/4;
for (int j=0; j <40; ++j){
dy =j*h*1.5;
for (int i=0; i <40; ++i){
dx=i*w;
draw((dx,dy)--(dx+hw,dy-qh)--(dx+w,dy)--(dx+w,dy+hh)--(dx+hw,dy+hh+qh)--(dx,dy+hh)--cycle);
}
}
for (int j=1; j <40; ++j){
dy =(j+0.5)*h*1.5;
for (int i=0; i <40; ++i){
dx=i*w+hw;
draw((dx,dy)--(dx+hw,dy-qh)--(dx+w,dy)--(dx+w,dy+hh)--(dx+hw,dy+hh+qh)--(dx,dy+hh)--cycle);
}
}