DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'gender')
    THEN
        CREATE TYPE GENDER as ENUM ('male', 'female');
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_tables WHERE schemaname='public' AND tablename='employee')
    THEN
        CREATE TABLE employee (
            id VARCHAR(5) PRIMARY KEY,
            "name" VARCHAR(50) NOT NULL,
            birth_date DATE,
            "gender" GENDER,
            email VARCHAR(50) NOT NULL UNIQUE    
        );
    END IF;
END $$;