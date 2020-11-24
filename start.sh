#!/bin/bash
if [ -z "$REDIRECT_TARGET" ]; then
	echo "Redirect target variable not set (REDIRECT_TARGET)"
	exit 1
else
	# Add http if not set
	if ! [[ $REDIRECT_TARGET =~ ^https?:// ]]; then
		REDIRECT_TARGET="http://$REDIRECT_TARGET"
	fi

	# Add trailing slash
	if [[ ${REDIRECT_TARGET:length-1:1} != "/" ]]; then
		REDIRECT_TARGET="$REDIRECT_TARGET/"
	fi
fi

# Default to 80
LISTEN="80"
# Listen to PORT variable given on Cloud Run Context
if [ ! -z "$PORT" ]; then
	LISTEN="$PORT"
fi

# Default to permanent
TYPE="permanent"
if [ ! -z "$TEMPORARY"]; then
  TYPE="redirect"
fi

cat <<EOF > /etc/nginx/conf.d/default.conf
server {
	listen ${LISTEN};

	rewrite ^/(.*)\$ ${REDIRECT_TARGET}\$1 ${TYPE};
}
EOF


echo "Listening to $LISTEN, Redirecting HTTP requests to ${REDIRECT_TARGET}..."

exec nginx -g "daemon off;"
