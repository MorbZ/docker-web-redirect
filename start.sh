#!/bin/bash
if [ -z "$REDIRECT_TYPE" ]; then
	REDIRECT_TYPE="permanent"
fi

if [ -z "$REDIRECT_TARGET" ]; then
	echo "Redirect target variable not set (REDIRECT_TARGET)"
	exit 1
else
	# Add http if not set
	if ! [[ $REDIRECT_TARGET =~ ^https?:// ]]; then
		REDIRECT_TARGET="http://$REDIRECT_TARGET"
	fi
fi

# Default to 80
LISTEN="80"
# Listen to PORT variable given on Cloud Run Context
if [ ! -z "$PORT" ]; then
	LISTEN="$PORT"
fi

: ${RETAIN_PATH:='true'}
if [ "$RETAIN_PATH" = "true" ]; then
	cat <<EOF > /etc/nginx/conf.d/default.conf
	server {
		listen ${LISTEN};

		rewrite ^(.*)\$ ${REDIRECT_TARGET}\$1 ${REDIRECT_TYPE};
	}
EOF
else
	cat <<EOF > /etc/nginx/conf.d/default.conf
	server {
		listen ${LISTEN};

		rewrite ^(.*)\$ ${REDIRECT_TARGET} ${REDIRECT_TYPE};
	}
EOF
fi


echo "Listening to $LISTEN, Redirecting HTTP requests to ${REDIRECT_TARGET}..."

exec nginx -g "daemon off;"
