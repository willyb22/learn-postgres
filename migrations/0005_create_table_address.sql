DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_tables WHERE schemaname='public' AND tablename='address')
    THEN
        CREATE TABLE address (
            id VARCHAR (5),
            street1 VARCHAR(255) NOT NULL,
            street2 VARCHAR(255),
            village SMALLINT,
            FOREIGN KEY (village) REFERENCES village(id)
        );
    END IF;
END $$;