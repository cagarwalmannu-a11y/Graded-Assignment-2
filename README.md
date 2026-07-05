# Database Normalization and SQL Queries

## Normalization Steps
1.  Identified partial dependencies:
    *   `student_id → student_name`
    *   `course_code → course_name, instructor_name, instructor_email`
    *   `advisor_name → advisor_email`
    *   `instructor_name → instructor_email`
2.  Identified transitive dependencies:
    *   `course_code → instructor_name → instructor_email`
3.  Decomposed tables into BCNF:
    *   `Advisor(advisor_name, advisor_email)`
    *   `Instructor(instructor_name, instructor_email)`
    *   `Course(course_code, course_name, instructor_name)`
    *   `Student(student_id, student_name, advisor_name)`
    *   `Enrollment(student_id, course_code, enrollment_year, marks_obtained)`

## Design Decisions
*   Used `VARCHAR(50)` for names and `VARCHAR(100)` for emails
*   Used `INT` for student IDs and `DECIMAL(4,2)` for marks
*   Used `EXTRACT(YEAR FROM CURRENT_DATE)` as default for enrollment year

## Transaction Analysis
*   Used `BEGIN` and `COMMIT` for transaction control
*   Used `ROLLBACK` to handle errors
*   Discussed concurrency anomalies and isolation levels
*   Explained MVCC read behaviour and trade-offs of higher isolation levels
