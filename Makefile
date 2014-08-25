# Labsynapse repo migrate Makefile.
# Migrate database or rollback on error.

#for include env_vars uncomment following line:
#include env_vars.sh

.PHONY: all

all:
	bash migrate.sh
