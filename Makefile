
all: remove_submodules


remove_submodules:
	@git submodule init
	@git submodule update
	@find janus -name '.git' | xargs rm -rf
	@rm -rf _backup
	@rm -rf _temp
	@[ -f .gitmodules ] && git rm -f .gitmodules || true
	@rm -f .gitmodules


update_submodules:
	@cd janus && \
		rake dev:update_submodules
