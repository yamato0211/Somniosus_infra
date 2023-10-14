.PHONY: adr

ADR_COUNT:=$(shell find docs/adr -type f | wc -l | tr -d ' ') 
adr:
	npx scaffdog generate ADR --output 'docs/adr' --answer 'number:${ADR_COUNT}'