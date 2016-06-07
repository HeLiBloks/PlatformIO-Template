#  vim: set ts=4 sw=4 tw=0 foldenable foldmethod=syntax foldclose=all:
# Uncomment lines below if you have problems with $PATH
#SHELL := /bin/bash
#PATH := /usr/local/bin:$(PATH)
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
DOXYGEN_OUTPUT_DIRECTORY = 'dox'

all:
	platformio -f -c nvim run

upload:
	platformio -f -c nvim run --target upload

clean:
	platformio -f -c nvim run --target clean
	rm -rf ./tags ./cscope.out $(DOXYGEN_OUTPUT_DIRECTORY)/Doxygen
	unset \$CSCOPE_DB

program:
	platformio -f -c nvim run --target program

uploadfs:
	platformio -f -c nvim run --target uploadfs

update:
	platformio -f -c nvim update
	sudo platformio -f -c nvim upgrade

tags:
	find ./.pioenvs ./lib ./src -type f -regex ".*\(ino\|c\|h\|hpp\|cc\|cpp\)" -print | \
	ctags -L - --fields=afiklmnsStzZ --language-force=C++ --sort=1

cscope:
	find ./.pioenvs ./lib ./src -type f -regex ".*\(ino\|c\|h\|hpp\|cc\|cpp\)" -print | \
	cscope -i - && \
	export CSCOPE_DB=$(current_dir)cscope.out

doxygen:
	mkdir $(DOXYGEN_OUTPUT_DIRECTORY)
	doxygen -g $(DOXYGEN_OUTPUT_DIRECTORY)/Doxygen
	sed -i -re '/^EXTRACT_(ALL)|(PRIVATE)|(STATIC)/ s/NO/YES/g; /^CALL_GRAPH/ s/NO/YES/; /^HAVE_DOT/ s/NO/YES/g' $(DOXYGEN_OUTPUT_DIRECTORY)/Doxyfile
	sed -i -re '/^FILE_PATTERNS/  s/=(.*)/& *.ino/' $(DOXYGEN_OUTPUT_DIRECTORY)/Doxyfile
	sed -i -re '/^EXTENSION_MAPPING/  s/=(.*)/& ino=c/' $(DOXYGEN_OUTPUT_DIRECTORY)/Doxyfile
	sed -i -re '/^OUTPUT_DIRECTORY/    s/=(.*)/& $(DOXYGEN_OUTPUT_DIRECTORY)' $(DOXYGEN_OUTPUT_DIRECTORY)/Doxyfile
	doxygen $(DOXYGEN_OUTPUT_DIRECTORY)/Doxyfile

