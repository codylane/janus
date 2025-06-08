.PHONY: bootstrap


bootstrap:
	@[ -d pairing_tools ] || git clone https://gist.github.com/ece32f3f1a57a0644f00035dd6c5457f.git pairing_tools
	@cp pairing_tools/*.sh .
	@rm -rf pairing_tools
	@chmod 755 *.sh

install_janus: bootstrap
	@. pairing.sh && install_janus


remove_submodules:
	@git submodule init
	@git submodule update
	@find janus -name '.git' | xargs rm -rf
	@rm -rf _backup
	@rm -rf _temp
	@[ -f .gitmodules ] && git rm -f .gitmodules || true
	@rm -f .gitmodules
