import graph;
import settings;
outformat="png";
unitsize(1bp);
size(2560,2560, IgnoreAspect);
real startx=0;
real starty=32;
real stepx=32;
real stepy=32;

for (int i=0; i <80; ++i){
draw((0,stepy*i)--(2560,stepy*i));
}
for (int h=0; h <80; ++h){
draw((stepx*h,0)--(stepx*h,2560));
}


