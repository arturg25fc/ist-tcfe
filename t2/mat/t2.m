close all
clear all

%%EX 1
pkg load symbolic

filename='data.txt'
fid = fopen(filename, 'r');

c = fscanf (filename, '%s = %f ;');
fclose(fid);

R1=c(3)*1000;
R2=c(6)*1000;
R3=c(9)*1000;
R4=c(12)*1000;
R5=c(15)*1000;
R6=c(18)*1000;
R7=c(21)*1000;
G1 = 1./R1;
G2 = 1./R2;
G3 = 1./R3;
G4 = 1./R4;
G5 = 1./R5;
G6 = 1./R6;
G7 = 1./R7;

Vs=c(24);
C=c(26)*10^-6;
Kb=c(29)*10^-3;
Kd=c(32)*10^3;

%------------------ESCREVER FICHEIRO 0 NGSPICE---------------------
fid0 = fopen("../sim/t0.cir", "w");

if(fid0 < 0)
  warning("\n\nfile 0 never opened");
  return;
end

fprintf(fid0,".OP");
fprintf(fid0, "\n");
fprintf(fid0,"R1 1 2 %f", R1);
fprintf(fid0, "\n");
fprintf (fid0, "R2 3 2 %f", R2);
fprintf(fid0, "\n");
fprintf (fid0, "R3 2 5 %f", R3);
fprintf(fid0, "\n");
fprintf (fid0, "R4 5 0 %f", R4);
fprintf(fid0, "\n");
fprintf(fid0, "R5 5 6 %f", R5);
fprintf(fid0, "\n");
fprintf (fid0, "R6 4 7 %f", R6);
fprintf(fid0, "\n");
fprintf (fid0, "R7 7 8 %f", R7);
fprintf(fid0, "\n");
fprintf (fid0, "Vs 1 0 %f", Vs);
fprintf(fid0, "\n");
fprintf (fid0, "Vfalsa 0 4 0.0");
fprintf(fid0, "\n");
fprintf (fid0, "Hd 5 8 Vfalsa %f", Kd);
fprintf(fid0, "\n");
fprintf (fid0, "Gb 6 3 2 5 %f", Kb);
fprintf(fid0, "\n");
fprintf(fid0,".END");
fprintf(fid0, "\n");

fclose(fid0);

%------------------ESCREVER FICHEIRO 2 NGSPICE---------------------
fid2 = fopen("../sim/t2.cir", "w");

if(fid2 < 0)
  warning("\n\nfile 2 never opened");
  return;
end

fprintf(fid2,".OP");
fprintf(fid2, "\n");
fprintf(fid2,"R1 0 2 %f", R1);
fprintf(fid2, "\n");
fprintf (fid2, "R2 3 2 %f", R2);
fprintf(fid2, "\n");
fprintf (fid2, "R3 2 5 %f", R3);
fprintf(fid2, "\n");
fprintf (fid2, "R4 5 0 %f", R4);
fprintf(fid2, "\n");
fprintf(fid2, "R5 5 6 %f", R5);
fprintf(fid2, "\n");
fprintf (fid2, "R6 4 7 %f", R6);
fprintf(fid2, "\n");
fprintf (fid2, "R7 7 8 %f", R7);
fprintf(fid2, "\n");
fprintf (fid2, "Vfalsa 0 4 0.0");
fprintf(fid2, "\n");
fprintf (fid2, "Hd 5 8 Vfalsa %f", Kd);
fprintf(fid2, "\n");
fprintf (fid2, "Gb 6 3 2 5 %f", Kb);
fprintf(fid2, "\n");
fprintf (fid2, "C 6 8 %fuF", c(26));
fprintf(fid2, "\n");
fprintf(fid2,".END");
fprintf(fid2, "\n");

fclose(fid2);

%------------------ESCREVER FICHEIRO 3 NGSPICE---------------------
fid3 = fopen("../sim/t3.cir", "w");

if(fid3 < 0)
  warning("\n\nfile 3 never opened");
  return;
end

fprintf(fid3,".OP");
fprintf(fid3, "\n");
fprintf(fid3,"R1 1 2 %f", R1);
fprintf(fid3, "\n");
fprintf (fid3, "R2 3 2 %f", R2);
fprintf(fid3, "\n");
fprintf (fid3, "R3 2 5 %f", R3);
fprintf(fid3, "\n");
fprintf (fid3, "R4 5 0 %f", R4);
fprintf(fid3, "\n");
fprintf(fid3, "R5 5 6 %f", R5);
fprintf(fid3, "\n");
fprintf (fid3, "R6 4 7 %f", R6);
fprintf(fid3, "\n");
fprintf (fid3, "R7 7 8 %f", R7);
fprintf(fid3, "\n");
fprintf (fid3, "Vs 1 0 0.0 ac 1 sin(0 1 1k)");
fprintf(fid3, "\n");
fprintf (fid3, "Vfalsa 0 4 0.0");
fprintf(fid3, "\n");
fprintf (fid3, "Hd 5 8 Vfalsa %f", Kd);
fprintf(fid3, "\n");
fprintf (fid3, "Gb 6 3 2 5 %f", Kb);
fprintf(fid3, "\n");
fprintf (fid2, "C 6 8 %fuF", c(26));
fprintf(fid2, "\n");
fprintf(fid3,".END");
fprintf(fid3, "\n");

fclose(fid3);

%---------------------------

B1=[Vs,0,0,0,0,0,0]';
M1=[1,0,0,0,0,0,0;-G1,G1+G2+G3,-G2,-G3,0,0,0;0,-G2-Kb,G2,Kb,0,0,0;0,-G3,0,G3+G4+G5,-G5,-G7,G7;0,Kb,0,-Kb-G5,G5,0,0;0,0,0,0,0,G6+G7,-G7;0,0,0,1,0,Kd*G6,-1];
x=M1\B1

V1=x(1);
V2=x(2);
V3=x(3);
V4=0.;
V5=x(4);
V6=x(5);
V7=x(6);
V8=x(7);

I1=(V1-V2)*G1;
I2=(V3-V2)*G2;
I3=(V2-V5)*G3;
I4=(V5-V4)*G4;
I5=(V5-V6)*G5;
I6=(-V7*G6);
I7=(V7-V8)*G7;
Is=-I1;
Ib=I5;
Id=-I7;

%PRINT VOLTAGES V1 V2 V3 V5 V6 V7 V8 in file
fid4= fopen("voltages.tex", "w+");
fprintf(fid4,"$I_b$ & %e\\\\ \\\hline\n$I_{R_1}$ & %e\\\\ \\\hline\n$I_{R_2}$ & %e\\\\ \\\hline\n$I_{R_3}$ & %e\\\\ \\\hline\n$I_{R_4}$ & %e\\\\ \\\hline\n$I_{R_5}$ & %e\\\\ \\\hline\n$I_{R_6}$ & %e\\\\ \\\hline\n$I_{R_7}$ & %e\\\\ \\\hline\n$V_1$ & %e\\\\ \\\hline\n$V_2$ & %e\\\\ \\\hline\n$V_3$ & %e\\\\ \\\hline\n$V_5$ & %e\\\\ \\\hline\n$V_6$ & %e\\\\ \\\hline \n$V_7$ & %e\\\\ \\\hline \n$V_8$ & %e\\\\ \\\hline \n$I_s$ & %e\\\\ \\\hline \n$I_d$ & %e\\\\ \\\hline\n", Ib,I1,I2,I3,I4,I5,I6,I7,x(1),x(2),x(3),x(4),x(5),x(6),x(7),Is,Id);
fclose(fid4);

%---------------------------------------

Vx=V6-V8;

%------------------ESCREVER FICHEIRO 1 NGSPICE (necessita Vx)---------------------
fid1 = fopen("../sim/t1.cir", "w");

if(fid1 < 0)
  warning("\n\nfile 1 never opened\n\n");
  return;
end

fprintf(fid1,".OP");
fprintf(fid1, "\n");
fprintf(fid1,"R1 0 2 %f", R1);
fprintf(fid1, "\n");
fprintf (fid1, "R2 3 2 %f", R2);
fprintf(fid1, "\n");
fprintf (fid1, "R3 2 5 %f", R3);
fprintf(fid1, "\n");
fprintf (fid1, "R4 5 0 %f", R4);
fprintf(fid1, "\n");
fprintf(fid1, "R5 5 6 %f", R5);
fprintf(fid1, "\n");
fprintf (fid1, "R6 4 7 %f", R6);
fprintf(fid1, "\n");
fprintf (fid1, "R7 7 8 %f", R7);
fprintf(fid1, "\n");
fprintf (fid1, "Vx 6 8 %f", Vx);
fprintf(fid1, "\n");
fprintf (fid1, "Vfalsa 0 4 0.0");
fprintf(fid1, "\n");
fprintf (fid1, "Hd 5 8 Vfalsa %f", Kd);
fprintf(fid1, "\n");
fprintf (fid1, "Gb 6 3 2 5 %f", Kb);
fprintf(fid1, "\n");
fprintf(fid1,".END");
fprintf(fid1, "\n");

fclose(fid1);

%-----------------

B2=[0,0,0,Vx,0,0]';
M2=[G1+G2+G3,-G2,-G3,0,0,0;-Kb-G2,G2,Kb,0,0,0;-G3+Kb,0,G3+G4-Kb,0,-G7,G7;0,0,0,1,0,-1;0,0,0,0,G6+G7,-G7;0,0,1,0,Kd*G6,-1];
x2=M2\B2

I12=-x2(1)*G1;
I22=(x2(2)-x2(1))*G2;
I32=(x2(1)-x2(3))*G3;
I42=(x2(3)-V4)*G4;
I52=(x2(3)-x2(4))*G5;
I62=(-x2(5)*G6);
I72=(x2(6)-x2(6))*G7;
Ib2=Kb*(x2(1)-x2(3));


Ix= (-Kb*(x2(1)-x2(3))+(x2(3)-x2(4))*G5);

Req=-Vx/Ix;
Tau=Req*C;

%PRINT V2 V3 V5 V6 V7 V8 Ix Req Tau in file

fid6= fopen("voltagesReqTau.tex", "w+");
fprintf(fid6,"$I_b$ & %e\\\\ \\\hline\n$I_{R_1}$ & %e\\\\ \\\hline\n$I_{R_2}$ & %e\\\\ \\\hline\n$I_{R_3}$ & %e\\\\ \\\hline\n$I_{R_4}$ & %e\\\\ \\\hline\n$I_{R_5}$ & %e\\\\ \\\hline\n$I_{R_6}$ & %e\\\\ \\\hline\n$I_{R_7}$ & %e\\\\ \\\hline\n$V_2$ & %e\\\\ \\\hline\n$V_3$ & %e\\\\ \\\hline\n$V_5$ & %e\\\\ \\\hline\n$V_6$ & %e\\\\ \\\hline \n$V_7$ & %e\\\\ \\\hline \n$V_8$ & %e\\\\ \\\hline \n$I_x$ & %e\\\\ \\\hline \n$R_{eq}$ & %e\\\\ \\\hline\n$\\tau$ & %e\\\\ \\\hline\n",Ib2,I12,I22,I32,I42,I52,I62,I72,x2(1),x2(2),x2(3),x2(4),x2(5),x2(6),Ix,Req,Tau);
fclose(fid6);



%------------------------

%time axis: 0 to 10ms with 1us steps
t=0:1e-6:20e-3; %s
v6n = Vx*exp(-t/Tau);

hf = figure ();
plot (t*1000, v6n, "r");
ylim([0 10])

xlabel ("t [ms]");
ylabel ("V6n(t) [V]");
print (hf, "v6n.eps", "-depsc");

%---------------------------
f=1000;

Vsf=1+0*j;
Vsf_phase=angle(Vsf);
Vsf_abs=abs(Vsf);

Y1=G1;
Y2=G2;
Y3=G3;
Y4=G4;
Y5=G5;
Y6=G6;
Y7=G7;
Yc=2*pi*f*C*j

B4=[Vsf,0,0,0,0,0,0]';
M4=[1,0,0,0,0,0,0;-Y1,Y1+Y2+Y3,-Y2,-Y3,0,0,0;0,-Y2-Kb,Y2,Kb,0,0,0;0,-Y3,0,Y3+Y4+Y5,-Y5-Yc,-Y7,Y7+Yc;0,Kb,0,-Kb-Y5,Yc+Y5,0,-Yc;0,0,0,0,0,Y6+Y7,-Y7;0,0,0,-1,0,-Kd*Y6,1];
x4=M4\B4

%PRINT VOLTAGES PHASORS V1 V2 V3 V5 V6 V7 V8 in file


%PRINT VOLTAGES V1 V2 V3 V5 V6 V7 V8 in file
fid7= fopen("voltage_phasors.tex", "w+");
fprintf(fid7,"$\\widetilde{V_1}$ & %f%+fj\\\\ \\\hline\n$\\widetilde{V_2}$ & %f%+fj\\\\ \\\hline\n$\\widetilde{V_3}$ & %f%+fj\\\\ \\\hline\n$\\widetilde{V_5}$ & %f%+fj\\\\ \\\hline\n$\\widetilde{V_6}$ & %f%+fj\\\\ \\\hline\n$\\widetilde{V_7}$ & %f%+fj\\\\ \\\hline\n$\\widetilde{V_8}$ & %f%+fj\\\\ \\\hline\n", real(x4(1)),imag(x4(1)),real(x4(2)),imag(x4(2)),real(x4(3)),imag(x4(3)),real(x4(4)),imag(x4(4)),real(x4(5)),imag(x4(5)),real(x4(6)),imag(x4(6)),real(x4(7)),imag(x4(7)));
fclose(fid7);

%-----------------------------

a=real(x4(5));
b=imag(x4(5));
amp=sqrt(a*a+b*b);
phi=-angle(x4(5));

v6f=amp*sin(2*pi*f*t-phi);

hf2 = figure ();
plot (t*1000, v6f, "b");
ylim([-3 3])

xlabel ("t [ms]");
ylabel ("V6f(t) [V]");
print (hf2, "v6f.eps", "-depsc");

%-----------------------------------
r = -5e-3:1e-6:20e-3;
v6t = zeros(size(r));
vsp= zeros(size(r));
cond1 = -5e-3<=r & r<0;
cond2 = 0<=r & r<20e-3;
v6t(cond1) = V6;
vsp(cond1)=Vs;
v6t(cond2) = amp*sin(2*pi*f*r(cond2)-phi)+Vx*exp(-r(cond2)/Tau);
vsp(cond2) = sin(2*pi*f*r(cond2));
hf9 = figure ();
plot (r*1000,v6t)
hold on;
plot (r*1000,vsp)
legend ({"v6(t)", "vs(t)"});
xlabel ("t [ms]");
ylabel ("v6(t) // vs(t) [V]");
print (hf9, "v6t.eps", "-depsc"); 

%--------------ALÍNEA 6---------------------
syms Y1e;
syms Y2e;
syms Y3e;
syms Y4e;
syms Y5e;
syms Y6e;
syms Y7e;
syms Yce;
syms Kbe;
syms Kde;
syms Vsfe; 
Z = vpa(0.0); 
O = vpa(1.0);

syms y_6;
syms y_8;

B5=[Vsfe,Z,Z,Z,Z,Z,Z]';
M5=[O,Z,Z,Z,Z,Z,Z;-Y1e,Y1e+Y2e+Y3e,-Y2e,-Y3e,Z,Z,Z;Z,-Y2e-Kbe,Y2e,Kbe,Z,Z,Z;Z,-Y3e,Z,Y3e+Y4e+Y5e,-Y5e-Yce,-Y7e,Y7e+Yce;Z,Kbe,Z,-Kbe-Y5e,Yce+Y5e,Z,-Yce;Z,Z,Z,Z,Z,Y6e+Y7e,-Y7e;Z,Z,Z,-O,Z,-Kde*Y6e,O];
x5=M5\B5;

y_6 = x5(5);
y_8 = x5(7);

fun_6 = matlabFunction(y_6);
fun_8 = matlabFunction(y_8);

f1=0.1:1e6;
y1_6 = fun_6(Kb, Kd, Vsf, Y1, Y3, Y4, Y5, Y6, Y7, 2*pi*f1*C*j);
y1_8 = fun_8(Kb, Kd, Vsf, Y1, Y3, Y4, Y6, Y7);

y1 = y1_6-y1_8;
Vsf_aux_phase  = 180/pi*Vsf_phase*ones(1, length(f1));
Vsf_aux_abs  = 20*log10(Vsf_abs)*ones(1, length(f1));

hf4 = figure();
plot(log10(f1), Vsf_aux_phase, "g");
hold on;
plot(log10(f1), 180/pi*angle(y1_6), "r");
hold on;
plot(log10(f1), 180/pi*angle(y1), "b");
legend ({"Vs", "V6", "Vc"});
xlabel ("log10(f)[Hz]");
ylabel ("Phase (degrees)");
xlim([-1 6])
ylim([-185, 5])
print (hf4, "phase_v6vcvs.eps", "-depsc");


hf5 = figure();
plot(log10(f1), Vsf_aux_abs, "g");
hold on;
plot(log10(f1), 20*log10(abs(y1_6)), "r");
hold on;
plot(log10(f1), 20*log10(abs(y1)), "b");
legend ({"Vs", "V6", "Vc"});
xlabel ("log10(f)[Hz]");
ylabel ("Magnitude [dB]");
xlim([-1 6])
print (hf5, "abs_v6vcvs.eps", "-depsc");
