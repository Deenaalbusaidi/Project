CREATE DATABASE TRAINING
USE TRAINING 

CREATE TABLE TRAINEE (
trainee_id INT PRIMARY KEY,
name VARCHAR (20) NOT NULL,
gender VARCHAR (20),
email VARCHAR (50),
background VARCHAR (50),
);

INSERT INTO TRAINEE VALUES 
(1, 'Aisha Al-Harthy', 'Female', 'aisha@example.com', 'Engineering'), 
(2, 'Sultan Al-Farsi', 'Male', 'sultan@example.com ', 'Business'), 
(3, 'Mariam Al-Saadi', 'Female', 'mariam@example.com', 'Marketing'), 
(4, 'Omar Al-Balushi', 'Male', 'omar@example.com ', 'Computer Science'),
(5, 'Fatma Al-Hinai', 'Female', 'fatma@example.com ', 'Data Science');
SELECT * FROM TRAINEE

-------------------------------------------------------------------------------

CREATE TABLE TRAINER (
 trainer_id INT PRIMARY KEY,
 trainer_name VARCHAR (30) NOT NULL,
 specialty VARCHAR (40),
 phone VARCHAR (40),
 email VARCHAR (50)
);

INSERT INTO TRAINER VALUES 
(1, 'Khalid Al-Maawali', 'Databases', 96891234567, 'khalid@example.com'), 
(2, 'Noura Al-Kindi', 'Web Development', 96892345678, 'noura@example.com'), 
(3, 'Salim Al-Harthy', 'Data Science', 96893456789, 'salim@example.com');
SELECT * FROM TRAINER

-------------------------------------------------------------------------------

CREATE TABLE COURSE (
 course_id INT PRIMARY KEY,
 title VARCHAR (30) NOT NULL,
 category VARCHAR (40),
 duration_hours VARCHAR (40),
 course_level VARCHAR (50)
);

INSERT INTO COURSE VALUES 
(1, 'Database Fundamentals', 'Databases', 20, 'Beginner'), 
(2, 'Web Development Basics', 'Web', 30, 'Beginner'), 
(3, 'Data Science Introduction', 'Data Science', 25, 'Intermediate'),
(4, 'Advanced SQL Queries', 'Databases', 15, 'Advanced');

INSERT INTO COURSE VALUES
(5, 'AI Fundamentals', 'AI', 10, 'Beginner');
SELECT * FROM COURSE

-------------------------------------------------------------------------------

CREATE TABLE SCHEDULE (
 schedule_id INT PRIMARY KEY,
 C_ID INT,
 T_ID INT,
 FOREIGN KEY (C_ID) REFERENCES COURSE (course_id),
 FOREIGN KEY (T_ID) REFERENCES TRAINER (trainer_id),
 start_date DATE,
 end_date DATE,
 time_slot  VARCHAR (50),
);

INSERT INTO SCHEDULE VALUES 
(1, 1, 1, '2025-07-01', '2025-07-10', 'Morning'), 
(2, 2, 2, '2025-07-05', '2025-07-20', 'Evening'), 
(3, 3, 3, '2025-07-10', '2025-07-25', 'Weekend'),
(4, 4, 1, '2025-07-15', '2025-07-22', 'Morning');

INSERT INTO SCHEDULE VALUES 
(5, 5, 3, '2025-07-20', '2025-07-30', 'Evening');
SELECT * FROM SCHEDULE

--------------------------------------------------------------------------------

CREATE TABLE ENROLLMENT (
 enrollment_id INT PRIMARY KEY,
 TR_ID INT,
 CR_ID INT,
 FOREIGN KEY (TR_ID) REFERENCES TRAINEE (trainee_id),
 FOREIGN KEY (CR_ID) REFERENCES COURSE (course_id),
 enrollment_date DATE,
);

INSERT INTO ENROLLMENT VALUES 
(1, 1, 1, '2025-06-01'), 
(2, 2, 1, '2025-06-02'), 
(3, 3, 2, '2025-06-03'),
(4, 4, 3, '2025-06-04'),
(5, 5, 3, '2025-06-05'),
(6, 1, 4, '2025-06-06');
SELECT * FROM ENROLLMENT


--------------------------------------------------------------------------------
--CHALLENGES (Trainee Perspective)
--(1. Show all available courses (title, level, category))
SELECT title, category, course_level
FROM COURSE


--(2. View beginner-level Data Science courses)
SELECT * FROM COURSE
WHERE course_level = 'Beginner'
AND category = 'Data Science';


--(3. Show courses this trainee is enrolled in)
SELECT COURSE.title
FROM COURSE
JOIN ENROLLMENT
ON COURSE.course_id = ENROLLMENT.CR_ID
WHERE ENROLLMENT.TR_ID = 3;


--(4. View the schedule (start_date, time_slot) for the trainee's enrolled courses)
SELECT COURSE.title, SCHEDULE.start_date, SCHEDULE.time_slot
FROM ENROLLMENT
JOIN COURSE ON ENROLLMENT.CR_ID = COURSE.course_id
JOIN SCHEDULE ON SCHEDULE.C_ID = COURSE.course_id
WHERE ENROLLMENT.TR_ID = 3;


--(5. Count how many courses the trainee is enrolled in)
SELECT COUNT (CR_ID) AS Total_Courses
FROM ENROLLMENT
WHERE TR_ID = 3;


--(6. Show course titles, trainer names, and time slots the trainee is attending)
SELECT COURSE.title, TRAINER.trainer_name, SCHEDULE.time_slot
FROM ENROLLMENT
JOIN COURSE ON ENROLLMENT.CR_ID = COURSE.course_id
JOIN SCHEDULE ON SCHEDULE.C_ID = COURSE.course_id
JOIN TRAINER ON SCHEDULE.T_ID = TRAINER.trainer_id
WHERE ENROLLMENT.TR_ID = 3;

-------------------------------------------------------------------------------------
--CHALLENGES (Trainer Perspective)
--(1. List all courses the trainer is assigned to)
SELECT COURSE.title
FROM COURSE
JOIN SCHEDULE
ON COURSE.course_id = SCHEDULE.C_ID
WHERE SCHEDULE.T_ID = 1;


--(2. Show upcoming sessions (with dates and time slots))
SELECT SCHEDULE.start_date, SCHEDULE.end_date, SCHEDULE.time_slot
FROM SCHEDULE
WHERE SCHEDULE.T_ID = 1
AND start_date >= CAST (GETDATE() AS DATE);


--(3. See how many trainees are enrolled in each of your courses)
SELECT COURSE.title, COUNT(ENROLLMENT.TR_ID) AS trainee_count
FROM SCHEDULE
JOIN COURSE ON SCHEDULE.C_ID = COURSE.course_id
JOIN ENROLLMENT ON COURSE.course_id = ENROLLMENT.CR_ID
WHERE SCHEDULE.T_ID = 1
GROUP BY COURSE.title;


--(4. List names and emails of trainees in each of your courses)
SELECT TRAINEE.name, TRAINEE.email
FROM ENROLLMENT
JOIN TRAINEE ON ENROLLMENT.TR_ID = TRAINEE.trainee_id
JOIN COURSE ON ENROLLMENT.CR_ID = COURSE.course_id
join SCHEDULE ON COURSE.course_id = SCHEDULE.C_ID
WHERE SCHEDULE.T_ID = 1;


--(5. Show the trainer's contact info and assigned courses)
SELECT TRAINER.trainer_name, TRAINER.phone, TRAINER.email, COURSE.title AS course_title
FROM TRAINER 
JOIN SCHEDULE ON TRAINER.trainer_id = SCHEDULE.T_ID
JOIN COURSE ON SCHEDULE.C_ID = COURSE.course_id
ORDER BY TRAINER.trainer_name, COURSE.title;


--(6. Count the number of courses the trainer teaches)
SELECT T_ID AS trainer_id, COUNT(C_ID) AS courses_count
FROM SCHEDULE
GROUP BY T_ID;

-------------------------------------------------------------------------------------
--CHALLENGES (Admin Perspective)
--(1. Add a new course (INSERT statement))
--INSERTED ABOVE
--INSERT INTO COURSE VALUES
--(5, 'AI Fundamentals', 'AI', 10, 'Beginner');


--(2. Create a new schedule for a trainer)
--INSERTED ABOVE
--INSERT INTO SCHEDULE VALUES 
--(5, 5, 3, '2025-07-20', '2025-07-30', 'Evening');


--(3. View all trainee enrollments with course title and schedule info)
SELECT TRAINEE.name AS trainee_name, COURSE.title AS course_title, SCHEDULE.start_date, SCHEDULE.end_date, SCHEDULE.time_slot
FROM ENROLLMENT
JOIN TRAINEE ON ENROLLMENT.TR_ID = TRAINEE.trainee_id
JOIN COURSE ON ENROLLMENT.CR_ID = COURSE.course_id
JOIN SCHEDULE ON COURSE.course_id = SCHEDULE.C_ID;


--(4. Show how many courses each trainer is assigned to)
SELECT T_ID, COUNT(*) AS total_courses
FROM SCHEDULE
GROUP BY T_ID;

--(5. List all trainees enrolled in "Data Basics")
SELECT TRAINEE.name, TRAINEE.email
FROM TRAINEE
JOIN ENROLLMENT ON ENROLLMENT.TR_ID = TRAINEE.trainee_id
JOIN COURSE ON ENROLLMENT.CR_ID = COURSE.course_id
WHERE COURSE.title = 'Database Fundamentals';
-- There is no course titled 'Data Basics' and I have used 'Database Fundamentals' to show data in the table.


--(6. Identify the course with the highest number of enrollments)
SELECT TOP 1 CR_ID, COUNT(*) AS total_enrollments
FROM ENROLLMENT
GROUP BY CR_ID
ORDER BY total_enrollments DESC;


--(7. Display all schedules sorted by start date)
SELECT *
FROM SCHEDULE
ORDER BY start_date ASC;