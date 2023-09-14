all:
	@docker build -t --platform=linux/amd64,linux/arm64,linux/arm/v7 openwebrx-softmbe:latest-armv7l .

run:
	@docker run -h openwebrx-softmbe --device /dev/bus/usb -p 8073:8073 -v openwebrx-settings:/var/lib/openwebrx openwebrx-softmbe:latest

push:
	@docker tag openwebrx-softmbe:latest bh9fxk/openwebrx-softmbe:latest-armv7l
	@docker push bh9fxk/openwebrx-softmbe:latest-armv7l
