f = 1e3;
w = 2*pi*f;

C1 = 220e-9
R1 = 1e3
C2 = 1./(2./(220e-9))
R2 = 1e3
R3 = 100e3 + 3*10e3
R4 = 1e3

zc2 = 1/(j*w*C2);
zc1 = 1/(j*w*C1);
zo_t = abs(1/(1/R2+1/zc2));
zi_t = abs(zc1+R1);

vm = R1/(R1+zc1);
VA = (1+R3/R4)*vm;

#frequency analysis
f = logspace(1, 8, 1000);
w = 2*pi*f;

zc1 = 1./(j*w*C1);
zc2 = 1./(j*w*C2);

##zi = abs(zc1+R1);
##zo = abs(1./(1/R2+1./zc2));

T =(1+R3/R4).*(R1.*(1./zc1)./(1+R1.*(1./zc1))).*(1./(1+R2.*(1./zc2)));
gain1 = abs(T);
gain1_db = 20*log10(gain1);
phase = angle(T)*180/pi;

hf = figure ();
plot(log10(f), phase);
xlabel ("log10(f) [Hz]")
ylabel("Phase [degrees]");
title("Frequency response - Phase")

hf1 = figure();
plot(log10(f), gain1_db);
xlabel ("log10(f) [Hz]")
ylabel("Gain [dB]");
title("Frequency response - Gain")

print (hf,"gain.eps", "-depsc");
print (hf1,"phase.eps", "-depsc");
clear max;
M = max(gain1_db);

up_test = 0;
for i=1:length(gain1_db)
  if(gain1_db(i) == M)
    max_f = f(i+1)
  endif
  
  if (!up_test && gain1_db(i) >= M-3)
    lC_off = f(i)
    up_test = 1;
  endif

  if (up_test && gain1_db(i) <= M-3)
    hC_off = f(i)
    up_test = 0;
  endif
endfor

cf = sqrt(hC_off*lC_off) 

#Gain and impedance calculation at central frequency
gain2 = abs((R1*C1*2*pi*1000*j)/(1+R1*C1*2*pi*1000*j)*(1+R3/R4)*(1/(1+R2*C2*2*pi*1000*j)))
gain2_db = 20*log10(gain2)

gain_deviation = abs(gain2-100);

zi = abs(R1+1/(2*pi*cf*j*C1));
zo = abs(1./(1/R2+C2*2*pi*cf*j));

zi_1000 = (R1+1/(2*pi*1000*j*C1))
zo_1000 = (1./(1/R2+C2*2*pi*1000*j))

f_deviation = abs(cf-1000);

file = fopen("tab_teorica.tex", "w");
fprintf(file,"$gain_{db}$ & %.6e \\\\\ \\hline\n$gain_{deviation}$ & %.6e \\\\\ \\hline\n$cutoff_{low}$ & %.6e\\\\\ \\hline\n$cutoff_{high}$ & %.6e \\\\\\hline\n$central_{freq}$ & %.6e \\\\\\hline\n$central_{freq_{deviation}}$ & %.6e \\\\\\hline\nzin & %.3e%+.3e i \\\\\\hline\nabs(zi) & %.6e\\\\\\hline\nzo & %.3e%+.3e i \\\\\\hline\nabs(zo) & %.6e \\\\\\hline\n", gain2_db, gain_deviation, lC_off, hC_off, cf, f_deviation,real(zi_1000), imag(zi_1000),abs(zi_1000),real(zo_1000), imag(zo_1000), abs(zo_1000));
fclose(file);