BIN=$(PWD)/bin
APP_DIR=$(PWD)/app

.PHONY: gen
gen: get-easyjson clean-easyjson
	@echo "Generate easyjson files ..."
	@$(GO_SH)/bin/easyjson -all $(APP_DIR)/entity/*.go $(APP_DIR)/entity/**/*.go
get-easyjson: $(GO_SH)/bin/easyjson
	@echo "Easyjson is installed"
$(GO_SH)/bin/easyjson:
	@echo "Installing easyjson ..."
	@go get github.com/mailru/easyjson/...
	@mv $(GOPATH)/bin/easyjson $(GO_SH)/bin/easyjson
clean-easyjson:
	@find $(APP_DIR)/entity/ -name "*_easyjson.go" -exec rm -rf {} \;	

.PHONY: get-swagger
get-swagger: $(GO_SH)/bin/swagger
	@echo "Swagger is installed"
$(BIN)/swagger:
	@echo "Installing swagger ..."
	@go get -u github.com/go-swagger/go-swagger/cmd/swagger
	@mv $(GOPATH)/bin/swagger $(GO_SH)/bin/swagger
gen-swagger: get-swagger
	@echo "Generate swagger.json ..."
	@$(GO_SH)/bin/swagger generate spec -o $(SWAGGER_FILE) -b ./app
	@sed -i -e "s/\[API_HOST\]/$(API_HOST)/g" $(SWAGGER_FILE)
	@sed -i -e "s/\[API_PORT\]/:$(API_PORT)/g" $(SWAGGER_FILE)
	@rm -rf "$(SWAGGER_FILE)-e"

.PHONY: build
build: deps build-fast build-ci build-migration

.PHONY: build-fast
fast-build: gen gen-swagger build-ci

.PHONY: build-dc
build-dc: gen gen-swagger build-ci
	@docker-compose restart api

.PHONY: build-ci
build-ci:
	@echo "Building ..."
	@GOOS=linux GOARCH=arm go build -o $(BIN)/app $(APP_DIR)/main.go