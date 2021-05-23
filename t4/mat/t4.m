%gain stage

VT=25e-3;
BFN=178.7;
VAFN=69.7;
RE1=100;
RE2 = 200;
RC1=800;
RB1=120000;
RB2=20000;
VBEON=0.7;
VCC=12;
RS=100;

RB=1/(1/RB1+1/RB2);
VEQ=RB2/(RB1+RB2)*VCC;
IB1=(VEQ-VBEON)/(RB+(1+BFN)*RE1)
IC1=BFN*IB1
IE1=(1+BFN)*IB1
VE1=RE1*IE1
VO1=VCC-RC1*IC1
VCE1 = VO1-VE1
VEB1 = VBEON
VB1 = VBEON + VE1
VC1 = VO1

 
gm1=IC1/VT;
rpi1=BFN/gm1;
ro1=VAFN/IC1;

RSB=RB*RS/(RB+RS);


AV1 = RSB/RS * RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RSB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2);
AVI_DB = 20*log10(abs(AV1));
AV1simple = RB/(RB+RS) * gm1*RC1/(1+gm1*RE1);
AVIsimple_DB = 20*log10(abs(AV1simple));

RE1=0;
AV1 = abs(RSB/RS * RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RSB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2));
AVI_DB = 20*log10(abs(AV1));
AV1simple =  - RSB/RS * gm1*RC1/(1+gm1*RE1);
AVIsimple_DB = 20*log10(abs(AV1simple));

RE1=100;
ZI1 = 1/(1/RB+1/(((ro1+RC1+RE1)*(rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1)));
ZX = ro1*((RSB+rpi1)*RE1/(RSB+rpi1+RE1))/(1/(1/ro1+1/(rpi1+RSB)+1/RE1+gm1*rpi1/(rpi1+RSB)));
ZX = ro1*(   1/RE1+1/(rpi1+RSB)+1/ro1+gm1*rpi1/(rpi1+RSB)  )/(   1/RE1+1/(rpi1+RSB));
ZO1 = 1/(1/ZX+1/RC1);

RE1=0;
ZI1 = 1/(1/RB+1/(((ro1+RC1+RE1)*(rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1)));
ZO1 = 1/(1/ro1+1/RC1);

%ouput stage
BFP = 227.3;
VAFP = 37.2;
RE2 = 200;
VEBON = 0.7;
VI2 = VO1;
VC2 = 0;
IE2 = (VCC-VEBON-VI2)/RE2
IC2 = BFP/(BFP+1)*IE2
VO2 = VCC - RE2*IE2;


IB2 = IC2/BFP
IB2 = IC2/BFP
VE2=VO2
VEB2 = VE2 - VI2
VEC2 = VE2 - VC2

%VIN = 0;

gm2 = IC2/VT;
go2 = IC2/VAFP;
gpi2 = gm2/BFP;
ge2 = 1/RE2;

AV2 = gm2/(gm2+gpi2+go2+ge2);
ZI2 = (gm2+gpi2+go2+ge2)/gpi2/(gpi2+go2+ge2);
ZO2 = 1/(gm2+gpi2+go2+ge2);


%total
gB = 1/(1/gpi2+ZO1);
AV = abs((gB+gm2/gpi2*gB)/(gB+ge2+go2+gm2/gpi2*gB)*AV1);
AV_DB = 20*log10(abs(AV));
ZI=ZI1;
ZO=1/(go2+gm2/gpi2*gB+ge2+gB);

Cin = 11e-6;
Co = 175e-6;
Cb=400e-6;
RE1=100;
RL = 8;
  
gainplot=[];
gainplot_DB=[];
i=1;

for f=1:0.1:8
	w=2*pi*power(10,f);
	Zcin = 1 ./(j*w*Cin);
	Zco = 1 ./(j*w*Co);
  Zcb= 1 ./(j*w*Cb);
 
	A=[1/RS+1/Zcin,-1/Zcin,0,0,0,0;
  -1/Zcin,1/RB1+1/RB2+1/Zcin+1/rpi1,-1/rpi1,0,0,0;
  0,-1/rpi1-gm1,1/RE1+1/Zcb+1/rpi1+1/ro1+gm1,-1/ro1,0,0;
  0,gm1,-1/ro1-gm1,1/RC1+1/ro1+gpi2,-gpi2,0;
  0,0,0,-gpi2-gm2,1/RE2+1/Zco+gpi2+go2+gm2,-1/Zco;
  0,0,0,0,-1/Zco,1/RL+1/Zco];

	B=[0.01/RS,VCC/RB1,0,VCC/RC1,VCC/RE2,0]';
	
	X=A\B;
  
  gainplot(i)=abs(X(6))./0.01;
	gainplot_DB(i)=20*log10(abs(gainplot(i)));
  i=i+1;
endfor

f = 1:0.1:8;
theo = figure();
plot (f, gainplot_DB, "r");
legend("Gain");
xlabel ("log_{10}(f) [Hz]");
ylabel ("dB(v(out))");
print (theo, "theo.eps", "-depsc");

file0 = fopen("inc_theo.tex", "w");
fprintf(file0,"gm1 & %.6e \\\\\ \\hline\nrpi1 & %.6e \\\\\ \\hline\nro1 & %.6e\\\\\ \\hline\ngm2 & %.6e \\\\\\hline\ngpi2 & %.6e \\\\\\hline\ngo2 & %.e \\\\\\hline\n ", gm1, rpi1, ro1, gm2, gpi2, go2);
fclose(file0);

file = fopen("op_theo.tex","w");
fprintf(file,"base & %.6e \\\\\ \\hline\ncoll & %.6e \\\\\ \\hline\nemit & %.6e\\\\\ \\hline\nemit2 & %.6e \\\\\\hline\n", VB1, VC1, VE1, VE2);
fprintf(file,"VBE1 & %.6e \\\\\ \\hline\nVCE1 & %.6e \\\\\ \\hline\nVEB2 & %.6e\\\\\ \\hline\nVEC2 & %.6e \\\\\\hline\n", VEB1, VCE1, VEB2, VEC2);
fprintf(file,"q1[ib] & %.6e \\\\\ \\hline\nq1[ie] & %.6e \\\\\ \\hline\nq1[ic] & %.6e\\\\\ \\hline\nq2[ib] & %.6e \\\\\\hline\n", IB1, IE1, IC1, IB2);
fprintf(file,"q2[ie] & %.6e \\\\\ \\hline\nq2[ic] & %.6e \\\\\ \\hline\n", IE2, IC2);
fclose(file);

file1= fopen("Z_theo.tex", "w");
fprintf(file1,"ZI1 & %.6e \\\\\ \\hline\nZO1 & %.6e \\\\\ \\hline\nZI2 & %.6e\\\\\ \\hline\nZO2 & %.6e \\\\\\hline\nZI & %.6e \\\\\\hline\nZO & %.6e \\\\\\hline\n", ZI1, ZO1, ZI2, ZO2, ZI, ZO);
fclose(file1);

file2 = fopen("gain_theo.tex", "w");
fprintf(file2,"gain1 & %.6e \\\\\ \\hline\ngain2 & %.6e \\\\\ \\hline\ngaintotal & %.6e\\\\\ \\hline\ngaintotaldb & %.6e \\\\\\hline\n", AV1, AV2, AV, AV_DB);
fclose(file2); 