# go.sh
Bash scripts help life easier in golang project development

### How to use
- Create a `Makefile` and add below content to it

```
TOOLS_DIR = $(PWD)/tools
GO_SH = $(TOOLS_DIR)/go.sh
.PHONY: get-go.sh
get-go.sh: $(GO_SH)/make.sh
	@echo "Installed go.sh"
	$(GO_SH)/make.sh:
	@echo "Downloading go.sh"
	@mkdir -p $(TOOLS_DIR)
	@curl -SLO https://github.com/dotronglong/go.sh/archive/master.zip
	@unzip master.zip && mv go.sh-master $(GO_SH)
	@rm -rf master.zip
```