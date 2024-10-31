DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_tables WHERE schemaname='public' AND tablename='district')
    THEN
        CREATE TABLE district (
            id SMALLSERIAL PRIMARY KEY,
            city VARCHAR(10) NOT NULL,
            "name" VARCHAR(50) NOT NULL UNIQUE,
            province SMALLINT NOT NULL,
            FOREIGN KEY (province) REFERENCES province(id) ON DELETE CASCADE
        );
    END IF;
END $$;