install: ./config_files_list.txt ./setup.py

	@echo "Installing..."
	python3 setup.py install


update: ./config_files_list.txt ./setup.py
	@echo "Building..."
	python3 setup.py build
