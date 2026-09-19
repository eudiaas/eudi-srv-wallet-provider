-- La tabla del servicio en H2 en memoria, para el despliegue del laboratorio.
-- Solo guarda los retos de un solo uso (5 minutos de validez): perderlos al
-- reiniciar solo obliga a la wallet a pedir otro. Es el SQL que Exposed exige
-- para H2 (el servicio comprueba el esquema al arrancar y no lo crea).
CREATE TABLE IF NOT EXISTS CHALLENGES (ID NUMERIC(20) AUTO_INCREMENT PRIMARY KEY, "value" VARBINARY(128) NOT NULL, CREATED_AT TIMESTAMP(9) NOT NULL, EXPIRES_AT TIMESTAMP(9) NOT NULL, UNUSED BOOLEAN NOT NULL);
ALTER TABLE CHALLENGES ADD CONSTRAINT IF NOT EXISTS challenges_value_unique_idx UNIQUE ("value");
