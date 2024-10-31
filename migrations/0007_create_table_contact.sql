DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM pg_tables WHERE schemaname='public' AND tablename='contact')
    THEN
        CREATE TABLE contact (
            id VARCHAR(5),
            phone VARCHAR(15),
            linkedin VARCHAR(255),
            FOREIGN KEY (id) REFERENCES employee (id) ON DELETE CASCADE
        );
    END IF;
END $$;