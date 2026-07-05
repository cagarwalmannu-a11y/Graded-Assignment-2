CREATE TABLE Advisor (
    advisor_name VARCHAR(50) PRIMARY KEY,
    advisor_email VARCHAR(100)
);

CREATE TABLE Instructor (
    instructor_name VARCHAR(50) PRIMARY KEY,
    instructor_email VARCHAR(100)
);

CREATE TABLE Course (
    course_code VARCHAR(10) PRIMARY KEY,
    course_name VARCHAR(50),
    instructor_name VARCHAR(50),
    FOREIGN KEY (instructor_name) REFERENCES Instructor(instructor_name)
);

CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    advisor_name VARCHAR(50),
    FOREIGN KEY (advisor_name) REFERENCES Advisor(advisor_name)
);

CREATE TABLE Enrollment (
    student_id INT,
    course_code VARCHAR(10),
    enrollment_year INT DEFAULT EXTRACT(YEAR FROM CURRENT_DATE),
    marks_obtained DECIMAL(4,2),
    PRIMARY KEY (student_id, course_code),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_code) REFERENCES Course(course_code)
);
