DO $$
DECLARE
    row RECORD;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM university)
    THEN
        CREATE TABLE temp_university (
            university_name VARCHAR(50)
        );

        COPY temp_university (university_name)
        FROM '/app/data/init-data/university.csv'
        DELIMITER ','
        CSV HEADER;

        INSERT INTO university ("name", count)
        SELECT university_name, 0
        FROM temp_university;

        TRUNCATE TABLE temp_university;
        DROP TABLE temp_university;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM major)
    THEN
        CREATE TABLE temp_major (
            major_name VARCHAR(50)
        );

        COPY temp_major (major_name)
        FROM '/app/data/init-data/major.csv'
        DELIMITER ','
        CSV HEADER;

        INSERT INTO major ("name", count)
        SELECT major_name, 0
        FROM temp_major;

        TRUNCATE TABLE temp_major;
        DROP TABLE temp_major;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM employee)
    THEN
        CREATE TABLE temp_personal_info(
            "name" VARCHAR(50),
            gender GENDER,
            email VARCHAR(50),
            "address" VARCHAR(511),
            education VARCHAR(50)
        );

        CREATE TABLE new_employee (
            id VARCHAR(5)
        );

        COPY temp_personal_info ("name",gender,email,"address",education)
        FROM '/app/data/init-data/employee.csv'
        DELIMITER ','
        CSV HEADER;

        FOR row IN SELECT * FROM temp_personal_info
        LOOP
            -- RAISE NOTICE 'name: %, gender: %', row.name, row.gender;

            WITH ne AS (
                INSERT INTO employee ("name", gender, email)
                VALUES (row.name, row.gender, row.email)
                RETURNING id
            ) -- return 1 row table
            INSERT INTO new_employee (id)
            SELECT ne.id 
            FROM ne;
            
            INSERT INTO address (id, street1, street2, village)
            SELECT 
                new_employee.id,
                SPLIT_PART(row.address, ', ', 1), 
                SPLIT_PART(row.address, ', ', 2), 
                village.id
            FROM village CROSS JOIN new_employee
            WHERE village.name = REPLACE(SPLIT_PART(row.address, ', ', 3), 'Gg. ', '');
            
            -- RAISE NOTICE 'degree: %', SPLIT_PART(row.education, '-', 1);
            WITH m AS (
                SELECT id
                FROM major
                WHERE major.name = SPLIT_PART(row.education, '-', 2) -- return 1 row
            ), u AS (
                SELECT id
                FROM university
                WHERE university.name = SPLIT_PART(row.education, '-', 3) --return 1 row
            )
            INSERT INTO education (id, degree, major, university)
            SELECT new_employee.id, SPLIT_PART(row.education, '-', 1)::DEGREE, m.id, u.id
            FROM new_employee CROSS JOIN m CROSS JOIN u;

            TRUNCATE TABLE new_employee;
        END LOOP;

        TRUNCATE TABLE temp_personal_info;
        DROP TABLE temp_personal_info;
        DROP TABLE new_employee;
    END IF;
END $$;