DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM province)
    THEN
        COPY province (name)
        FROM '/app/data/init-data/province.csv'
        DELIMITER ','
        CSV HEADER;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM district)
    THEN
        CREATE TABLE temp_district (
            province_name VARCHAR(50),
            city_name VARCHAR(10),
            district_name VARCHAR(50)
        );

        COPY temp_district (province_name, city_name, district_name)
        FROM '/app/data/init-data/district.csv'
        DELIMITER ','
        CSV HEADER;

        INSERT INTO district (city, "name", province)
        SELECT t.city_name, t.district_name, p.id
        FROM temp_district t JOIN province p
        ON p.name = t.province_name;

        TRUNCATE TABLE temp_district;
        DROP TABLE temp_district;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM subdistrict)
    THEN
        CREATE TABLE temp_subdistrict (
            district_name VARCHAR(50),
            subdistrict_name VARCHAR(50)
        );

        COPY temp_subdistrict (district_name, subdistrict_name)
        FROM '/app/data/init-data/subdistrict.csv'
        DELIMITER ','
        CSV HEADER;

        INSERT INTO subdistrict ("name", district)
        SELECT t.subdistrict_name, d.id
        FROM temp_subdistrict t JOIN district d
        ON d.name = t.district_name;

        TRUNCATE TABLE temp_subdistrict;
        DROP TABLE temp_subdistrict;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM village)
    THEN
        CREATE TABLE temp_village (
            zip_code VARCHAR(5),
            village_name VARCHAR(50),
            subdistrict_name VARCHAR(50)
        );

        COPY temp_village (subdistrict_name, village_name, zip_code)
        FROM '/app/data/init-data/village.csv'
        DELIMITER ','
        CSV HEADER;

        INSERT INTO village  ("name", zip_code, subdistrict)
        SELECT t.village_name, t.zip_code, s.id
        FROM temp_village t JOIN subdistrict s
        ON s.name = t.subdistrict_name;

        TRUNCATE TABLE temp_village;
        DROP TABLE temp_village;
    END IF;
END $$;