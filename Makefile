.PHONY: bootstrap


bootstrap:
	@[ -d pairing_tools ] || git clone https://gist.github.com/ece32f3f1a57a0644f00035dd6c5457f.git pairing_tools
	@cp pairing_tools/*.sh .
	@rm -rf pairing_tools
	@chmod 755 *.sh


zip:
	@git submodule init
	@git submodule update
	@rsync -a janus janus.git
	@find janus -name '.git' | xargs rm -rf
