up-go.sh:
	@rm -rf $(GO_SH)
	@make get-go.sh

.PHONY: deps
deps: get-go.sh
	@$(GO_SH)/make.sh deps

up: get-go.sh cc
	@$(GO_SH)/make.sh up

cc: get-go.sh
	@$(GO_SH)/make.sh cc

.PHONY: get-docker
get-docker: /usr/bin/docker
	@echo "Docker is installed"
/usr/bin/docker:
	@echo "Installing docker ..."
	@$(GO_SH)/install.sh docker