# School Management System Database - Testing Project

This repository contains a **testing project** for a School Management System database.  
It includes **complete table creation, relationships, sample data insertion**, and queries for testing purposes. The project focuses on the **database layer only**, intended for learning, testing, or later integration with application logic.

---

## What This Project Contains

- **Database Creation:** `SchoolManagement` database created with all required tables.  
- **Tables Included:**  
  `subjects`, `teachers`, `guardians`, `classes`, `class_subjects`, `students`, `enrollments`, `attendance`, `exams`, `grades`, `fees`.  
- **Relationships & Constraints:**  
  - Foreign keys maintain integrity between students, classes, and guardians.  
  - Teachers linked to subjects.  
  - Grades linked to students, subjects, and exams.  
  - Attendance linked to students and recorded by teachers.  
  - Primary keys and unique constraints ensure consistency.  
- **Sample Data:** Pre-filled subjects, teachers, students, guardians, classes, enrollments, attendance, exams, grades, and fees.  

---

## What I Did in This Project

1. **Created database and tables** for a full school management system.  
2. **Defined relationships** using foreign keys for data integrity.  
3. **Inserted sample data** for all entities to enable testing and queries.  
4. **Prepared queries** for testing and reporting:
   - Verify tables and sample data
   - Check students with invalid classes or guardians
   - Attendance summary per student
   - Fee dues and total payments
   - Grades per exam per student
   - Students per class count
   - Average marks per subject
   - Class-subject mapping  

---

## How to Test / Verify

Run the following SQL commands after loading the script:

```sql
SHOW TABLES;
SELECT * FROM students LIMIT 5;


-- Check students with invalid class
SELECT * FROM students s
LEFT JOIN classes c ON s.class_id = c.class_id
WHERE c.class_id IS NULL;

-- Check students with invalid guardian
SELECT * FROM students s
LEFT JOIN guardians g ON s.guardian_id = g.guardian_id
WHERE g.guardian_id IS NULL;


SELECT * FROM grades WHERE marks_obtained > max_marks;


SELECT c.class_name, COUNT(s.student_id) AS total_students
FROM classes c
LEFT JOIN students s ON c.class_id = s.class_id
GROUP BY c.class_name;


SELECT s.first_name, s.last_name,
       SUM(CASE WHEN a.status='present' THEN 1 ELSE 0 END) AS present_days,
       SUM(CASE WHEN a.status='absent' THEN 1 ELSE 0 END) AS absent_days,
       SUM(CASE WHEN a.status='leave' THEN 1 ELSE 0 END) AS leave_days
FROM students s
LEFT JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id;

SELECT s.first_name, s.last_name, f.term, f.due_amount
FROM students s
JOIN fees f ON s.student_id = f.student_id
WHERE f.due_amount > 0;

SELECT s.first_name, s.last_name, f.term, f.due_amount
FROM students s
JOIN fees f ON s.student_id = f.student_id
WHERE f.due_amount > 0;


SELECT s.first_name, s.last_name, SUM(f.paid_amount) AS total_paid
FROM students s
JOIN fees f ON s.student_id = f.student_id
GROUP BY s.student_id;

SELECT s.first_name, s.last_name, sub.subject_name, g.marks_obtained, g.max_marks, g.grade
FROM grades g
JOIN students s ON g.student_id = s.student_id
JOIN subjects sub ON g.subject_id = sub.subject_id
JOIN exams e ON g.exam_id = e.exam_id
WHERE e.exam_name='Midterm Exam' AND e.class_id=1;


SELECT sub.subject_name, AVG(g.marks_obtained) AS avg_marks
FROM grades g
JOIN subjects sub ON g.subject_id = sub.subject_id
GROUP BY sub.subject_name;


SELECT e.student_id, s.first_name, COUNT(a.attendance_id) AS attendance_records
FROM enrollments e
LEFT JOIN attendance a ON e.student_id = a.student_id
JOIN students s ON e.student_id = s.student_id
GROUP BY e.student_id;


SELECT c.class_name, sub.subject_name
FROM class_subjects cs
JOIN classes c ON cs.class_id=c.class_id
JOIN subjects sub ON cs.subject_id=sub.subject_id
ORDER BY c.class_name;




