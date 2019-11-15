% Initialization of the workspace
clear all
close all
clc;

p1= 0.035;
p2= 0.05;
p3= 0.000023;
VG= 117;
n= 0.142;
Ib= 0;
Gb= 200;
VI= 1/0.098;
Ue=10;

sim('simulink_test_find_K.slx')

yTime = y.Time;
yData = y.Data;
figure;
plot(yTime, yData)
title('y');
figure;
plot(I.Time, I.Data)
title('I');
figure;
plot(X.Time, X.Data)
title('X');
figure;
plot(G.Time, G.Data)
title('G');
figure;
plot(u1.Time, u1.Data)
title('u1');
plot(u2.Time, u2.Data)
title('u2');



%K1=
%K2=
%K3=

%l1=
%l2=
%l3=