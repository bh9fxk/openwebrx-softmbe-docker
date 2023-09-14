all:
	@docker build -t openwebrx-softmbe:latest .

run:
	@docker run -h openwebrx-softmbe --device /dev/bus/usb -p 8073:8073 -v openwebrx-settings:/var/lib/openwebrx openwebrx-softmbe:latest

push:
	@docker tag openwebrx-softmbe:latest bh9fxk/openwebrx-softmbe:latest
	@docker push bh9fxk/openwebrx-softmbe:latest
