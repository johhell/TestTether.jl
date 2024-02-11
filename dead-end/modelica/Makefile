
MOs=$(wildcard *.mo)

EXE=F22


##----------------------------------------------------------------
	
$(EXE): buildMODEL.mos $(MOs)  Makefile
	omc buildMODEL.mos


##----------------------------------------------------------------
##----------------------------------------------------------------


clean:
	rm -f *.o *.c *.h  *.makefile   *.log *.libs  *log.txt  *result.txt  *result.mat   *.afs  LOG.txt  *.pkl
	
superclean:  clean
	rm -f   *.json  *res.mat *.pyc  *.xml  *.bin   *.intdata  *.realdata   $(EXE)

