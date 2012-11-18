F90 = gfortran

fpipes : fpipes.f90
	$(F90) -o $@ $^

example-run : fpipes dummy.sh
	./fpipes ./dummy.sh
	
clean : fpipes.mod fpipes
	-rm $^