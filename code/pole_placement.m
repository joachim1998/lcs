function pole_placement()
    clc;

    p1= 0.035;
    p2= 0.05;
    p3= 0.000023;
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
    
    %{
    [riseTime1, riseTime2, riseTime3, settlingTime1, settlingTime2, settlingTime3, overshoot1, overshoot2, overshoot3] = best(A, B, C, D);
    
    figure;
    step(riseTime1{5});
    hold on
    step(riseTime2{5});
    step(riseTime3{5});
    hold off
    
    figure;
    step(settlingTime1{5});
    hold on
    step(settlingTime2{5});
    step(settlingTime3{5});
    hold off
    
    figure;
    step(overshoot1{5});
    hold on
    step(overshoot2{5});
    step(overshoot3{5});
    hold off
    
    kr_rt1 = 1/dcgain(riseTime1{5});
    kr_rt2 = 1/dcgain(riseTime2{5});
    kr_rt3 = 1/dcgain(riseTime3{5});
    
    kr_st1 = 1/dcgain(settlingTime1{5});
    kr_st2 = 1/dcgain(settlingTime2{5});
    kr_st3 = 1/dcgain(settlingTime3{5});
    
    kr_ov1 = 1/dcgain(overshoot1{5});
    kr_ov2 = 1/dcgain(overshoot2{5});
    kr_ov3 = 1/dcgain(overshoot3{5});
    
    figure;
    step(ss(riseTime1{6}, B*kr_rt1, C, D));
    hold on
    step(ss(riseTime2{6}, B*kr_rt2, C, D));
    step(ss(riseTime2{6}, B*kr_rt3, C, D));
    hold off
    
    figure;
    step(ss(settlingTime1{6}, B*kr_st1, C, D));
    hold on
    step(ss(settlingTime2{6}, B*kr_st2, C, D));
    step(ss(settlingTime3{6}, B*kr_st3, C, D));
    hold off
    
    figure;
    step(ss(overshoot1{6}, B*kr_ov1, C, D));
    hold on
    step(ss(overshoot2{6}, B*kr_ov2, C, D));
    step(ss(overshoot3{6}, B*kr_ov3, C, D));
    hold off
    %}
    
    [settlingTime1, settlingTime2, settlingTime3] = getRange(A, B, C, D, 5300, 5500); %en seconde
    figure;
    step(settlingTime1{3});
    hold on
    step(settlingTime2{3});
    step(settlingTime3{3});
    hold off
    
    kr_st1 = 1/dcgain(settlingTime1{3});
    kr_st2 = 1/dcgain(settlingTime2{3});
    kr_st3 = 1/dcgain(settlingTime3{3});
    
    figure;
    step(ss(settlingTime1{4}, B*kr_st1, C, D));
    hold on
    step(ss(settlingTime2{4}, B*kr_st2, C, D));
    step(ss(settlingTime3{4}, B*kr_st3, C, D));
    hold off

    %syscl_scaled = ss(Acl, B*kr, C, D);

    %sys = ss(A, B, C, D);

    %P = eig(A) %ok car ici elles sont toutes négatives

    %P = [ -n -p2 -p1-x_eq ]

    %K = place(A, B, P);

    %L = place(A,C, P);
    %Acl = A - B*K;
    %Ecl = eig(Acl);
    %disp('Step Info for sysc (moi)')
    %syscl = ss(Acl, B, C, D);

    %info = stepinfo(syscl);

    

    %figure;
    %step(syscl);

    %kdc = dcgain(syscl);
    %kr = 1/kdc;

    %syscl_scaled = ss(Acl, B*kr, C, D);
    %disp('Step Info for syscl_scaled3')
    %stepinfo(syscl_scaled)
    %disp('=====================================')

    %figure;
    %step(syscl_scaled);
end

function [riseTime1, riseTime2, riseTime3, settlingTime1, settlingTime2, settlingTime3, overshoot1, overshoot2, overshoot3] =  best(A, B, C, D)
    riseTime1 = {};
    riseTime2 = {};
    riseTime3 = {};
    settlingTime1 = {};
    settlingTime2 = {};
    settlingTime3 = {};
    overshoot1 = {};
    overshoot2 = {};
    overshoot3 = {};
    cnt = 0;
    
    %for i = -0.1:-10:-0.1 %deja a 1 000 000 itérations ou bien on fait
    %avec la même vaaleur pour les 3 champs du P??
        %for j = -0.1:-10:-0.1
            %for k = -0.1:-10:-0.1
    for j = 1:500 %attention avec le i des imaginaire!!
       % for j = -1:-10:-1
       %     for k = -1:-10:-1
                P = [-j/100-0.0001i -j/100+0.0001i -j/100]; %faut jouer avec ca et la valeur de j
                K = place(A, B, P);
                Acl = A - B*K;
                
                syscl = ss(Acl, B, C, D);
                info = stepinfo(syscl);
                
                if cnt == 0
                    riseTime1{1} = P;
                    riseTime1{2} = info.('RiseTime');
                    riseTime1{3} = info.('SettlingTime');
                    riseTime1{4} = info.('Overshoot');
                    riseTime1{5} = syscl;
                    riseTime1{6} = Acl;
                    
                    settlingTime1{1} = P;
                    settlingTime1{2} = info.('RiseTime');
                    settlingTime1{3} = info.('SettlingTime');
                    settlingTime1{4} = info.('Overshoot');
                    settlingTime1{5} = syscl;
                    settlingTime1{6} = Acl;
                    
                    overshoot1{1} = P;
                    overshoot1{2} = info.('RiseTime');
                    overshoot1{3} = info.('SettlingTime');
                    overshoot1{4} = info.('Overshoot');
                    overshoot1{5} = syscl;
                    overshoot1{6} = Acl;
                    
                elseif cnt == 1
                    riseTime2{1} = P;
                    riseTime2{2} = info.('RiseTime');
                    riseTime2{3} = info.('SettlingTime');
                    riseTime2{4} = info.('Overshoot');
                    riseTime2{5} = syscl;
                    riseTime2{6} = Acl;
                    
                    settlingTime2{1} = P;
                    settlingTime2{2} = info.('RiseTime');
                    settlingTime2{3} = info.('SettlingTime');
                    settlingTime2{4} = info.('Overshoot');
                    settlingTime2{5} = syscl;
                    settlingTime2{6} = Acl;
                    
                    overshoot2{1} = P;
                    overshoot2{2} = info.('RiseTime');
                    overshoot2{3} = info.('SettlingTime');
                    overshoot2{4} = info.('Overshoot');
                    overshoot2{5} = syscl;
                    overshoot2{6} = Acl;
                    
                elseif cnt == 2
                    riseTime3{1} = P;
                    riseTime3{2} = info.('RiseTime');
                    riseTime3{3} = info.('SettlingTime');
                    riseTime3{4} = info.('Overshoot');
                    riseTime3{5} = syscl;
                    riseTime3{6} = Acl;
                    
                    settlingTime3{1} = P;
                    settlingTime3{2} = info.('RiseTime');
                    settlingTime3{3} = info.('SettlingTime');
                    settlingTime3{4} = info.('Overshoot');
                    settlingTime3{5} = syscl;
                    settlingTime3{6} = Acl;
                    
                    overshoot3{1} = P;
                    overshoot3{2} = info.('RiseTime');
                    overshoot3{3} = info.('SettlingTime');
                    overshoot3{4} = info.('Overshoot');
                    overshoot3{5} = syscl;
                    overshoot3{6} = Acl;
                    
                else
                    to_place={P, info.('RiseTime'), info.('SettlingTime'), info.('Overshoot'), syscl, Acl};
                    
                    [riseTime1, riseTime2, riseTime3] = sort4(riseTime1, riseTime2, riseTime3, to_place, 'RiseTime');
                    
                    [settlingTime1, settlingTime2, settlingTime3] = sort4(settlingTime1, settlingTime2, settlingTime3, to_place, 'SettlingTime');
                    
                    [overshoot1, overshoot2, overshoot3] = sort4(overshoot1, overshoot2, overshoot3, to_place, 'Overshoot');
                end
                cnt = cnt + 1;
    %        end
    %    end
    end
    riseTime1
    riseTime2
    riseTime3
    settlingTime1
    settlingTime2
    settlingTime3
    overshoot1
    overshoot2
    overshoot3
end

%sorted1 est le + petit et le 3 est le + grand
function [sorted1, sorted2, sorted3] = sort4(elm1, elm2, elm3, elm4, col)
    if strcmp(col, 'RiseTime')
        colnb = 2;
    elseif strcmp(col, 'SettlingTime')
        colnb = 3;
    else
        colnb = 4;
    end
    
    values = sort([elm1{colnb}, elm2{colnb}, elm3{colnb}, elm4{colnb}]);
    
   if values(1) == elm1{colnb} % 1
       sorted1 = elm1;
       if values(2) == elm2{colnb} % 1 2
           sorted2 = elm2;
           if values(3) == elm3{colnb} % 1 2 3
               sorted3 = elm3;
           else
               sorted3 = elm4; % 1 2 4
           end
       elseif values(2) == elm3{colnb} % 1 3
           sorted2 = elm3;
           if values(3) == elm2{colnb} % 1 3 2
               sorted3 = elm2;
           else
               sorted3 = elm4; % 1 3 4
           end
       else % 1 4
           sorted2 = elm4;
           if values(3) == elm2{colnb} % 1 4 2
               sorted3 = elm2;
           else
               sorted3 = elm3; % 1 4 3
           end
       end
   elseif values(1) == elm2{colnb} %2
       sorted1 = elm2;
       if values(2) == elm1{colnb} % 2 1
           sorted2 = elm1;
           if values(3) == elm3{colnb} % 2 1 3
               sorted3 = elm3;
           else
               sorted3 = elm4; % 2 1 4
           end
       elseif values(2) == elm3{colnb} % 2 3
           sorted2 = elm3;
           if values(3) == elm2{colnb} % 2 3 1
               sorted3 = elm1;
           else
               sorted3 = elm4; % 2 3 4
           end
       else % 2 4
           sorted2 = elm4;
           if values(3) == elm1{colnb} % 2 4 1
               sorted3 = elm1;
           else
               sorted3 = elm3; % 2 4 3
           end
       end
   elseif values(1) == elm3{colnb} %3
       sorted1 = elm3;
       if values(2) == elm1{colnb} %  3 1
           sorted2 = elm1;
           if values(3) == elm2{colnb} % 3 1 2
               sorted3 = elm2;
           else
               sorted3 = elm4; % 3 1 4
           end
       elseif values(2) == elm3{colnb} % 3 2
           sorted2 = elm2;
           if values(3) == elm1{colnb} % 3 2 1
               sorted3 = elm1;
           else
               sorted3 = elm4; % 3 2 4
           end
       else % 3 4
           sorted2 = elm4;
           if values(3) == elm1{colnb} % 3 4 1
               sorted3 = elm1;
           else
               sorted3 = elm2; % 3 4 2
           end
       end
   else %4
       sorted1 = elm4;
       if values(2) == elm1{colnb} % 4 1
           sorted2 = elm1;
           if values(3) == elm2{colnb} % 4 1 2
               sorted3 = elm2;
           else
               sorted3 = elm3; % 4 1 3
           end
       elseif values(2) == elm2{colnb} % 4 2
           sorted2 = elm2;
           if values(3) == elm1{colnb} % 4 2 1
               sorted3 = elm1;
           else
               sorted3 = elm3; % 4 2 3
           end
       else % 4 3
           sorted2 = elm3;
           if values(3) == elm1{colnb} % 4 3 1
               sorted3 = elm1;
           else
               sorted3 = elm2; %  4 3 2
           end
       end
   end       
end

function [settlingTime1, settlingTime2, settlingTime3] = getRange(A, B, C, D, range1, range2)
    %entre 5300 et 5500s
    settlingTime1 = {};
    settlingTime2 = {};
    settlingTime3 = {};
    j=1;
    while 1 == 1 %attention avec le i des imaginaire!!
        j
       % for j = -1:-10:-1
       %     for k = -1:-10:-1
                %P = [-j/100-0.0001i*j -j/100+0.0001i*j -j/100]; %faut jouer avec ca et la valeur de j
                P = [-10/j-0.001i*j -10/j+0.001i*j -10/j];
                K = place(A, B, P);
                Acl = A - B*K;
                
                syscl = ss(Acl, B, C, D);
                info = stepinfo(syscl);
                
                info.('SettlingTime')
                if info.('SettlingTime') >= range1 && info.('SettlingTime')<= range2
                    settlingTime2 = {P, info.('SettlingTime'), syscl, Acl};
                elseif info.('SettlingTime') < range1
                    settlingTime1 = {P, info.('SettlingTime'), syscl, Acl};
                else
                    settlingTime3 = {P, info.('SettlingTime'), syscl, Acl};
                end
                
                if  ~(isempty(settlingTime1)) &&  ~(isempty(settlingTime2)) &&  ~(isempty(settlingTime3))
                    break;
                end
                
                j=j+0.1;
    end
    
    settlingTime1
    settlingTime2
    settlingTime3
end