#  vim: set ts=4 sw=4 tw=0 foldenable foldmethod=syntax foldclose=all autochdir:
# Uncomment lines below if you have problems with $PATH
SHELL := /bin/bash
#PATH := /usr/local/bin:$(PATH)
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
DOXYGEN_OUTPUT_DIRECTORY = './doc'


all:
	platformio -f -c nvim run

upload:
	platformio -f -c nvim run --target upload

clean:
	platformio -f -c nvim run --target clean
	rm -rf ./tags ./cscope.out ./doc vimHighlightFile.vim
	if [[ -v $$CSCOPE_DB ]]; then unset $$CSCOPE_DB ; fi

program:
	platformio -f -c nvim run --target program

uploadfs:
	platformio -f -c nvim run --target uploadfs

update:
	platformio -f -c nvim update
	sudo platformio -f -c nvim upgrade

tags:
	find ./.pioenvs ./lib ./src -type f -regex ".*\(ino\|c\|h\|hpp\|cc\|cpp\)" -print | \
		ctags -L - --fields=afikmnsStZl --language-force=C++ --sort=1

vimHighlightFile:
	awk 'BEGIN{printf("syntax keyword Type\t")} \
			!/^[!]/ {printf("%s ", $$1)}END{print ""}' tags > vimHighlightFile.vim

cscope:
	find ./.pioenvs ./lib ./src -type f -regex ".*\(ino\|c\|h\|hpp\|cc\|cpp\)" -print | \
	cscope -b -i - && \
	export CSCOPE_DB=$$PWD/cscope.out

codequery:
	cqmakedb -s ./codequery.db -c ./cscope.out -t ./tags -p

#TODO: Improve sed to single pipe
doxygen:
	mkdir $(DOXYGEN_OUTPUT_DIRECTORY) && \
	doxygen -g Doxygen
	sed -i -re "/PROJECT_NAME/ s/My Project/"$${PWD##*/}"/" Doxygen
	sed -i -re "/PROJECT_NUMBER\s+[=]/ s/[=]/& "$$(git rev-parse HEAD)"/" Doxygen
	sed -i -re '/^EXTRACT_(ALL)|(PRIVATE)|(STATIC)/ s/NO/YES/g; /^CALL_GRAPH/ s/NO/YES/; /^HAVE_DOT/ s/NO/YES/g' Doxygen
	sed -i -re '/^FILE_PATTERNS/     s/=(.*)/& *.ino *.c *.txt *.h *.cpp /' Doxygen
	sed -i -re '/^EXTENSION_MAPPING/ s/=(.*)/& ino=c/' Doxygen
	sed -i -re '/^OUTPUT_DIRECTORY/  s/=(.*)/& doc/' Doxygen
	sed -i -re '/^RECURSIVE/ s/NO/YES/' Doxygen
	sed -i -re '/^OPTIMIZE_OUTPUT_FOR_C/ s/NO/YES/' Doxygen
	sed -i -re '/^INPUT\s+[=]/ s/[=]/& "src" "lib" ".pioenvs"/' Doxygen
	sed -i -re '/^PLANTUML_INCLUDE_PATH/  s/=/&"~\/apps\/plantuml\/plantuml.jar"/' Doxygen
	sed -i -re '/^ABREVIATE_BRIEF/ s/=/&"The $$name class"   "The $$name widget"  "The $$name file"   is  provides  specifies  contains  represents  a  an  the/' Doxygen
	doxygen Doxygen && firefox --new-tab ./doc/html/index.html

