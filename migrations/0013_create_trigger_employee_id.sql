CREATE SEQUENCE custom_id_sequence
START WITH 1
INCREMENT BY 1;

CREATE OR REPLACE FUNCTION generate_employee_id()
RETURNS TRIGGER AS $$
DECLARE
    new_id VARCHAR(5);
BEGIN
    new_id := 'e' || LPAD(nextval('custom_id_sequence')::TEXT, 4, '0');
    NEW.id := new_id;
    RETURN NEW;
END; 
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER set_custom_id
BEFORE INSERT ON employee
FOR EACH ROW 
WHEN (NEW.id IS NULL)
EXECUTE FUNCTION generate_employee_id();