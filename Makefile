CMD      = /usr/bin/docker
IMAGE    = mogeko/qbittorrent
VERSION  = 4.3.8-r0
PORT     = 8080
CONF_DIR = $(shell pwd)/example/config
DL_DIR   = $(shell pwd)/example/data

.PHONY: all build run help

all: build run

build:
	@$(CMD) build . \
	--build-arg VERSION=$(VERSION) \
	--tag $(IMAGE)

run: id := $(shell head -200 /dev/urandom | cksum | cut -f1 -d " ")
run:
	@-$(CMD) run -it \
	--name qbt-$(id) \
	-p 6881:6881 \
	-p 6881:6881/udp \
	-p $(PORT):8080 \
	-v $(CONF_DIR):/config \
	-v $(DL_DIR):/downloads \
	$(IMAGE)
	@$(CMD) rm -f qbt-$(id)

help: id := $(shell head -200 /dev/urandom | cksum | cut -f1 -d " ")
help:
	@-$(CMD) run -it --name qbt-$(id) $(IMAGE) --help
	@$(CMD) rm -f qbt-$(id)

rm: clean
