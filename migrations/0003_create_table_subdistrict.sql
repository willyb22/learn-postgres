DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_tables WHERE schemaname='public' AND tablename='subdistrict')
    THEN
        CREATE TABLE subdistrict (
            id SMALLSERIAL PRIMARY KEY,
            "name" VARCHAR(50) NOT NULL UNIQUE,
            district SMALLINT NOT NULL,
            FOREIGN KEY (district) REFERENCES district(id) ON DELETE CASCADE
        );
    END IF;
END $$;