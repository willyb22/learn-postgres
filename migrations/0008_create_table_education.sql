DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'degree')
    THEN
        CREATE TYPE DEGREE AS ENUM ('other', 'D3', 'S1', 'S2', 'S3');
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_tables WHERE schemaname='public' AND tablename='education')
    THEN
        CREATE TABLE education (
            id VARCHAR(5),
            "degree" DEGREE,
            major SMALLINT NOT NULL,
            university SMALLINT NOT NULL
        );
    END IF;
END $$;