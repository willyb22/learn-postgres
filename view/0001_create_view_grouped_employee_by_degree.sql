CREATE VIEW grouped_employee_by_degree AS
SELECT degree, COUNT(id) AS employee_count
FROM employee
GROUP BY degree
ORDER BY employee_count DESC;