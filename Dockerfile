FROM nginx:1.15-alpine

COPY start.sh /start.sh

RUN apk add --update bash \
	&& rm -rf /var/cache/apk/* \
	&& chmod +x /start.sh

EXPOSE 80

CMD /start.sh
