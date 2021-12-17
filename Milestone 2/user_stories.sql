use JobPortal
go
CREATE PROC ShowEmployers
AS
Select Employer.company_name 
from Employer
Left join Review_Profile
On Employer.emp_id =Review_Profile.emp_id
Where Review_Profile.profile_status = '1'
order by Employer.company_name asc 

go
CREATE PROC ShowJobs
AS
Select *
From Job
Where visibility='1'

go
CREATE PROC JobsSearch
@semester int, @allowed_faculty varchar(20)
AS
Select semester, allowed_faculty
From Required_semesters,Jobs
Inner JOIN Jobs on Required_semesters.job_id=Jobs.job_id
Where Student.semester =@semester or Student.allowed_faculty = @allowed_faculty
IF EXISTS
(SELECT 
        id_user
    FROM
        Users
    WHERE
        id_user IS NOT NULL)
exec ShowJobs OUTPUT

go
CREATE PROC UserRegister
@usertype varchar(20),@email varchar(50),@first_name varchar(20),@middle_name varchar(20),
@last_name varchar(20), @birth_date datetime,@GIU_id int,@semester int, @faculty varchar(20),@major
varchar(20),@gpa decimal(4,2),@adress varchar(10), @company_name varchar(20), @company_phone
varchar(20),@fax varchar(50), @company_website varchar(50), @type_of_business varchar(30), 
@establishment_year datetime, 
@origin_country varchar(20), @industry varchar(20), @n_current_employees int, @products_services varchar(30),
@user_id int OUTPUT,@password varchar OUTPUT

AS
SELECT 
        id_user,
        passwords
    FROM
        Users
    WHERE
        id_user = @user_id and
        passwords=@password



go
CREATE PROC UserLogin
@email varchar(50), @password varchar(20), @success bit OUTPUT,@user_id int OUTPUT
AS


IF EXISTS
(SELECT 
        id_user
    FROM
        Users
    WHERE
        id_user = @user_id)
BEGIN
	SET @user_id=-1
	SET @success=0
	END;
ELSE SET @success=1

go
CREATE PROC ViewProfile
@user_id int
AS
SELECT 
        *
    FROM
        Users
    WHERE
        id_user = @user_id
go
CREATE PROC DeleteProfile
@user_id int
AS
DELETE FROM Users WHERE EXISTS(SELECT 
        id_user
    FROM
        Users
    WHERE
        id_user =@user_id)
go
CREATE PROC AdminViewEmps
AS
Select * FROM Employer
 go
 CREATE PROC AdminReviewEmp
 @admin_id int, @emp_id int, @profile_status bit, @reason varchar(100)
 AS
 IF @profile_status='0'
	BEGIN
	UPDATE Review_Profile
	SET reason=@reason
	WHERE admin_id=@admin_id AND emp_id=@emp_id
	END
go
CREATE PROC AdminViewJobs
AS
SELECT * FROM Job
go
CREATE PROC AdminViewFRs
AS
SELECT * FROM Faculty_Representative

go
CREATE PROC EmpEditProfile 
@id int, @password varchar(8), @address varchar(10), @company_name varchar(20),
@company_phone varchar(20), @fax varchar(50), @company_website varchar(50),
@type_of_business varchar(30), @establishment_year datetime, @origin_country varchar(20),
@industry varchar(20), @n_current_employees int, @products_services varchar(30) 
AS
UPDATE Employer
SET
emp_address = @address,
company_name = @company_name,
company_phone = @company_phone,
fax = @fax,
company_website = @company_website,
type_of_business = @type_of_business,
establishment_year = @establishment_year,
origin_country = @origin_country,
industry = @industry,
n_current_employees= @n_current_employees,
products_services = @products_services
WHERE
Employer.emp_id = @id
UPDATE Users
SET
passwords = @password
WHERE 
	id_user=@id

go

CREATE PROC AddContact
@emp_id int, @name varchar(20), @job_title varchar(30),
@email varchar(50), @mobile_number varchar(20), @fax varchar(50)
AS
INSERT INTO Contact_person VALUES (@emp_id, @name, @job_title,
@email, @mobile_number, @fax)

go

CREATE PROC AddHR
@emp_id int, @name varchar(20), @email varchar(50)
AS
INSERT INTO HR_Director VALUES (@emp_id, @name, @email)

go
CREATE PROC ViewProﬁleStatus --problematic
@emp_id int, @status bit OUTPUT, @reason varchar(100) OUTPUT 
AS
IF EXISTS(SELECT 
        emp_id
    FROM
        Review_Profile
    WHERE
        @emp_id =emp_id)
SET
profile_status=@status,
reason=@reason

go
CREATE PROC PostJob
@emp_id int, @title varchar(30), @description varchar(50), @department varchar(20),
@start_date datetime, @end_date datetime, @application_deadline datetime,
@n_available_internships int, @salary_range varchar(20), @qualiﬁcations varchar(100),
@location varchar(20), @application_link varchar(50), @application_email varchar(50), 
@job_type varchar(30), @workdays int, @job_id int OUTPUT
AS
IF EXISTS(SELECT 
        emp_id
    FROM
        Review_Profile
    WHERE
        @emp_id =emp_id
        AND profile_status='1')
BEGIN
INSERT INTO Job(job_title, job_description, department,
job_start_date, end_date, application_deadline,
n_available_internships, salary_range, qualiﬁcations,
job_location, application_link, application_email, 
job_type)
VALUES(@title, @description, @department,
@start_date, @end_date, @application_deadline,
@n_available_internships, @salary_range, @qualiﬁcations,
@location, @application_link, @application_email, 
@job_type)
INSERT INTO Part_time(workdays)
VALUES(@workdays)
END

go
CREATE PROC AddFaculty
@job_id int, @allowed_faculty varchar(20)
AS
INSERT INTO Allowed_Faculties
VALUES(@job_id, @allowed_faculty)

go
CREATE PROC AddSemester
@job_id int, @semester int
AS
INSERT INTO Required_Semesters
VALUES(@job_id, @semester)

go
CREATE PROC AddFacultyRepToII
@job_id int, @admin_id int, @facultyRep_id int
AS
IF EXISTS (SELECT * 
FROM Admin A 
WHERE @admin_id = A.id)
BEGIN
SELECT faculty_name 
FROM Allowed_faculties 
INNER JOIN Job J
ON J.id = A.id
INNER JOIN Industrial_Internship I
ON I.id = J.id
INNER JOIN Faculty_Representative F
ON F.faculty= A.faculty_name 
END

go
CREATE PROC AdminReviewJob
@admin_id int, @job_id int, @visibility bit, @reason varchar(100)
AS
IF NOT EXISTS (SELECT ID 
FROM Industrial_Internship 
WHERE Industrial_Internship.ID = @job_id)
BEGIN
UPDATE JOB
SET
Job.visibilty = @visibility,
Job.reason = @reason
WHERE Job.admin_id = @admin_id
END
ELSE
begin
exec courseInformation
end

go
CREATE PROC EmpViewJobs
@emp_id intX
AS
SELECT emp_id
FROM Employer e,Job j
INNER JOIN e on j.emp_id=e.emp_id
ORDER BY j.job_start_date ASC

go
CREATE PROC EmpViewApplicants
AS
Select Student.* 
FROM Student s,Applies app,Job j
INNER JOIN s on app.s_id=s.s_id
INNER JOIN app ON j.job_id=app.job_id

go
CREATE PROC EmpUpdateApplicant
@student_id int, @job_id int, @application_status varchar(20)
AS
IF EXISTS(SELECT s_id,job_id,eligibility
FROM Student s, Industrial_Internship ii,Job j,Eligible
INNER JOIN ii ON j.job_id=ii.job_id 
INNER JOIN Eligible on s.s_id=Eligible.s_id
WHERE eligibility='1')
UPDATE Applies
SET 
@student_id=s_id,
@job_id=job_id,
@application_status=application_status

go
create proc courseInformation
@facRep_id int, @job_id int,@ii_status bit OUTPUT
AS
IF EXISTS (SELECT job_id FROM Job j,Industrial_Internship 
INNER JOIN j on Industrial_Internship.job_id=j.job_id
where job_id=@job_id)
SET @ii_status='1'
ELSE
SET @ii_status='0'
go
create proc StudentEditProfile
@sid int, @email varchar(50),@first_name varchar(20),@middle_name varchar(20), @last_name
varchar(20), @birth_date datetime,@GIU_id int,@semester int, @faculty varchar(20),@major varchar(
20),@gpa decimal(4,2),@adress varchar(10)
AS
UPDATE Student
SET s_id=@sid,first_name=@first_name,middle_name=@middle_name,
birth_date=@birth_date,GIU_ID=@GIU_id,semester=@semester,faculty=@faculty,
gpa=@gpa,student_address=@adress
WHERE
	s_id=@sid
UPDATE Users
SET
email=@email
WHERE 
	id_user=@sid
go
create proc AddMobile
@sid int,@mobileNumber varchar(20)
AS
IF EXISTS(SELECT s_id FROM Student WHERE @sid=s_id)
UPDATE Student_phoneNumber
SET number=@mobileNumber
go
CREATE proc CreateCV
@sid int, @personal_mail varchar(50), @education varchar(100), @extracurricular_activities
varchar(300), @linkedIn_link varchar(30), @github_link varchar(30), @skills varchar(300), @achievements
varchar(300)
AS
IF EXISTS(SELECT s_id from Student WHERE @sid=s_id)
BEGIN
INSERT INTO CV_Builder
VALUES (@personal_mail , @education, @extracurricular_activities,
@linkedIn_link , @github_link , @skills , @achievements,@sid)
SELECT * FROM CV_Builder
END

go
create proc ApplyForJob
@sid int, @job_id int
AS
IF EXISTS(SELECT s_id FROM Student s,Applies
INNER JOIN s on Applies.s_id=s.s_id
WHERE s_id=@sid)
UPDATE Applies
SET	application_status='Accepted'

go
create proc ViewMyStatus
@sid int, @job_id int,@application_status varchar(20) OUTPUT
AS
IF EXISTS(SELECT s_id FROM Student s,Applies
INNER JOIN s on Applies.s_id=s.s_id
WHERE s_id=@sid)
PRINT @application_status

go
create proc AddProgressReport
@sid int, @date datetime, @description varchar (100)
AS
IF EXISTS (SELECT s_id from Student where s_id=@sid)
INSERT INTO Progress_report (dates,report_description)
VALUES(@date, @description)

go
create proc ViewMyReports
@sid int,@nOfReports int OUTPUT, @date datetime OUTPUT, @decription varchar(100) OUTPUT, 
@numeric_state int OUTPUT, @evaluation varchar(100) OUTPUT
AS
IF EXISTS (SELECT s_id from Student s,Progress_report
inner join s on Progress_report.s_id=s.s_id	
where s_id=@sid)
SELECT @nOfReports =SUM(s_id) FROM Student
ELSE
SET @numeric_state=-1
SET @evaluation='not evaluated yet' 

go
CREATE PROC ViewAdvisors
AS
SELECT * FROM Academic_Advisor

go
CREATE PROC CocViewStudents
@ii_id int
AS
SELECT student_ID
FROM Apply
WHERE Apply.job_ID = @ii_id

go
CREATE PROC CocUpdateEligibility
@coc_id int, @s_id int, @ii_id int, @eligibility bit
AS
SELECT eligibility FROM Eligible
WHERE Eligible.student_id = @s_id
AND Eligible.II_id = @ii_id
AND Eligible.coc_id = @coc_id
UPDATE Eligible.eligibility = @eligibility
WHERE WHERE Eligible.student_id = @s_id
AND Eligible.II_id = @ii_id
AND Eligible.coc_id = @coc_id

go
CREATE PROC AAToII
@aa_id int, @ii_id int
AS
IF(Industrial_Internship.status = '1')
BEGIN
UPDATE Industrial_Internship.aa_id = @aa_id
WHERE Industrial_Internship.ID = @ii_id
END

go
CREATE PROC EvalProgressReport
@sid int, @date datetime, @numeric_state int, @evaluation varchar(100)
AS
UPDATE Progress_report.evaluation = @evaluation
WHERE Progress_report.student_id = @sid
AND Progress_report.date = @date
AND Progress_report.numeric_state = @numeeric_state

go
CREATE PROC ViewProgressReports
@advisor_id int
AS
SELECT * FROM Proress_report
WHERE Proress_report.advisor_id = @advisor_id
ORDER BY Proress_report.date DESC
