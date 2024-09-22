create database Advising_Team_90
GO 
create PROCEDURE CreateAllTables
AS


CREATE TABLE Advisor (
advisor_id int PRIMARY KEY Identity,
name varchar(40), 
email varchar(40),
office varchar(40), 
password varchar(40)
) 
 

create TABLE Student(
student_id int PRIMARY KEY IDENTITY,
f_name varchar(40),
l_name varchar(40),
gpa decimal,
faculty varchar(40),
email varchar(40),
major varchar(40),
password varchar(40),
financial_status bit,
semester int,
acquired_hours int,
assigned_hours int,
advisor_id int,
FOREIGN KEY (advisor_id) references Advisor(advisor_id)

)
create table Student_Phone (
student_id int,
phone_number varchar(40),
PRIMARY KEY(student_id ,phone_number),
 
FOREIGN KEY (student_id) references Student(student_id) 
)

Create TABLE Course(
course_id int PRIMARY KEY Identity ,
name varchar(40),
major varchar(40),
is_offered bit,
credit_hours int,
semester int
)

create TABLE PreqCourse_course(
prerequisite_course_id int,
course_id int,
PRIMARY KEY(prerequisite_course_id,course_id),
FOREIGN KEY (prerequisite_course_id) references Course(course_id),
FOREIGN KEY (course_id) references Course(course_id)
)

Create TABLE Instructor(
instructor_id int PRIMARY KEY IDENTITY ,
name varchar(40),
email varchar(40), 
faculty varchar(40), 
office varchar(40)
)

Create TABLE Instructor_Course(
course_id int ,
instructor_id int ,
PRIMARY KEY(instructor_id,course_id),
FOREIGN KEY(instructor_id) references Instructor(instructor_id),
FOREIGN KEY(course_id ) references Course(course_id )
)

Create TABLE Student_Instructor_Course_Take(
student_id int ,
course_id int ,
instructor_id int ,
PRIMARY KEY(student_id,course_id,semester_code),
semester_code varchar(40), 
exam_type varchar(40) DEFAULT'Normal',
grade varchar(40) DEFAULT null,
FOREIGN KEY(student_id)  references Student(student_id),
FOREIGN KEY(course_id) references Course(course_id),
FOREIGN KEY(instructor_id) references Instructor(instructor_id)
)


Create TABLE Semester (
semester_code varchar(40) PRIMARY KEY  , 
start_date DATE, 
end_date DATE
) 

CREATE TABLE Course_Semester (
course_id int  , 
semester_code varchar(40),
PRIMARY KEY(course_id,semester_code),
FOREIGN KEY(course_id) references Course(course_id),
FOREIGN KEY(semester_code) references Semester(semester_code)
)


CREATE TABLE Slot (
slot_id int PRIMARY KEY IDENTITY ,
day varchar(40), 
time varchar(40) ,
location varchar(40),
course_id int,
instructor_id int,
FOREIGN KEY(course_id) references Course(course_id), 
FOREIGN KEY(instructor_id) references Instructor(instructor_id)
)

create table Graduation_Plan(
 plan_id int IDENTITY  ,
 semester_code varchar(40) ,
semester_credit_hours int,
expected_grad_date  date,
 PRIMARY KEY(plan_id,semester_code),
 advisor_id int,
 student_id int,
FOREIGN KEY (advisor_id) references Advisor(advisor_id),
FOREIGN KEY (student_id) references Student(student_id)
)

CREATE TABLE GradPlan_Course (
    plan_id INT,
    semester_code VARCHAR(40),
    course_id int,
    PRIMARY KEY (plan_id, semester_code, course_id),
    FOREIGN KEY (plan_id, semester_code) REFERENCES Graduation_Plan(plan_id, semester_code)
)

Create table Request(
request_id int PRIMARY KEY IDENTITY,
type varchar(40),
comment varchar(40),
status varchar(40) DEFAULT 'pending',
credit_hours int,
student_id int,
advisor_id int,
FOREIGN KEY (student_id) references Student(student_id),
FOREIGN KEY (advisor_id) references Advisor(advisor_id),
course_id int
FOREIGN KEY(course_id) references course(course_id)
)

CREATE TABLE MakeUp_Exam (
exam_id int PRIMARY KEY IDENTITY , 
date DATETIME, 
type varchar(40) , 
course_id int,
FOREIGN KEY(course_id) references Course(course_id)
) 


CREATE TABLE Exam_Student (
exam_id int ,
student_id int  ,
 PRIMARY KEY(exam_id,student_id),
course_id int,
FOREIGN KEY(exam_id) references MakeUp_Exam(exam_id),
FOREIGN KEY(student_id) references Student(student_id)
)

create table Payment(
payment_id INT PRIMARY KEY Identity,
amount int,
deadline DATETIME,
n_installments INT, 
status varchar(40) DEFAULT 'NotPaid',
fund_percentage decimal,
start_date datetime,
student_id int,
FOREIGN KEY(student_id) references Student(student_id),
semester_code varchar(40),
FOREIGN KEY(semester_code) references Semester(semester_code),
)

create table Installment(
payment_id int,
deadline datetime,
 PRIMARY KEY(payment_id,deadline),
amount int,
status varchar(40),
start_date datetime,
FOREIGN KEY (payment_id) references Payment(payment_id)
)
GO



GO
create PROCEDURE DropAllTables
AS
drop table Request;
drop table Exam_Student;
drop table GradPlan_Course;
drop table Course_Semester; 
drop table Graduation_Plan; 
drop table MakeUp_Exam; 
drop table Instructor_Course; 
drop table PreqCourse_course;
drop table slot;
drop table Student_Instructor_Course_Take;
drop table Student_Phone;
drop table Installment; 
drop table Payment; 
drop table Semester;
drop table Student;
drop table Instructor;
drop table Advisor;
drop table Course;
GO



GO
create PROCEDURE ClearAllTables
AS
Truncate table Request;
Truncate table Exam_Student;
Truncate table GradPlan_Course;
Truncate table Course_Semester; 
Truncate table Instructor_Course; 
Truncate table PreqCourse_course;
Truncate table slot;
Truncate table Student_Instructor_Course_Take;
Truncate table Student_Phone;
Truncate table Installment; 
DELETE FROM Graduation_Plan; 
DELETE FROM MakeUp_Exam; 
DELETE FROM Course;
DELETE FROM Payment; 
DELETE FROM  Semester;
DELETE FROM  Student;
DELETE FROM  Instructor;
DELETE FROM  Advisor;
GO



--2.3

--A
GO
CREATE VIEW view_Students as
select *
from Student 
WHERE financial_status=1;
GO


--B
GO
create VIEW view_Course_prerequisites as
select 
c.course_id as courseID,
c.name as course_name,
c.major as course_major,
c.is_offered as course_is_offered,
c.credit_hours as course_credithours,
c.semester as course_semester,
p.prerequisite_course_id as prerequisite_courseID,
p.course_id as prerequisite_course_ID
from Course c
Left outer Join PreqCourse_course p
On c.course_id = p.course_id;
GO

--C
GO
create VIEW  Instructors_AssignedCourses as
select 
i.instructor_id as InstructorID,
i.name AS instructorname,
i.email as iemail, 
i.faculty as ifaculty, 
i.office as ioffice,
ic.instructor_id as icinstructorid,
ic.course_id AS iccourseid,
c.course_id AS courseid,
c.name AS coursename,
c.major as cmajor,
c.is_offered as coffered,
c.credit_hours as ccredithours,
c.semester as csemester
from Instructor i
Left outer Join Instructor_Course ic
ON i.instructor_id = ic.instructor_id
Inner Join Course c
ON ic.course_id = c.course_id
GO

--D
GO
CREATE VIEW Student_Payment as
select 
p.payment_id AS PaymentID,
p.amount AS p_amount,
p.deadline AS p_deadline,
p.n_installments AS p_noOfInstallment ,
p.status AS p_status,
p.fund_percentage AS p_percentage ,
p.student_id AS p_studentid,
p.semester_code AS p_semCode,
p.start_date AS p_SDate,
s.student_id  AS s_studentID,
s.f_name AS s_firstname,
s.l_name AS s_lastname,
s.financial_status AS s_status
from Payment p
Left Outer Join Student s
ON p.student_id = s.student_id
GO

--E
GO
CREATE VIEW Courses_Slots_Instructor as
select 
c.course_id as c_course_id,
c.name as c_name,
s.slot_id as s_slot_id,
s.day as s_day,
s.time as s_time,
s.location as s_location,
i.name as i_name
FROM Course c
left outer join Slot s
ON c.course_id = s.course_id
inner join Instructor i
On i.instructor_id = s.instructor_id
GO

--F
GO
CREATE View Courses_MakeupExams AS 
Select C.name AS 'Course’s name',
C.semester AS 'Course’s semester' ,
M.exam_id as m_exam_id,
M.date as m_id,
M.type as m_type,
M.course_id as m_course_id
FROM Course C 
left outer join MakeUp_Exam M
ON C.course_id = M.course_id
GO

--G
GO
CREATE View Students_Courses_transcript AS
Select S.student_id AS 'Student id',
S.f_name+' '+ S.l_name  AS 'student name',
C.course_id AS 'course id',
C.name AS 'course name' ,
sic.exam_type AS 'exam type' , 
sic.grade AS 'course grade' , 
sic.semester_code as c_semester , 
sic.instructor_id AS 'Instructor’s name'
FROM Student S 
     Left Outer Join Student_Instructor_Course_Take sic
     ON s.student_id = sic.student_id
     inner join Course c
     ON sic.course_id = c.course_id
GO

--H
GO 
CREATE View Semster_offered_Courses AS 
Select
C.course_id AS 'Course id',
C.name AS 'Course name' ,
CS.semester_code AS 'Semester code'
FROM Semester s 
Left outer join Course_Semester CS
ON s.semester_code = cs.semester_code
inner join Course c
ON cs.course_id = c.course_id
GO

--I
GO
CREATE VIEW  Advisors_Graduation_Plan as
select 
g.plan_id as g_plan_id,
g.semester_code as g_semester_code,
g.semester_credit_hours as g_semester_credit_hours,
g.expected_grad_date  as g_expected_grad_date,
g.student_id as g_student_id,
a.advisor_id as 'Advisor id',
a.name as 'Advisor name'
from Graduation_Plan g
Left outer Join Advisor a
ON g.advisor_id=a.advisor_id;
GO


--Derived_Financial_Status
GO
Create function [Deriving_FS]
(@student_id int)
returns bit
As
Begin
declare @bit bit
select @payId = p.payment_id
from Payment p
where @StudentID =p.student_id

  DECLARE @NotPaidCount INT;

SELECT @NotPaidCount = COUNT(*)
FROM Installment i1
WHERE i1.payment_id = @payId
  AND CURRENT_TIMESTAMP > i1.deadline
  AND i1.status = 'NotPaid';

IF @NotPaidCount > 0
   
   Set @bit=0

ELSE
begin
   set @bit=1

    end
    return @bit
    end
    Go



--2.3

--A
GO 
CREATE PROC Procedures_StudentRegistration

@f_name varchar(40),
@l_name varchar(40),
@faculty varchar(40),
@email varchar(40),
@major varchar (40),
@semester int,
@id int OUTPUT

As
Begin
  
INSERT INTO Student (f_name, l_name, faculty, email, major, semester)
   
    VALUES (@f_name, @l_name, @faculty, @email, @major, @semester);
    set @id=scope_identity()
    print (scope_identity()) ;

end;
GO

--B
GO 
CREATE PROC Procedures_AdvisorRegistration

@name varchar(40),
@password varchar(40),
@email varchar(40),
@office varchar (40),
@id int OUTPUT


As
Begin
INSERT INTO Advisor(name, password, email, office)
   
    VALUES (@name ,@password ,@email ,@office );
    set @id=scope_identity()

    print (scope_identity()) ;

end;
GO

--C
GO
CREATE PROC  Procedures_AdminListStudents
As
Select *
From Student s
GO

--D 
GO
CREATE PROC Procedures_AdminListAdvisors
As
Select *
From  Advisor a
GO

--E
GO
CREATE PROC  AdminListStudentsWithAdvisors
As

Select *
From Student s, Advisor a
where s.advisor_id=a.advisor_id
GO

--F

GO
Create PROC AdminAddingSemester
@start_date date,
@end_date date, 
@semester_code varchar(40)
As
Begin
INSERT INTO Semester(semester_code, start_date, end_date)
   
    VALUES (@semester_code, @start_date, @end_date);
end;
GO

--G

GO
Create PROC Procedures_AdminAddingCourse
@major varchar (40), 
@semester int, 
@credit_hours int, 
@course_name varchar (40),
@offered bit
As
Begin
INSERT INTO Course(major ,semester,credit_hours ,name ,is_offered)
   
    VALUES (@major ,@semester,@credit_hours ,@course_name ,@offered);
end;
GO

--H
GO
Create PROC Procedures_AdminLinkInstructor
@InstructorId int, 
@courseId int, 
@slotID int
As
Begin
if not exists(
select *
From Instructor_Course ic
where ic.instructor_id = @InstructorId
AND ic.course_id = @courseId
)
begin
insert into Instructor_Course(instructor_id,course_id)
values (@InstructorId, @courseId)

   UPDATE Slot
    SET  instructor_id = @InstructorId,
    Course_id=@CourseId
    WHERE slot_id = @slotID

end
end;
GO

--I
GO
Create PROC Procedures_AdminLinkStudent
@InstructorId int, 
@studentID int,
@courseId int, 
@semestercode varchar(40)
As
BEGIN
insert into Student_Instructor_Course_Take(instructor_id,student_id,course_id,semester_code)
VALUES(@InstructorId,@studentID,@courseId,@semestercode)
end;
GO

--J

GO
Create PROC Procedures_AdminLinkStudentToAdvisor
@studentID int,
@AdvisorID int
As
Begin
    UPDATE Student
    SET advisor_id=@AdvisorID
    where student_id=@studentID
end;
GO

--K

GO
Create PROC Procedures_AdminAddExam
@type varchar(40),
@date datetime,
@courseID int
As
Begin


     INSERT INTO MakeUp_Exam(type, date ,course_id)
     VALUES (@type, @date ,@courseID);
end;
GO

--L

GO
Create PROC Procedures_AdminIssueInstallment
@paymentID int
As
Begin
   DECLARE @Amount DECIMAL, @Deadline DATE, @StartDate DATE, @MonthsDifference INT,@count int,
   @pStart_date DATE
   SELECT
            @Amount = amount,
            @Deadline = deadline,
            @StartDate = start_date
            
   FROM Payment p
   WHERE payment_id = @paymentID;
   SET @MonthsDifference = DATEDIFF(MONTH, @StartDate, @Deadline);

   update Payment  
   set n_installments=@MonthsDifference
   where payment_id=@paymentID
   set @count = @MonthsDifference
   if @MonthsDifference>0
   WHILE @count > 0
   BEGIN

   insert into Installment (payment_id,deadline, amount,start_date,status) 
   values(@paymentID,DATEADD(MONTH, 1, @StartDate) ,@amount/@MonthsDifference,@StartDate,'NotPaid')
  set @count =@count -1
  set @StartDate= DATEADD(MONTH, 1,@StartDate)
  end;
end;
GO

--M

GO
Create PROC Procedures_AdminDeleteCourse
@courseID int
As
Begin
Delete from slot 
where Slot.course_id=@courseID
delete from Course_Semester
where Course_Semester.course_id=@courseID
delete from Instructor_Course
where Instructor_Course.course_id=@courseID
delete from Student_Instructor_Course_Take
where Student_Instructor_Course_Take.course_id=@courseID
delete from GradPlan_Course 
where GradPlan_Course.course_id= @courseID
delete from Exam_Student
where Exam_Student.course_id=@courseID
delete from MakeUp_Exam
where MakeUp_Exam.course_id=@courseID
Delete from Request
where Request.course_id=@courseID
delete from PreqCourse_course
WHERE course_id = @courseID OR prerequisite_course_id = @courseID;
delete from  Course 
where course_id=@courseID
  
end;
GO


--N

GO
create PROC Procedure_AdminUpdateStudentStatus
@StudentID int
AS
Begin
declare @stat varchar(40),@payId int,@i_deadline date

select @payId = p.payment_id
from Payment p
where @StudentID =p.student_id

  DECLARE @NotPaidCount INT;

SELECT @NotPaidCount = COUNT(*)
FROM Installment i1
WHERE i1.payment_id = @payId
  AND CURRENT_TIMESTAMP > i1.deadline
  AND i1.status = 'NotPaid';

IF @NotPaidCount > 0
    UPDATE Student
    SET financial_status = 0
    WHERE student_id = @StudentID;

ELSE
    UPDATE Student
    SET financial_status = 1
    WHERE student_id = @StudentID
end;
GO

--O

GO 
Create View all_Pending_Requests
AS
select  r.request_id, r.type, r.comment, r.status, r.credit_hours,r.student_id, 
r.advisor_id,r.course_id  ,s.f_name+' '+s.l_name as StudentName, a.name
from Request r, student s, advisor a
where (r.status like '%pending%' or  r.status like '%Pending%') and
r.student_id=s.student_id AND
r.advisor_id=a.advisor_id
GO

--P
GO
Create PROC Procedures_AdminDeleteSlots
@current_semester varchar (40)
AS 
BEGIN
DELETE s 
FROM Slot s
JOIN Course_Semester cs ON s.course_id = cs.course_id
JOIN Course c ON cs.course_id = c.course_id
WHERE cs.semester_code =@current_semester
  AND c.is_offered = 0;
END
GO

--Q
GO
create function [FN_AdvisorLogin]
(@ID int, @password varchar(40))
returns bit
as
begin
declare @X bit
if (exists(select *
from Advisor a
where a.advisor_id = @ID AND a.password = @password))
set @x = 1
else set @x = 0
return @x
end
GO

--R
GO

Create PROC Procedures_AdvisorCreateGP

@Semester_code varchar (40), 
@expected_graduation_date date, @sem_credit_hours int, 
@advisor_id int, @student_id int
as
declare @acquired int 
select @acquired=Student.acquired_hours from Student where student.student_id=@student_id
if @acquired >= 157
BEGIN
INSERT INTO Graduation_Plan(semester_code,semester_credit_hours,expected_grad_date,advisor_id,student_id)
VALUES(@Semester_code,@sem_credit_hours,@expected_graduation_date,@advisor_id,@student_id)
END;
GO

--S
GO
Create PROC Procedures_AdvisorAddCourseGP
 @student_id int, @Semester_code varchar (40), @course_name varchar (40)
AS 
BEGIN
declare @course_id int ,@plan_id int

select @course_id=c.course_id
from Course c
where @course_name=c.name

select @plan_id=g.plan_id
from Graduation_Plan g
where g.student_id= @student_id
insert into GradPlan_Course (plan_id,semester_code,course_id)
values(@plan_id,@Semester_code,@course_id)
END;
GO

--T
GO
create procedure Procedures_AdvisorUpdateGP

@expected_grad_date date,
@studentID int
As
Begin
    UPDATE Graduation_Plan
    SET Graduation_Plan.expected_grad_date =@expected_grad_date  
    where Graduation_Plan.student_id = @studentID
end;
GO

--U
GO
CREATE PROC Procedures_AdvisorDeleteFromGP
@studentID int, @semester_code varchar (40),@course_ID INT 
AS
BEGIN
declare @plan_id int


select @plan_id=gp.plan_id
from Graduation_Plan gp
where  gp.student_id=  @studentID and
gp.semester_code=@semester_code


DELETE from GradPlan_Course
where GradPlan_Course.plan_id=@plan_id and  
GradPlan_Course.semester_code=@semester_code
and GradPlan_Course.course_id=@course_ID
end;
GO

--V
GO
CREATE FUNCTION [FN_Advisors_Requests]

    (@advisorID int)
    RETURNS TABLE as
    RETURN(SELECT * FROM REQUEST r
            WHERE r.advisor_id=@advisorID
    )

GO

--W
Go 
create PROC Procedures_AdvisorApproveRejectCHRequest
 @RequestID int,
 @CurrentsemesterCode varchar (40)
 

 AS
 begin
 DECLARE @SID INT,@gpa DECIMAL
 SELECT @SID=R.student_id
 FROM Request R
 WHERE R.request_id=@RequestID and R.type like'%credi%'


 declare @assignedhours int, @cou int, @stu int
 select @assignedhours=s.assigned_hours, @stu=s.student_id,@gpa=s.gpa
 from Student s
 where  s.student_id=@SID

 declare @credithours int
 select  @credithours=r.credit_hours 
 from Request r
 where r.request_id=@RequestID



 if(@assignedhours+@credithours<=34 AND @credithours<=3  and @gpa<3.7)
 Begin
     Update Request
     SET status = 'Accepted'
     WHERE request_id = @RequestID
        

  Update Student 
  SET Student.assigned_hours = @assignedhours+@credithours
  where Student.student_id=@stu


  declare @dead datetime
  set @dead=dbo.FN_StudentUpcoming_installment(@SID)
  UPDATE installment 
  SET amount =amount+1000
  where deadline=@dead
  UPDATE Payment 
  SET amount=amount+1000
  WHERE student_id=@SID and semester_code=@CurrentsemesterCode

 end;
 else
 begin
 Update Request
 SET Request.status = 'Rejected'
  WHERE Request.request_id = @RequestID
        
 end
 end;
GO


--X

GO
create proc Procedures_AdvisorViewAssignedStudents
@AdvisorID int , @major varchar (40)
as 
begin



select s.student_id, s.f_name,s.major,c.name
from Student s, Course c,Student_Instructor_Course_Take si
where s.advisor_id=@AdvisorID and s.major=@major and 
si.student_id=s.student_id and c.course_id=si.course_id


end;
GO

--Y
GO
create proc Procedures_AdvisorApproveRejectCourseRequest
@RequestID int,@current_semester_code varchar(40)
as
BEGIN
declare @cid int, @student_id int

SELECT @cid = r.Course_id, @student_id = r.student_id
FROM request r
INNER JOIN Student s ON r.student_id = s.student_id
WHERE r.request_id = @RequestID
  AND R.type LIKE '%course%'
  AND s.assigned_hours <= 34
  AND (r.credit_hours <= 3 OR r.credit_hours IS NULL);


 

declare @offered bit , @ok varchar(40) ,@C2 INT,@ins int,@c int
select @offered=is_offered 
from course c inner join Course_Semester  cs on c.course_id=cs.course_id
where cs.course_id=@cid AND
cs.semester_code=@current_semester_code




select @offered=is_offered 
from course c inner join Course_Semester  cs on c.course_id=cs.course_id
where cs.course_id=@cid AND
cs.semester_code=@current_semester_code


select @ins=instructor_id
from Instructor_Course 
where course_id=@cid




if @offered=1

BEGIN
  
  
    SELECT @c=count(*)
    FROM PreqCourse_course P
    INNER JOIN COURSE  C  ON P.course_id = c.course_id
    inner JOIN Student_Instructor_Course_Take SI ON sI.course_id = P.prerequisite_course_id
    WHERE c.course_id = @cid
    AND si.student_id =@student_id 
    AND si.grade IS NOT NULL 
    AND si.grade NOT IN ('F', 'FF', 'FA')






SELECT @C2=count(*)
    FROM PreqCourse_course pc
    INNER JOIN Course c ON pc.course_id = c.course_id
    WHERE c.course_id = @cid
    

END



if @c=@C2
BEGIN
    SET @ok = 'APPROVED'
    UPDATE request 
    SET STATUS = 'APPROVED'
    WHERE request_id = @RequestID
end



else 
BEGIN
    SET @ok = 'REJECTED'
    UPDATE request 
    SET STATUS = 'REJECTED'
    WHERE request_id = @RequestID
END


if @ok='APPROVED'
BEGIN
insert into Student_Instructor_Course_Take (student_id , course_id , 
semester_code , exam_type,instructor_id)
values(@student_id, @cid, @current_semester_code, 'Normal',@ins) 
END



end;
GO

--Z
GO
create procedure Procedures_AdvisorViewPendingRequests
@AdvisorID int
as
begin
select *
from Request r
where r.advisor_id = @AdvisorID
    AND (r.status = 'pending' OR r.status = 'Pending')

end;
GO

--AA
GO
Create Function [FN_StudentLogin]
(@StudentID int,@password varchar(40))
Returns bit
AS
Begin
Declare @Success bit

If exists(select * 
from student s
where s.student_id=@StudentID AND s.password=@password)
set @Success=1
 

else
set @Success=0


 return @success

end
GO

--BB
GO
CREATE PROCEDURE Procedures_StudentaddMobile
@StudentID int,
@mobile_number varchar (40)

AS 
BEGIN
INSERT INTO Student_Phone(student_id,phone_number)
VALUES(@StudentID,@mobile_number)


END 
GO

--CC
GO
Create Function [FN_SemsterAvailableCourses]
(@semester_code varchar(40))
returns table AS
return(Select c.course_id as id, c.name , c.major,c.is_offered,c.credit_hours,c.semester,cs.semester_code
from course c  inner join Course_Semester cs on cs.course_id=c.course_id
where cs.semester_code=@semester_code)
GO

--DD
GO
CREATE PROCEDURE Procedures_StudentSendingCourseRequest

@StudentID int,
@courseID int,
@type varchar (40), 
@comment varchar (40) 


AS
BEGIN

if @type like '%course%'
begin
INSERT INTO Request(student_id,course_id, type, comment)
Values(@StudentID,@courseID,@type, @comment)
end 


END
GO

--EE
GO
CREATE PROC  Procedures_StudentSendingCHRequest
@Student_ID int, 
@credit_hours int,
@type varchar (40), 
@comment varchar (40) 
AS
BEGIN
if @type like '%credit%'
begin
INSERT INTO Request(student_id,credit_hours,type,comment)
Values(@Student_ID , @credit_hours ,@type , @comment ) 
end 
END
GO

--FF
GO
Create Function[FN_StudentViewGP]
(@student_ID int)
returns table 
AS
return(select s.student_id,s.f_name+''+s.l_name AS sname,g.plan_id,c.course_id,c.name,g.semester_code,
sem.end_date AS expected_graduation_date,g.semester_credit_hours,s.advisor_id
from student s inner join Graduation_Plan g on s.student_id=g.student_id
inner join GradPlan_Course gc on gc.plan_id=g.plan_id 
inner join course c on c.course_id=gc.course_id
inner join Semester sem on sem.semester_code=g.semester_code
where s.student_id=@student_ID)

GO

--GG
GO
create function [FN_StudentUpcoming_installment]
(@StudentID int)
returns date
as
begin
declare @X date
select top 1 @x = i.deadline
from Payment p
INNER JOIN Installment I
ON i.payment_id = p.payment_id 
where p.student_id = @StudentID AND
i.status = 'NotPaid'
ORDER BY i.deadline ASC

if @x IS NULL
    set @X = null
return @X
end
GO

--HH
GO
create function [FN_StudentViewSlot]
(@CourseID int, @InstructorID int)
returns Table
as
return(
select s.slot_id, s.location, s.time,
s.day, c.name as 'Course Name', i.name as 'Instructor Name'
From Slot s, Course c, Instructor i
where @CourseID = c.course_id AND
@InstructorID = i.instructor_id AND
s.course_id = @CourseID AND
s.instructor_id = @InstructorID)

GO

--II

GO 
CREATE PROC  Procedures_StudentRegisterFirstMakeup
@StudentID int, 
@courseID int, 
@studentCurrent_semester varchar (40)
AS
Begin
declare @y int
Select @y=count(*)
From   Student_Instructor_Course_Take si
where si.student_id = @StudentID AND
si.course_id =@courseID AND
(si.grade = 'FF' OR si.grade = 'F' OR si.grade = NULL or si.grade = 'FA') AND
si.exam_type = 'Normal' 
and not EXISTS(select * from Student_Instructor_Course_Take si2
where si2.student_id = @StudentID AND
si2.course_id =@courseID AND
    (si2.exam_type='First_makeup' or si2.exam_type='Second_makeup')
)


if @y>0
begin

declare @i_id int
Select @i_id=ic.instructor_id
from Instructor_Course ic 
where course_id=@courseID

if EXISTS(
select *
from MakeUp_Exam
where course_id=@courseID and TYPE='First_makeup')


BEGIN
insert into Student_Instructor_Course_Take(student_id , course_id , semester_code , exam_type , grade,instructor_id)
values (@StudentID,@courseID,@studentCurrent_semester,'First_makeup',null,@i_id)

declare @mid int
select @mid=exam_id
from MakeUp_Exam
where course_id=@courseID and TYPE='First_makeup'

insert into Exam_Student(exam_id,course_id,student_id)
values(@mid,@courseID,@StudentID)
end

end

end;
go

--JJ
GO
create function [FN_StudentCheckSMEligiability]
(@CourseID int, @StudentID int)
returns bit
as
begin
declare @X bit ,@Y BIT,@Z BIT
set @X=0
SET @Y=0
SET @Z=0


IF EXISTS (
select *
From  Student_Instructor_Course_Take sic
where sic.student_id = @StudentID AND
sic.course_id = @CourseID AND
sic.exam_type = ' First_makeup' AND
(sic.grade = 'FF' OR sic.grade = 'F' OR sic.grade = NULL)
)
BEGIN
SET @Y=1
END 

ELSE
BEGIN
SET @Y=0
END

 
 IF not exists(select count(*) 
from Student_Instructor_Course_Take sic2
where 
sic2.student_id=@StudentID

and(
        (sic2.exam_type = 'Second_makeup' And (sic2.grade = 'F' Or sic2.grade = 'FF'or sic2.grade = 'FA')) 
)
      having count(*)>2  )

BEGIN
SET @Z=1
END


ELSE
BEGIN
SET @Z=0
END

IF (@Z =1 AND @Y=1)
BEGIN
SET @X =1
END

ELSE
BEGIN
SET @X=0
END




return @X
end
GO


--KK

go
create procedure Procedures_StudentRegisterSecondMakeup
@StudentID int, @courseID int, @Student_Current_Semester Varchar (40)

as
begin
declare @x bit
set  @x=dbo.FN_StudentCheckSMEligiability(@StudentID,@courseID)


if @x=1

begin  


declare @i_id int
Select @i_id=ic.instructor_id
from Instructor_Course ic 
where course_id=@courseID


insert into Student_Instructor_Course_Take(student_id , course_id ,
  semester_code , exam_type 
, grade,instructor_id)
values (@StudentID,@courseID,@Student_Current_Semester,'Second_makeup',null,@i_id)

declare @mid int
select @mid=exam_id
from MakeUp_Exam
where course_id=@courseID and type='Second_makeup'


insert into Exam_Student(exam_id,course_id,student_id)
values(@mid,@courseID,@StudentID)


end
end
go


--LL
GO
create PROCEDURE Procedures_ViewRequiredCourses
 @StudentID int, 
@Current_semester varchar (40)
AS



begin
select sic.course_id,c.name,c.major,c.is_offered,c.credit_hours,c.semester
From  Course c inner join Student_Instructor_Course_Take sic on c.course_id=sic.course_id
where 
sic.student_id = @StudentID AND
sic.semester_code=@Current_semester AND
sic.exam_type= 'Second_makeup'AND
(sic.grade = 'FF' OR sic.grade = 'F' OR sic.grade = NULL OR sic.grade = 'FA') and
 dbo.FN_StudentCheckSMEligiability(sic.course_id ,@StudentID)=0
 

end
GO


--MM
GO
CREATE PROC Procedures_ViewOptionalCourse
@StudentID int, @Current_semester_code Varchar (40)


AS
begin


select c.*
from Course c inner join Student s
on (c.major=s.major OR c.major=s.faculty)
where s.student_id=@StudentID
except (
select cc.*
from Student_Instructor_Course_Take sic inner join Course cc
on cc.course_id=sic.course_id
where sic.student_id=@StudentID  )


end
GO

--NN


go
create proc Procedures_ViewMS

@StudentID int, @Current_semester_code Varchar (40)


AS
begin


select c.*
from Course c inner join Student s
on (c.major=s.major OR c.major=s.faculty)
where s.student_id=@StudentID
except (
select cc.*
from Student_Instructor_Course_Take sic inner join Course cc
on cc.course_id=sic.course_id
where sic.student_id=@StudentID  )


end
GO




--OO
GO
CREATE PROCEDURE Procedures_ChooseInstructor
    @StudentID INT,
    @InstructorID INT,
    @CourseID INT,
    @current_semester_code VARCHAR(40)
    AS
BEGIN
    
   

   select *
    FROM Student_Instructor_Course_Take 
    WHERE student_id = @StudentID
      AND course_id = @CourseID
      AND semester_code=@current_semester_code
    

    
    
        UPDATE Student_Instructor_Course_Take
        SET instructor_id = @InstructorID
        WHERE student_id = @StudentID
          AND course_id = @CourseID
          AND semester_code=@current_semester_code;
    
    
END;
GO


