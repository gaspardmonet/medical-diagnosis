.PHONY: default
default: show

##@ Pattern tasks

help:
	@make -f common/Makefile MAKEFILE_LIST="Makefile common/Makefile" help

%:
	echo "Delegating $* target"
	make -f common/Makefile $*

install: operator-deploy post-install ## installs the pattern and loads the secrets
	echo "Installed"

post-install: ## Post-install tasks - load-secrets
	make load-secrets
	echo "Done"

update: upgrade
	echo "Bootstrapping Medical Diagnosis Pattern"
	make bootstrap

bootstrap:
	#./scripts/bootstrap-medical-edge.sh
	ansible-playbook -e pattern_repo_dir="{{lookup('env','PWD')}}" -e helm_charts_dir="{{lookup('env','PWD')}}/charts/all" ./ansible/site.yaml

test:
	@make -f common/Makefile PATTERN_OPTS="-f values-global.yaml -f values-hub.yaml" test
