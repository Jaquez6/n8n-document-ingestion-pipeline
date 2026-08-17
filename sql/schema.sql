CREATE TABLE documentos (
    id BIGSERIAL PRIMARY KEY,
    tipo_documento VARCHAR(30) NOT NULL,
    numero_documento VARCHAR(50) NOT NULL,
    fecha_emision DATE NOT NULL,
    fecha_vencimiento DATE,

    proveedor_nombre VARCHAR(255) NOT NULL,
    proveedor_ruc VARCHAR(20),
    proveedor_direccion TEXT,

    cliente_nombre VARCHAR(255) NOT NULL,
    cliente_ruc VARCHAR(20),
    cliente_direccion TEXT,

    moneda VARCHAR(3) NOT NULL,
    forma_pago VARCHAR(100),
    plazo_pago_dias INTEGER,

    items JSONB NOT NULL,           -- guarda el array completo de items
    impuestos JSONB,                -- guarda el array de impuestos
    subtotal NUMERIC(14,2),
    total NUMERIC(14,2) NOT NULL,

    estado_documento VARCHAR(20) DEFAULT 'vigente',
    documento_referencia VARCHAR(50),

    fuente_documento VARCHAR(10) NOT NULL,   -- pdf / email / csv
    canal_recepcion VARCHAR(20) NOT NULL,    -- adjunto / cuerpo_correo / upload_manual

    -- columnas de control del pipeline
    estado_validacion VARCHAR(20) DEFAULT 'pendiente',  -- pendiente / ok / revision / error
    motivo_revision TEXT,
    hash_duplicado VARCHAR(64),              -- hash(numero_documento + proveedor_ruc)
    raw_extraction JSONB,                    -- guarda el JSON crudo que devolvió el LLM (auditoría)
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_documentos_hash_duplicado ON documentos(hash_duplicado);
CREATE INDEX idx_documentos_numero ON documentos(numero_documento);