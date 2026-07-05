-- Insert data
INSERT INTO Advisor (advisor_name, advisor_email) VALUES
('Advisor1', 'advisor1@example.com'),
('Advisor2', 'advisor2@example.com');

INSERT INTO Instructor (instructor_name, instructor_email) VALUES
('Instructor1', 'instructor1@example.com'),
('Instructor2', 'instructor2@example.com');

INSERT INTO Course (course_code, course_name, instructor_name) VALUES
('CS101', 'Course 1', 'Instructor1'),
('CS202', 'Course 2', 'Instructor2');

INSERT INTO Student (student_id, student_name, advisor_name) VALUES
(1, 'Student1', 'Advisor1'),
(2, 'Student2', 'Advisor2'),
(3, 'Student3', 'Advisor1');

INSERT INTO Enrollment (student_id, course_code, marks_obtained) VALUES
(1, 'CS101', 80),
(2, 'CS101', 70),
(3, 'CS202', 90);

-- Update instructor email
UPDATE Instructor
SET instructor_email = 'new_email@example.com'
WHERE instructor_name = 'Instructor1';

-- Delete enrollments with low marks
DELETE FROM Enrollment
WHERE marks_obtained < 35;

-- Delete all enrollments
DELETE FROM Enrollment;
-- DELETE is safer for transaction-controlled bulk removal

-- a. Retrieve students enrolled in specific courses
SELECT S.student_name, C.course_name
FROM Student S
JOIN Enrollment E ON S.student_id = E.student_id
JOIN Course C ON E.course_code = C.course_code
WHERE C.course_code IN ('CS101', 'CS202', 'CS303');

-- b. Retrieve students with marks between 60 and 85
SELECT S.student_name
FROM Student S
JOIN Enrollment E ON S.student_id = E.student_id
WHERE E.marks_obtained BETWEEN 60 AND 85
AND S.advisor_name IS NOT NULL;

-- c. Compute average marks per department
SELECT S.advisor_name, AVG(E.marks_obtained) AS avg_marks
FROM Student S
JOIN Enrollment E ON S.student_id = E.student_id
GROUP BY S.advisor_name
HAVING AVG(E.marks_obtained) > 55;

-- d. Retrieve student names, course names, and marks
SELECT S.student_name, C.course_name, E.marks_obtained
FROM Student S
JOIN Enrollment E ON S.student_id = E.student_id
JOIN Course C ON E.course_code = C.course_code;

-- Left join to include students with no courses
SELECT S.student_name, C.course_name, E.marks_obtained
FROM Student S
LEFT JOIN Enrollment E ON S.student_id = E.student_id
LEFT JOIN Course C ON E.course_code = C.course_code;

-- e. Correlated subquery for students scoring above department average
SELECT S.student_name, E.marks_obtained
FROM Student S
JOIN Enrollment E ON S.student_id = E.student_id
WHERE E.marks_obtained > (
    SELECT AVG(E2.marks_obtained)
    FROM Enrollment E2
    JOIN Student S2 ON E2.student_id = S2.student_id
    WHERE S2.advisor_name = S.advisor_name
);

-- f. Students in 2024 but not 2025
SELECT student_id
FROM Enrollment
WHERE enrollment_year = 2024
EXCEPT
SELECT student_id
FROM Enrollment
WHERE enrollment_year = 2025;

-- g. Second-highest scorer per department
SELECT S.advisor_name, S.student_name, E.marks_obtained
FROM Student S
JOIN Enrollment E ON S.student_id = E.student_id
WHERE E.marks_obtained = (
    SELECT MAX(E2.marks_obtained)
    FROM Enrollment E2
    JOIN Student S2 ON E2.student_id = S2.student_id
    WHERE S2.advisor_name = S.advisor_name
    AND E2.marks_obtained < (
        SELECT MAX(E3.marks_obtained)
        FROM Enrollment E3
        JOIN Student S3 ON E3.student_id = S3.student_id
        WHERE S3.advisor_name = S.advisor_name
    )
);

-- h. Window functions for ranking
SELECT S.student_name, E.marks_obtained,
    ROW_NUMBER() (PARTITION BY S.advisor_name ORDER BY E.marks_obtained DESC) AS row_num,
    RANK() OVER (PARTITION BY S.advisor_name ORDER BY E.marks_obtained DESC) AS rank,
    DENSE_RANK() OVER (PARTITION BY S.advisor_name ORDER BY E.marks_obtained DESC) AS dense_rank
FROM Student S
JOIN Enrollment E ON S.student_id = E.student_id;

-- Transaction to transfer student
BEGIN;
DELETE FROM Enrollment WHERE student_id = 1 AND course_code = 'CS101';
INSERT INTO Enrollment (student_id, course_code) VALUES (1, 'CS404');
IF @@ERROR <> 0 ROLLBACK; ELSE COMMIT;

-- Concurrency anomaly: Non-repeatable read
-- Isolation level: REPEATABLE READ

-- Concurrency anomaly: Lost update
-- Isolation level: SERIALIZABLE

-- MVCC read behaviour
-- Reporting transaction sees original value (snapshot isolation)
-- Isolation level: SERIALIZABLE
-- Trade-off: Higher isolation level may lead to more locking and reduced concurrency
