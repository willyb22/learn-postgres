DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM pg_tables WHERE schemaname='public' AND tablename='university')
    THEN
        CREATE TABLE university (
            id SMALLSERIAL PRIMARY KEY,
            "name" VARCHAR(50),
            count INT
        );
    END IF;
END $$;