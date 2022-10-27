MAKE = make
CONTRIB = contrib
PYDIR   = idepi
SUBDIRS = $(wildcard $(CONTRIB)/hmmer*)
ENVIRONMENT = idepi_venv

create_venv: #create a virtual environment named idepi_venv
	python3 -m venv $(ENVIRONMENT)


# Please activate environment using "source idepi_venv/bin/activate" 
# before installing packages. 

install_dependencies: # all dependencies can be found in requirements.txt 
	pip install --upgrade pip
	pip install --upgrade cython
	pip install --upgrade setuptools
	pip install --upgrade wheel
	python -m pip install -r requirements.txt 
	pip install git+http://github.com/veg/BioExt
	pip install git+http://github.com/veg/hppy
	cd ./idepi_venv/lib
	git clone https://github.com/nlhepler/sklmrmr
	find sklmrmr -name '*.pyx' -exec cython {} \;
	cd ..
	pip install sklmrmr/
	
# Please use "pip setup.py install" to install idepi after install_dependencies 
	

deactivate_venv:
	deactivate 

remove_venv: deactivate_venv
	sudo rm -rf $(ENVIRONMENT)
	

all:
	@$(foreach var, $(SUBDIRS), $(MAKE) -C $(var) all;)
    
clean:
	@-$(foreach var, $(SUBDIRS), $(MAKE) -C $(var) clean;)
	@-rm $(PYDIR)/*.pyc

distclean: clean
	@-$(foreach var, $(SUBDIRS), $(MAKE) -C $(var) distclean;)
	@-rm $(PYDIR)/*.pyc
