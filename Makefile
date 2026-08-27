CONTAINER_ID=janus-test

all: download_vim_modules install


install:
	ln -sf $${PWD}/janus $${HOME}/.vim 2>>/dev/null


download_vim_modules:
	./bootstrap.sh


docker_build:
	docker build -t $(CONTAINER_ID) --no-cache .


docker_run_container:
	docker run --rm -it --name $(CONTAINER_ID) $(CONTAINER_ID)
