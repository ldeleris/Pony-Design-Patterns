# Makefile

module="TOUS"

run: build repl
test: build eunit
tests: build eunits

build:
	@echo makes binaries
	erl -make

repl:
	@echo launch repl
	erl -pa \ebin

eunit:
ifeq ($(module),"TOUS")
	@echo "Test de tous les modules..."
	erl -noshell -pa \ebin -eval 'eunit:test("ebin", [verbose])' -s init stop
else
	@echo "Test du module " $(module)
	erl -noshell -pa \ebin -eval 'eunit:test($(module), [verbose])' -s init stop
endif

clean:
	@echo removes binaries...
	rm -rf ebin/*.beam 
	rm -rf ebin/erl_crash.dump
	rm -rf erl_crash.dump

.PHONY: all test clean