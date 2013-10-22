.PHONY: all deps compile shell

all: deps compile

deps:
	rebar get-deps

compile:
	rebar compile

shell: all
	erl -pa ebin deps/*/ebin
