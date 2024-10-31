DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_tables WHERE schemaname='public' AND tablename='village')
    THEN
        CREATE TABLE village (
            id SMALLSERIAL PRIMARY KEY,
            "name" VARCHAR(50) UNIQUE,
            zip_code VARCHAR(5) UNIQUE,
            subdistrict SMALLINT,
            FOREIGN KEY (subdistrict) REFERENCES subdistrict(id) ON DELETE CASCADE
        );
    END IF;
END $$;