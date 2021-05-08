close all 
clear all

I_S = 1e-14
V_T=25.9e-3
eta = 1;
%ngspice values
R=600e3 + 15*eta*V_T/I_S/exp(0.74999/eta/V_T);
C=600e-6;
f=50;
A=23.5267e3;
w=2*pi*f;
t = linspace(0, 10e-2, 10000);
j = linspace(0,9,10);
vS = A*cos(w*t);

%envelope detector
vOhr = zeros(1, length(t));
vO = zeros(1, length(t));

tOFF = 1/w * atan(1/w/R/C);

vOnexp = A*cos(w*tOFF)*exp(-(t-tOFF)/R/C);
vOnexp2 = A*cos(w*tOFF)*exp(-(t-1/2/f-tOFF)/R/C);
vOnexp3 = A*cos(w*tOFF)*exp(-(t-2/2/f-tOFF)/R/C);
vOnexp4 = A*cos(w*tOFF)*exp(-(t-3/2/f-tOFF)/R/C);
vOnexp5 = A*cos(w*tOFF)*exp(-(t-4/2/f-tOFF)/R/C);
vOnexp6 = A*cos(w*tOFF)*exp(-(t-5/2/f-tOFF)/R/C);
vOnexp7 = A*cos(w*tOFF)*exp(-(t-6/2/f-tOFF)/R/C);
vOnexp8 = A*cos(w*tOFF)*exp(-(t-7/2/f-tOFF)/R/C);
vOnexp9 = A*cos(w*tOFF)*exp(-(t-8/2/f-tOFF)/R/C);
vOnexp10 = A*cos(w*tOFF)*exp(-(t-9/2/f-tOFF)/R/C);

##for j=1:10
##  for i=1:length(t)
##    vOnexp(j,i)  = A*cos(w*tOFF)*exp(-(t(i)-((j-1)/2/f)-tOFF)/R/C);
##  endfor
##endfor1/w/R/C)

for i=1:length(t)
  if (vS(i) > 0)
    vOhr(i) = vS(i);
  else
    vOhr(i) = -vS(i);
  endif
endfor

figure
plot(t*1000, vOhr)
hold

##for i=1:length(t)/10
##  if t(i) < tOFF 
##    vO(i) = abs(vS(i));
##  elseif vOnexp(1,i) > vOhr(i)
##    vO(i) = vOnexp(1,i);
##  elseif vOnexp(1,i) < vOhr(i)
##    vO(i) = abs(vS(i));
##  endif
##endfor

#for j=2:10
#  for i=((j-1)*length(t)/10):(j*length(t)/10)
#    if t(i) < (tOFF+(j-1)/2/f) 
#    vO(i) = abs(vS(i));
#  elseif vOnexp(j,i) > vOhr(i)
#    vO(i) = vOnexp(j,i);
#  elseif vOnexp(j,i) < vOhr(i)
#    vO(i) = abs(vS(i));
#  endif
#  endfor
#endfor

%for j=0:10
 for i=1:length(t)/10
    if t(i) < tOFF 
    vO(i) = abs(vS(i));
  elseif vOnexp(i) > vOhr(i)
    vO(i) = vOnexp(i);
  elseif vOnexp(i) < vOhr(i)   
    vO(i) = abs(vS(i));
  endif
endfor
%endfor

for i=(length(t)/10):(2*length(t)/10) 
  if t(i) < (tOFF+1/2/f)
    vO(i) = abs(vS(i));
  elseif vOnexp2(i) > vOhr(i)
    vO(i) = vOnexp2(i);
  elseif vOnexp2(i) < vOhr(i) 
    vO(i) = abs(vS(i));
  endif
endfor

for i=(2*length(t)/10):(3*length(t)/10) 
  if t(i) < (tOFF+2/2/f)
    vO(i) = abs(vS(i));
  elseif vOnexp3(i) > vOhr(i)
    vO(i) = vOnexp3(i);
  elseif vOnexp3(i) < vOhr(i) 
    vO(i) = abs(vS(i));
  endif
endfor

for i=(3*length(t)/10):(4*length(t)/10) 
  if t(i) < (tOFF+3/2/f)
    vO(i) = abs(vS(i));
  elseif vOnexp4(i) > vOhr(i)
    vO(i) = vOnexp4(i);
  elseif vOnexp4(i) < vOhr(i) 
    vO(i) = abs(vS(i));
  endif
endfor

for i=(4*length(t)/10):(5*length(t)/10) 
  if t(i) < (tOFF+4/2/f)
    vO(i) = abs(vS(i));
  elseif vOnexp5(i) > vOhr(i)
    vO(i) = vOnexp5(i);
  elseif vOnexp5(i) < vOhr(i) 
    vO(i) = abs(vS(i));
  endif
endfor

for i=(5*length(t)/10):(6*length(t)/10) 
  if t(i) < (tOFF+5/2/f)
    vO(i) = abs(vS(i));
  elseif vOnexp6(i) > vOhr(i)
    vO(i) = vOnexp6(i);
  elseif vOnexp6(i) < vOhr(i) 
    vO(i) = abs(vS(i));
  endif
endfor

for i=(6*length(t)/10):(7*length(t)/10) 
  if t(i) < (tOFF+6/2/f)
    vO(i) = abs(vS(i));
  elseif vOnexp7(i) > vOhr(i)
    vO(i) = vOnexp7(i);
  elseif vOnexp7(i) < vOhr(i) 
    vO(i) = abs(vS(i));
  endif
endfor

for i=(7*length(t)/10):(8*length(t)/10) 
  if t(i) < (tOFF+7/2/f)
    vO(i) = abs(vS(i));
  elseif vOnexp8(i) > vOhr(i)
    vO(i) = vOnexp8(i);
  elseif vOnexp8(i) < vOhr(i) 
    vO(i) = abs(vS(i));
  endif
endfor

for i=(8*length(t)/10):(9*length(t)/10) 
  if t(i) < (tOFF+8/2/f)
    vO(i) = abs(vS(i));
  elseif vOnexp9(i) > vOhr(i)
    vO(i) = vOnexp9(i);
  elseif vOnexp9(i) < vOhr(i) 
    vO(i) = abs(vS(i));
  endif
endfor


for i=(9*length(t)/10):(10*length(t)/10) 
  if t(i) < (tOFF+9/2/f)
    vO(i) = abs(vS(i));
  elseif vOnexp10(i) > vOhr(i)
    vO(i) = vOnexp10(i);
  elseif vOnexp10(i) < vOhr(i) 
    vO(i) = abs(vS(i));
  endif
endfor

%plot(t*1000, vOnexp2)
##for i=1:length(t)
##  printf("%f", vO(i));
##endfor

plot(t*1000, vO)
title("Envelope voltage v_e(t)")
xlabel ("t[ms]")
legend("rectified","envelope")
print ("venvlope.eps", "-depsc");

function f1 = f(vD,vS,R)
Is = 1e-14;
VT=25.9e-3;
eta = 1;
%f = 0.7499 + eta*VT - eta*VT/exp(vD/eta/VT)-vD
%f1 = 0.7499 + eta*VT - eta*VT/Is/exp(vD/eta/VT) - vD
%f1 = eta*VT/I_S/exp(vD/eta/VT)*Is*(exp(vD/eta/VT)-1)+0.7499-vD;
f1= vD*15 + R*Is*(exp(vD*15/VT/eta)-1)-vS;
endfunction

function fd = fd(vD,R)
Is = 1e-14;
VT=25.9e-3;
eta = 1;
%fd = exp(-vD/eta/VT)-1;
%fd = 1/Is/exp(vD/eta/VT)-1;
%fd =  (-1/Is/exp(vD/eta/VT))*Is*(exp(vD/eta/VT)-1)+1-1;
fd = 15 + R*Is*15/eta/VT * (exp(vD*15/VT/eta)-1);
endfunction

function vD_root = solve_vD (vS, R)
  delta = 1e-6;
  x_next = 0.65;

  do 
    x=x_next;
    x_next = x  - f(x, vS, R)/fd(x, R);
  until (abs(x_next-x) < delta)

  vD_root = x_next;
endfunction

n=16;
eta=1;
R1=600e3;
f=50;
w=2*pi*f;
t = linspace(0, 10e-2, 10000);

for i=1:length(t)
  vD = 0.75;
  rd = (eta * V_T)/(I_S*exp(vD/eta/V_T));
  rx = n*rd;
  vout(i)=rx*vO(i)/(rx+R1);
  %vout(i) = 0.75+(eta*V_T/I_S/exp(0.75/eta/V_T))*I_S*(exp(0.75/eta/V_T)-1);
  %vout(i) = vO(i)-vD;
  %vD = solve_vD(vO(i), R1);
endfor

figure
plot(t*1000, 16*0.7230475 + vout-12);
axis([0 100 -0.0001 0.0001]);
title("Output voltage v_o(t)-12")
xlabel ("t[ms]")
ylabel ("v_o - 12 [V]")
print ("vo.eps", "-depsc");

figure
plot(t*1000, 16*0.7230475 + vout);
axis([0 100 11.9999 12.0001])
title("Output voltage v_o(t)")
xlabel ("t[ms]")
ylabel ("v_o[V]")
print ("vo12.eps", "-depsc");

max = max(16*0.7230475 + vout);
min = min(16*0.7230475 + vout);
mean = mean(16*0.7230475 + vout);
ripple = max-min;
printf("%.5f\n", min);
printf("%.5f\n", max);
printf("%.5f\n", ripple);
printf("%.5f\n", mean);

file = fopen("tab_teorica.tex","w");
fprintf(file,"max & %.5f \\\\\ \\hline\nmin & %.5f \\\\\ \\hline\nripple & %.5f\\\\\ \\hline\nmean & %.5f \\\\\\hline\n", max, min, ripple, mean);
fclose(file); 