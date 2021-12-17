--create database JobPortal
use JobPortal
go
create table Users(
id_user int primary key identity,
email varchar(50),
username varchar(20),
passwords varchar(8)
)

create table Student(
s_id int,
primary key(s_id),
foreign key(s_id) references Users ON DELETE CASCADE ON UPDATE CASCADE,
GIU_ID int,
first_name varchar(20),
middle_name varchar(20), 
last_name varchar(20),
birth_date datetime,
age AS (YEAR(CURRENT_TIMESTAMP)-YEAR(birth_date)),
semester int,
faculty varchar(20),
major varchar(20),
gpa decimal(4,2),
student_address varchar(10),
CV varchar(200),
coverletter varchar(200)
)

create table Student_phoneNumber(
phone_id int,
number varchar(20),
primary key(phone_id,number),
foreign key(phone_id) references Student ON DELETE CASCADE ON UPDATE CASCADE
)

create table Employer(
emp_id int,
primary key(emp_id),
foreign key(emp_id) references Users ON DELETE CASCADE ON UPDATE CASCADE,
company_name varchar(20),
emp_address varchar(10),
company_phone varchar(20),
fax varchar(50),
company_website varchar(50),
type_of_business varchar(30),
establishment_year datetime,
origin_country varchar(20),
industry varchar(20),
n_current_employees int,
products_services varchar(30)
)

create table Contact_person(
emp_id int,
primary key(emp_id),
foreign key(emp_id) references Employer ON DELETE CASCADE ON UPDATE CASCADE,
name varchar(20),
job_title varchar(30),
email varchar(50), 
mobile_number varchar(20), 
fax varchar(50)
)

create table HR_Director(
emp_id int,
primary key(emp_id),
foreign key(emp_id) references Employer ON DELETE CASCADE ON UPDATE CASCADE,
name varchar(20),
email varchar(50)
)

create table Admins(
admin_id int,
primary key(admin_id),
foreign key(admin_id) references Users ON DELETE CASCADE ON UPDATE CASCADE
)

create table Faculty_Representative(
facRep_id int,
primary key(facRep_id),
foreign key(facRep_id)references Users ON DELETE CASCADE ON UPDATE CASCADE
)

create table Academic_Advisor(
aa_id int,
primary key(aa_id),
foreign key(aa_id) references Users ON DELETE CASCADE ON UPDATE CASCADE,
faculty varchar(20)
)

create table Career_Office_Coordinator(
coc_id int,
primary key(coc_id),
foreign key(coc_id)references Users ON DELETE CASCADE ON UPDATE CASCADE
)

create table Review_Profile(
emp_id int,
admin_id int,
primary key(emp_id),
foreign key(emp_id) references Employer,
foreign key(admin_id) references Admins ON DELETE CASCADE ON UPDATE CASCADE,
profile_status bit,
reason varchar(100)
)

create table Job(
job_id int primary key identity,
job_title varchar(30),
job_description varchar(50),
department varchar(20),
job_start_date datetime, 
end_date datetime,
duration AS(YEAR(end_date)-YEAR(job_start_date)),
application_deadline datetime, 
n_available_internships int,
salary_range varchar(20), 
qualifications varchar(100), 
job_location varchar(20), 
application_link varchar(50), 
application_email varchar(50), 
job_type varchar(30),
emp_id int,
admin_id int,
foreign key(emp_id) references Employer ON DELETE CASCADE ON UPDATE CASCADE,
foreign key(admin_id) references Admins,
visibility bit,
reason varchar(100)
)

create table Allowed_faculties(
job_id int,
allowed_faculty varchar(20),
primary key(job_id, allowed_faculty),
foreign key(job_id) references Job 
)

create table Required_semesters(
job_id int,
semester int,
primary key(job_id,semester),
foreign key(job_id) references Job
)

create table Part_time(
job_id int,
primary key(job_id),
foreign key(job_id) references Job,
workdays int
)

create table Industrial_Internship(
job_id int,
primary key(job_id),
foreign key(job_id) references Job ON DELETE CASCADE ON UPDATE CASCADE,
ii_status bit,
aa_id int,
facRep_id int,
foreign key(aa_id) references Academic_Advisor,
foreign key(facRep_id) references Faculty_Representative
)

create table CV_Builder(
primary key(personal_mail),
personal_mail varchar(50),
education varchar(100), 
extracurricular_activities varchar(300), 
linkedIn_link varchar(30), 
github_link varchar(30), 
skills varchar(300), 
achievements varchar(300),
s_id int,
foreign key(s_id) references Student ON DELETE CASCADE ON UPDATE CASCADE
)

create table Applies(
s_id int,
job_id int,
primary key(s_id,job_id),
foreign key(s_id) references student on delete cascade on update cascade,
foreign key(job_id) references job,
application_status varchar(20) DEFAULT 'Pending'
)

create table Eligible(
s_id int,
ii_id int,
coc_id int,
primary key(s_id,ii_id),
foreign key(s_id) references Student ON DELETE CASCADE ON UPDATE CASCADE,
foreign key(ii_id) references Industrial_Internship,
foreign key(coc_id) references Career_Office_Coordinator,
eligibility bit
)

create table Progress_report(
s_id int,
dates datetime,
primary key(s_id,dates),
foreign key(s_id) references Student ON DELETE CASCADE ON UPDATE CASCADE,
numeric_state int,
evaluation varchar(100),
report_description varchar(100),
advisor_id int,
foreign key(advisor_id) references Admins
)

create table Freelance(
job_id int,
primary key(job_id),
foreign key(job_id) references Job 
)

create table Summer_internship(
job_id int,
primary key(job_id),
foreign key(job_id) references Job 
)

create table Full_time(
job_id int,
primary key(job_id),
foreign key(job_id) references Job 
)

create table Project_based(
job_id int,
primary key(job_id),
foreign key(job_id) references Job 
)
