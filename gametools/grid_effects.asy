import graph;
import settings;
outformat="png";
unitsize(1bp);
size(2048,2048, IgnoreAspect);
real startx=0;
real starty=128;
real stepx=128;
real stepy=128;

for (int i=0; i <16; ++i){
draw((0,stepy*i)--(2048,stepy*i));
}
for (int h=0; h <16; ++h){
draw((stepx*h,0)--(stepx*h,2048));
}


