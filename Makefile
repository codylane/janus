all: download_vim_modules install


install:
	ln -sf $${PWD}/janus $${HOME}/.janus 2>>/dev/null


download_vim_modules:
	./bootstrap.sh
