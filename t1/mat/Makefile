octave:
	octave malha.m > $@1.log
	octave nodal.m > $@2.log
	octave malha.m > ../doc/malha.tex
	octave nodal.m > ../doc/nodal.tex

clean:
	@rm -f octave1.log octave2.log octave-workspace *.eps *~

.PHONY: clean
