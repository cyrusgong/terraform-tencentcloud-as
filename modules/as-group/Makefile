.PHONY: docs
docs:	## Generate terraform docs
	@terraform-docs markdown table ./ | awk '/Copyright/,/limitations under the License./ { next } 1' | cat ./docs/base.md - > README.md
#	@cat ./docs/footnotes.md >> README.md

.PHONY: fmt
fmt:	## Format terraform code
	@terraform fmt

.PHONY: help
help:	## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

.PHONY: lint
lint:	## Lint terraform code
	@terraform validate