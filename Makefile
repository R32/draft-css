# VER := git@$(shell git rev-parse --short HEAD)
# PAS should be provided by `make PAS=XXXXXX` when **RELEASE**
PAS := DEBUG


# HHC always return ERROR in cygwin even have successfully compiled
HHC := "D:/Program Files/HTML Help Workshop/hhc.exe"

# closure download: https://github.com/google/closure-compiler
##### save as "closure.cmd"
# @echo off
# java -jar "%~dp0closure-compiler-v20170423.jar" %*
##### save as "closure"
# basedir=`dirname "$0"`
# case `uname` in
#    *CYGWIN*) basedir=`cygpath -w "$basedir"`;;
# esac
# java -jar "$basedir/closure-compiler-v20170423.jar" "$@"
#####
CCJS:= closure

ifndef PAS
  $(error PAS must be provided. e.g: make all PAS=XXXXXX)
endif

#########
# START #
#########
all: css

css: dist/style.css

polyfill: dist/libs/js/polyfill.js

clean:
	rm -rf dist/style.css

.PHONY: clean

# monitor hss change on DOS> chokidar hss/*.hss hss/primer/*.hss -c "hss hss/style.hss -output dist/"
dist/style.css: hss/style.hss hss/primer.hss hss/comp.hss
	hss $< -output dist/

hss/primer.hss: $(foreach dir,hss/primer, $(wildcard $(dir)/*.hss))

# polyfill
dist/libs/js/polyfill.js: polyfill/classList.js polyfill/es6-promise.auto.js polyfill/fetch.js
	$(CCJS) --js_output_file $@ --compilation_level WHITESPACE_ONLY --js $^

polyfill-curl: fresh
	curl \
	-o polyfill/es6-promise.auto.js "https://raw.githubusercontent.com/stefanpenner/es6-promise/master/dist/es6-promise.auto.js" \
	-o polyfill/fetch.js "https://raw.githubusercontent.com/camsong/fetch-ie8/master/fetch.js"

fresh: