-- =====================================================
-- SCHOOL MANAGEMENT SYSTEM DATABASE
-- Complete Table Creation + Sample Data Insertion
-- =====================================================

-- 1. CREATE DATABASE
CREATE DATABASE IF NOT EXISTS SchoolManagement;
USE SchoolManagement;

-- =====================================================
-- 2. SUBJECTS TABLE
-- Store all subjects offered in school
-- =====================================================
CREATE TABLE subjects (
    subject_id INT AUTO_INCREMENT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL,
    subject_code VARCHAR(20) UNIQUE
);

-- Sample subjects
INSERT INTO subjects (subject_name, subject_code) VALUES
('Mathematics', 'MATH101'),
('English', 'ENG102'),
('Science', 'SCI103'),
('History', 'HIS104'),
('Computer Science', 'CS105');

-- =====================================================
-- 3. TEACHERS TABLE
-- Each teacher may teach a subject (subject_id FK)
-- =====================================================
CREATE TABLE teachers (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    hire_date DATE,
    subject_id INT,
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

-- Sample teachers
INSERT INTO teachers (name, email, phone, hire_date, subject_id) VALUES
('Abdul Karim', 'akarim@school.com', '01711111111', '2021-02-10', 1),
('Laila Rahman', 'lrahman@school.com', '01722222222', '2020-09-15', 2),
('Tariq Hasan', 'thasan@school.com', '01733333333', '2019-01-20', 3),
('Sadia Akter', 'sakter@school.com', '01744444444', '2022-05-05', 4),
('Mehedi Hasan', 'mhasan@school.com', '01755555555', '2023-03-11', 5);

-- =====================================================
-- 4. GUARDIANS TABLE
-- Store parent/guardian info of students
-- =====================================================
CREATE TABLE guardians (
    guardian_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    relation VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(255)
);

-- Sample guardians
INSERT INTO guardians (name, relation, phone, email, address) VALUES
('Rahim Uddin', 'Father', '01811111111', 'rahim@gmail.com', 'Dhaka'),
('Karim Mia', 'Father', '01822222222', 'karim@gmail.com', 'Chittagong'),
('Selina Begum', 'Mother', '01833333333', 'selina@gmail.com', 'Khulna');

-- =====================================================
-- 5. CLASSES TABLE
-- Each class has a teacher in charge (FK → teachers)
-- =====================================================
CREATE TABLE classes (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(100) NOT NULL,
    section VARCHAR(20),
    teacher_incharge INT,
    FOREIGN KEY (teacher_incharge) REFERENCES teachers(teacher_id)
);

-- Sample classes
INSERT INTO classes (class_name, section, teacher_incharge) VALUES
('Grade 8 - A', 'A', 1),
('Grade 9 - B', 'B', 2),
('Grade 10 - A', 'A', 3);

-- =====================================================
-- 6. CLASS_SUBJECTS TABLE
-- Many-to-many mapping: which subjects are in which class
-- =====================================================
CREATE TABLE class_subjects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    class_id INT,
    subject_id INT,
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

-- Sample class-subject mapping
INSERT INTO class_subjects (class_id, subject_id) VALUES
(1, 1), (1, 2), (1, 3),
(2, 1), (2, 2), (2, 3), (2, 4),
(3, 1), (3, 2), (3, 3), (3, 4), (3, 5);

-- =====================================================
-- 7. STUDENTS TABLE
-- Student info including class and guardian
-- =====================================================
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    dob DATE,
    gender ENUM('Male', 'Female', 'Other'),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    admission_date DATE DEFAULT (CURRENT_DATE),
    class_id INT,
    guardian_id INT,
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (guardian_id) REFERENCES guardians(guardian_id)
);

-- Sample students
INSERT INTO students (first_name, last_name, dob, gender, email, phone, admission_date, class_id, guardian_id) VALUES
('Hasan', 'Ali', '2010-04-05', 'Male', 'hasan@student.com', '01911111111', '2023-01-10', 1, 1),
('Mitu', 'Rahman', '2009-11-20', 'Female', 'mitu@student.com', '01922222222', '2023-01-12', 2, 2),
('Rafi', 'Hossain', '2008-06-15', 'Male', 'rafi@student.com', '01933333333', '2023-01-14', 3, 3);

-- =====================================================
-- 8. ENROLLMENTS TABLE
-- Track which students enrolled in which class & status
-- =====================================================
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    class_id INT,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    status ENUM('active', 'inactive') DEFAULT 'active',
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

INSERT INTO enrollments (student_id, class_id, enrollment_date, status) VALUES
(1, 1, '2023-01-10', 'active'),
(2, 2, '2023-01-12', 'active'),
(3, 3, '2023-01-14', 'active');

-- =====================================================
-- 9. ATTENDANCE TABLE
-- Track daily attendance of students
-- =====================================================
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    date DATE,
    status ENUM('present', 'absent', 'leave'),
    recorded_by INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (recorded_by) REFERENCES teachers(teacher_id)
);

INSERT INTO attendance (student_id, date, status, recorded_by) VALUES
(1, '2024-01-10', 'present', 1),
(1, '2024-01-11', 'absent', 1),
(2, '2024-01-10', 'present', 2),
(3, '2024-01-10', 'leave', 3);

-- =====================================================
-- 10. EXAMS TABLE
-- Exams for each class
-- =====================================================
CREATE TABLE exams (
    exam_id INT AUTO_INCREMENT PRIMARY KEY,
    exam_name VARCHAR(100),
    class_id INT,
    exam_date DATE,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

INSERT INTO exams (exam_name, class_id, exam_date) VALUES
('Midterm Exam', 1, '2024-03-01'),
('Final Exam', 1, '2024-06-01'),
('Midterm Exam', 2, '2024-03-02'),
('Final Exam', 3, '2024-06-05');

-- =====================================================
-- 11. GRADES TABLE
-- Store marks & grades per student per exam & subject
-- =====================================================
CREATE TABLE grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    exam_id INT,
    student_id INT,
    subject_id INT,
    marks_obtained DECIMAL(5,2),
    max_marks DECIMAL(5,2),
    grade CHAR(2),
    FOREIGN KEY (exam_id) REFERENCES exams(exam_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

INSERT INTO grades (exam_id, student_id, subject_id, marks_obtained, max_marks, grade) VALUES
(1, 1, 1, 78, 100, 'B'),
(1, 1, 2, 85, 100, 'A'),
(3, 2, 1, 90, 100, 'A'),
(4, 3, 3, 88, 100, 'A');

-- =====================================================
-- 12. FEES TABLE
-- Track student fee payments
-- =====================================================
CREATE TABLE fees (
    fee_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    term VARCHAR(50),
    amount DECIMAL(10,2),
    paid_amount DECIMAL(10,2),
    due_amount DECIMAL(10,2),
    payment_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

INSERT INTO fees (student_id, term, amount, paid_amount, due_amount, payment_date) VALUES
(1, 'Term 1', 5000, 5000, 0, '2024-01-05'),
(2, 'Term 1', 5000, 3000, 2000, '2024-01-06'),
(3, 'Term 1', 5000, 2500, 2500, '2024-01-07');

