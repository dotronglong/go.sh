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
	@curl -SLO https://api.github.com/repos/dotronglong/go.sh/tarball/master
	@tar -xzf master && rm -rf master
	@mv dotronglong-go.sh-* go.sh
-include $(GO_SH)/Makefile
```

- Then we need to install `go.sh` first.

```
make get-go.sh
```

- Now you can use a lot of helpful commands in this `Makefile` (see Commands section)

- In order to update `go.sh` run this command

```
make up-go.sh
```

### Commands

- Install dependencies for golang project

```
make deps
```

- Update dependencies for golang project

```
make up
```

- Clear glide cache

```
make cc
```