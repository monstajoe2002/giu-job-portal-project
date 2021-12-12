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

