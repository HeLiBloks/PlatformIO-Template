# Uncomment lines below if you have problems with $PATH
#SHELL := /bin/bash
#PATH := /usr/local/bin:$(PATH)
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
DOXYGEN_OUTPUT_DIRECTORY = 'doc'

all:
	platformio -f -c nvim run

upload:
	platformio -f -c nvim run --target upload

clean:
	platformio -f -c nvim run --target clean
	rm -f ./tags ./cscope.out
	unset $CSCOPE_DB

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
	[ -f $(DOXYGEN_OUTPUT_DIRECTORY) ] && mkdir $(DOXYGEN_OUTPUT_DIRECTORY)
	doxygen -g $(DOXYGEN_OUTPUT_DIRECTORY)/Doxygen
	sed -i -re '/^EXTRACT_(ALL)|(PRIVATE)|(STATIC)/ s/NO/YES/g; /^CALL_GRAPH/ s/NO/YES/g; /^HAVE_DOT/ s/NO/YES/g' Doxyfile
	sed -i -re '/^FILE_PATTERNS/  s/=(.*)/& *.ino/' Doxyfile
	sed -i -re '/^EXTENSION_MAPPING/  s/=(.*)/& ino=c/' Doxyfile
	sed -i -re '/^OUTPUT_DIRECTORY/    s/=(.*)/& $(DOXYGEN_OUTPUT_DIRECTORY)/' Doxyfile
	doxygen $(DOXYGEN_OUTPUT_DIRECTORY)/Doxyfile

