#!/bin/sh
# Arranque en Railway: el servicio solo sabe leer la clave de firma de un
# fichero (SIGNINGKEY_KEYSTOREFILE), y en Railway no hay disco que dejar
# preparado. Si llega SIGNINGKEY_KEYSTOREBASE64, se escribe a un fichero que
# solo lee este proceso y se apunta ahi. El base64 no se imprime nunca.
set -eu

if [ -n "${SIGNINGKEY_KEYSTOREBASE64:-}" ]; then
  umask 077
  dir="$(mktemp -d)"
  printf '%s' "$SIGNINGKEY_KEYSTOREBASE64" | base64 -d > "$dir/keystore"
  export SIGNINGKEY_KEYSTOREFILE="$dir/keystore"
  unset SIGNINGKEY_KEYSTOREBASE64
fi

# Sin DATABASE_URL, H2 en memoria con la tabla creada al conectar. Para usar
# Postgres, DATABASE_URL=r2dbc:postgresql://... y aplicar schemas/postgresql.
if [ -z "${DATABASE_URL:-}" ]; then
  export DATABASE_URL="r2dbc:h2:mem:///wp;DB_CLOSE_DELAY=-1;INIT=RUNSCRIPT%20FROM%20'/app/h2-schema.sql'"
fi

# Railway da el puerto en PORT; el servicio lo lee de SERVER_PORT.
if [ -n "${PORT:-}" ] && [ -z "${SERVER_PORT:-}" ]; then
  export SERVER_PORT="$PORT"
fi

exec java ${JAVA_OPTS:-} -cp '/app/libs/*' eu.europa.ec.eudi.walletprovider.MainKt
