clc;

p1= 0.035;
p2= 0.05;
p3= 0.000028;
VG= 117;
n= 0.142;
Ib= 0;
Gb= 200;
VI= 1/0.098;
Ue=0;

x_eq = (p3/p2)*((Ue/VI*n)-Ib); %x_eq = (-Ib*p3)/p2;
g_eq = (p2*Gb)/(p2+(Ib*p3/p1)-(Ue*p3)/(p1*VI*n)); %g_eq = (p1*p2*Gb)/(p1*p2-Ib*p3);

A = [-p1-x_eq -g_eq 0; 0 -p2 p3; 0 0 -n];
B = [ 0;  0;  1/VI];
C = [1 0 0];
D = [0];

sys = ss(A, B, C, D);

E = eig(A);

%P = [-5-0.4i -5+0.4i -4]
P = [-5-0.001i -5+0.001i -4]

K = place(A, B, P);
 
L = place(A',C', P);

Acl = A - B*K;
Ecl = eig(Acl);

syscl1 = ss(Acl, B, C, D);
disp('Step Info for syscl1')
stepinfo(syscl1)
%figure;
%step(syscl);

Kdc = dcgain (syscl1);
Kr = 1/Kdc;

syscl_scaled1 = ss (Acl, B*Kr, C, D);
disp('Step Info for syscl_scaled1')
stepinfo(syscl_scaled1)

disp('=====================================')

%figure;
%step(syscl_scaled)
%hold on 
%P = [-8 -0.05 -3]
P = [-6-0.001i -5+0.001i -4]

K = place(A, B, P);


L = place(A',C', P);

Acl = A - B*K;
Ecl = eig(Acl);

syscl2 = ss(Acl, B, C, D);
disp('Step Info for syscl2')
stepinfo(syscl2)
%figure;
%step(syscl);

Kdc = dcgain (syscl2);
Kr = 1/Kdc;

syscl_scaled2 = ss (Acl, B*Kr, C, D);
disp('Step Info for syscl_scaled2')
stepinfo(syscl_scaled2)
disp('=====================================')
%figure;
%step(syscl_scaled);

%hold on 
%P = [-0.00001-0.6i -0.00001+0.6i -0.00023]
P = [-0.00001-20i -0.00001+20i -0.00023]

K = place(A, B, P);


L = place(A',C', P);

Acl = A - B*K;
Ecl = eig(Acl);

syscl3 = ss(Acl, B, C, D);
disp('Step Info for syscl3')
stepinfo(syscl3)
%figure;
%step(syscl);

Kdc = dcgain (syscl3);
Kr = 1/Kdc;

syscl_scaled3 = ss (Acl, B*Kr, C, D);
disp('Step Info for syscl_scaled3')
stepinfo(syscl_scaled3)
disp('=====================================')
%figure;
%step(syscl_scaled);

%hold on

figure
step(syscl1)
figure
step(syscl2)
%figure
%step(syscl3)

figure
step(syscl_scaled1)
figure
step(syscl_scaled2)
%figure
%step(syscl_scaled3)