.PHONY: deps
deps: get-go.sh
	@$(GO_SH)/make.sh deps

up: get-go.sh
	@$(GO_SH)/make.sh up

cc: get-go.sh
	@$(GO_SH)/make.sh cc