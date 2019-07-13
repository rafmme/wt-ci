VERSION ?= 0.0.1  
NAME ?= "WTC-TOWER"  
AUTHOR ?= "Timileyin Farayola"  
  
  
.PHONY: build destroy  
  
  
build:  
	chmod u+x ./build.sh && ./build.sh
  
  
destroy:  
	chmod u+x ./destroy.sh && ./destroy.sh
  
  
DEFAULT: build
