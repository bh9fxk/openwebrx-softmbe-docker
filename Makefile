DATE=$(shell date +%F)
USER=bh9fxk
IMAGE=openwebrx-softmbe

all:
	@docker build -t openwebrx-softmbe:latest .

run:
	@docker run -h openwebrx-softmbe --device /dev/bus/usb -p 8073:8073 -v openwebrxplus-settings:/var/lib/openwebrx openwebrx-softmbe:latest


admin:
	@docker exec -it $(USER)/$(IMAGE) /usr/bin/openwebrx admin adduser bh9fxk

push:
	@docker tag $(USER)/$(IMAGE):latest
	@docker push $(USER)/$(IMAGE):$(DATE)
        @docker push $(USER)/$(IMAGE)
