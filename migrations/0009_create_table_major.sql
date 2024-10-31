DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM pg_tables WHERE schemaname='public' AND tablename='major')
    THEN
        CREATE TABLE major (
            id SMALLSERIAL PRIMARY KEY,
            "name" VARCHAR(50),
            count INT
        );
    END IF;
END $$;