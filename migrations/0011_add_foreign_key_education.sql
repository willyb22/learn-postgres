DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_tables WHERE tablename='education')
    THEN
        ALTER TABLE education
        ADD CONSTRAINT fk_major
        FOREIGN KEY (major) REFERENCES major (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE;

        ALTER TABLE education
        ADD CONSTRAINT fk_university
        FOREIGN KEY (university) REFERENCES university (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE;
    END IF;

END $$;