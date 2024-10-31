DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_tables WHERE schemaname='public' AND tablename='province')
    THEN
        CREATE TABLE province (
            id SMALLSERIAL PRIMARY KEY,
            "name" VARCHAR(50) NOT NULL UNIQUE
        );
    END IF;
END $$;