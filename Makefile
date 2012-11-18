F90 = gfortran

fpipes-test : fpipes.f90 fpipes-test.f90
	$(F90) -o $@ $^

example-run : fpipes-test dummy.sh
	./fpipes-test ./dummy.sh
	
clean : fpipes.mod fpipes-test
	-rm $^