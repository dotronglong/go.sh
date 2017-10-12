BIN=$(PWD)/bin
APP_DIR=$(PWD)/app

############## GENERATE ##############
.PHONY gen
gen: gen-easyjson gen-config
	@eval $(GENS)
gen-config:
	@go run $(APP_DIR)/global/config/main.go --output=$(PWD)/etc/example.ini
	@$(GO_SH)/common.sh info "File created at $(PWD)/etc/example.ini"
gen-easyjson: get-easyjson clean-easyjson
	@echo "Generate easyjson files ..."
	@$(GO_SH)/bin/easyjson -all $(APP_DIR)/entity/*.go $(APP_DIR)/entity/**/*.go
get-easyjson: $(GO_SH)/bin/easyjson
	@echo "Easyjson is installed"
$(GO_SH)/bin/easyjson:
	@echo "Installing easyjson ..."
	@go get github.com/mailru/easyjson/...
	@cp $(GOPATH)/bin/easyjson $(GO_SH)/bin/easyjson
clean-easyjson:
	@find $(APP_DIR)/entity/ -name "*_easyjson.go" -exec rm -rf {} \;
	@find $(APP_DIR)/entity/ -name "easyjson-bootstrap*" -exec rm -rf {} \;

.PHONY: get-swagger
get-swagger: $(GO_SH)/bin/swagger
	@echo "Swagger is installed"
$(GO_SH)/bin/swagger:
	@echo "Installing swagger ..."
	@go get -u github.com/go-swagger/go-swagger/cmd/swagger
	@cp $(GOPATH)/bin/swagger $(GO_SH)/bin/swagger
gen-swagger: get-swagger
	@echo "Generate swagger.json ..."
	@$(GO_SH)/bin/swagger generate spec -o $(SWAGGER_FILE) -b ./app
	@sed -i -e "s/\[API_HOST\]/$(API_HOST)/g" $(SWAGGER_FILE)
	@sed -i -e "s/\[API_PORT\]/:$(API_PORT)/g" $(SWAGGER_FILE)
	@rm -rf "$(SWAGGER_FILE)-e"
.PHONY: get-migration
get-migration:
	@echo "Installing migration ..."
	@GOOS=linux GOARCH=amd64 go get -u github.com/goline/migrate
	@cp $(GOPATH)/bin/linux_amd64/migrate $(BIN)/migrate
	@echo "Installed for Linux"
	@go get -u github.com/goline/migrate
	@echo "Installed for macOS"
.PHONY: get-ginkgo
get-ginkgo: $(GO_SH)/bin/ginkgo
	@echo "Ginkgo is installed"
$(GO_SH)/bin/ginkgo:
	@echo "Installing ginkgo ..."
	@go get -u github.com/onsi/ginkgo/ginkgo
	@go get -u github.com/onsi/gomega
	@cp $(GOPATH)/bin/ginkgo $(GO_SH)/bin/ginkgo

############## BUILD ##############
.PHONY: build
build: deps build-fast build-ci

.PHONY: build-fast
build-fast: gen build-ci

.PHONY: build-dc
build-dc: build-fast
	@docker-compose restart api

.PHONY: build-ci
build-ci:
	@echo "Building ..."
	@GOOS=linux GOARCH=amd64 go build -o $(BIN)/api $(APP_DIR)/main.go