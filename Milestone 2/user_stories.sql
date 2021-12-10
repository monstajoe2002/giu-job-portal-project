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
--go
--CREATE PROC JobsSearch
--@semester int, @allowed_faculty varchar(20)
--AS
--Select @semester, @allowed_faculty
--From Student
--Where Student.semester =@semester or Student.allowed_faculty = @allowed_faculty
--If(@job_title IS NULL)
--exec ShowJobs OUTPUT

go
CREATE PROC UserRegister
@usertype varchar(20),@email varchar(50),@first_name varchar(20),@middle_name varchar(20),
@last_name varchar(20), @birth_date datetime,@GIU_id int,@semester int, @faculty varchar(20),@major
varchar(20),@gpa decimal(4,2),@adress varchar(10), @company_name varchar(20), @company_phone
varchar(20),@fax varchar(50), @company_website varchar(50), @type_of_business varchar(30), 
@establishment_year datetime, 
@origin_country varchar(20), @industry varchar(20), @n_current_employees int, @products_services varchar(30)

AS
DECLARE @user_id int
DECLARE @passwords varchar(8)
SET @user_id=Users.id_user
SET @password=Users.passwords
PRINT @id_user 
PRINT @password


--go
--CREATE PROC UserLogin
--@email varchar(50), @password varchar(20)
--AS

drop proc UserLogin

