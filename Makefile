all: markdown csv

markdown: Perl_Companies.yaml
	./scripts/yaml2md.pl Perl_Companies.yaml 

csv: Perl_Companies.yaml
	./scripts/yaml2csv.pl Perl_Companies.yaml 
