FROM nginx:1.13-alpine

COPY start.sh /start.sh

RUN apk add --update bash \
	&& rm -rf /var/cache/apk/* \
	&& chmod +x /start.sh

CMD /start.sh
