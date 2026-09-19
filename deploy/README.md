# Despliegue en Railway (laboratorio espuni)

Rama `railway`. Añade al servicio de referencia lo justo para Railway, sin
tocar el código Kotlin:

| Fichero | Para qué |
|---|---|
| `Dockerfile` | Railway construye desde el repositorio; la imagen oficial es de Jib |
| `deploy/copy-runtime.init.gradle.kts` | copia el classpath de ejecución junto al jar |
| `deploy/entrypoint.sh` | la clave de firma por variable (`SIGNINGKEY_KEYSTOREBASE64`), `PORT` → `SERVER_PORT`, y H2 por defecto |
| `deploy/h2-schema.sql` | la tabla `challenges` en H2 en memoria |

## Variables

| Variable | Valor |
|---|---|
| `SIGNINGKEY_KEYSTOREBASE64` | el PKCS12 del `wia-signer` del Trust Lab, en base64 |
| `SIGNINGKEY_KEYSTORETYPE` | `PKCS12` |
| `SIGNINGKEY_KEYSTOREPASSWORD` / `SIGNINGKEY_KEYPASSWORD` | su contraseña |
| `SIGNINGKEY_KEYALIAS` | `wia-signer` |
| `SIGNINGKEY_ALGORITHM` | `ES256` |
| `ISSUER_PUBLICURL` / `ISSUER_NAME` | la URL pública del servicio y su nombre |
| `WALLETINSTANCEATTESTATION_WALLETNAME` / `_WALLETVERSION` / `_WALLETSOLUTIONCERTIFICATIONINFORMATION` | lo que viaja en la WIA |
| `KEYATTESTATION_CERTIFICATION` | URL de certificación de las key attestations |
| `TOKENSTATUSLISTSERVICE_SERVICEURL` | `http://<consola trust-lab>/api/v1/status/take`, por la red privada |
| `TOKENSTATUSLISTSERVICE_APIKEY` | el `CONSOLE_STATUS_TOKEN` de esa consola |

Sin `PLATFORMKEYATTESTATION*` no se valida ninguna atestación de plataforma:
es el modo de laboratorio, y no sirve fuera de él.
