--creation

create table Doctors 
(
Id int primary key,
Name varchar(100) not null,
Specialty varchar(50) not null,
years_of_exp int not null,
phone int not null,
Email varchar(50) not null,
 contact_details as 'phone' +' '+ Email,
)

create table patients
(
UR_Number int primary key,
Name varchar(100)not null,
age int not null,
address varchar(100) not null,
phone int not null,
Email varchar(50) not null,
Medical_card_num int ,
 contact_details  as 'phone' +' '+ Email,
 Primary_Doc_id int,
 foreign key (Primary_Doc_id) references Doctors(Id)
)

create table Pharmac_companies
(
ID int primary key ,
Name varchar(100) not null,
address varchar(100) not null,
phone int not null,
)

create table durgs
(
ID int primary key ,
Trade_name varchar(50) not null,
Strength int not null,
pres_comp_id int,
foreign key (pres_comp_id) references Pharmac_companies(ID)
ON UPDATE CASCADE  ON DELETE CASCADE
)

create table prescription
(
ID int primary key,
date date ,
quantity int not null
)

create table check_opreation
(
Id int primary key,
patients_id int,
doctors_id int,
durgs_Id int,
prescription_id int,
foreign key (patients_id) references patients(UR_Number),
foreign key (doctors_id) references Doctors(Id),
foreign key (durgs_Id) references durgs(ID),
foreign key (prescription_id) references prescription(ID),
)

-------------------------------------

--SELECT: Retrieve all columns from the Doctor table.

select *
from Doctors

--ORDER BY: List patients in the Patienttable in ascending 
--order of their ages.

select *
from patients
order by age asc

--OFFSET FETCH: Retrieve the first 10 patients from 
--the Patient table, starting from the 5th record.

select *
from patients
order by UR_Number
OFFSET 4 ROWS 
FETCH NEXT 10 ROWS ONLY

--SELECT TOP: Retrieve the top 5 doctors from the Doctor table.

select top 5 *
from Doctors
order by Id

--SELECT DISTINCT: Get a list of unique address from the Patient table.

select DISTINCT  address
from patients

--WHERE: Retrieve patients from the Patient table who are aged 25.

select *
from patients
where age =25

--NULL: Retrieve patients from the Patient table whose email is not provided.

select *
from patients
where Email is null

--AND: Retrieve doctors from the Doctor table who have experience 
--greater than 5 years and specialize in 'Cardiology'.

select *
from Doctors
where years_of_exp > 5 and Specialty ='Cardiology'

--IN: Retrieve doctors from the Doctor table
--whose speciality is either 'Dermatology' or 'Oncology'.

select *
from Doctors
where  Specialty ='Cardiology' or Specialty = 'Oncology'

--BETWEEN: Retrieve patients from the Patient table
--whose ages are between 18 and 30.

select *
from patients
where age between 18 and 30

--LIKE: Retrieve doctors from the Doctor table whose names start with 'Dr.'.

select *
from Doctors
where Name like 'Dr%'

--Column & Table Aliases: Select the name and email of doctors, aliasing them 
--as 'DoctorName' and 'DoctorEmail'.

select Name as DoctorName , Email as DoctorEmail
from Doctors

--Joins: Retrieve all prescriptions with corresponding patient names.

select p.* , pa.Name
from check_opreation c join patients  pa
on c.patients_id = pa.UR_Number
join prescription p
on c.prescription_id = p.ID

--GROUP BY: Retrieve the count of patients grouped by their cities.

select COUNT(UR_Number) as patientd_count
from patients
group by address

--HAVING: Retrieve cities with more than 3 patients.

select address
from patients
group by address
having count(UR_Number)>3

--UNION: Retrieve a combined list of doctors and patients.

select Name
from Doctors
union 
select Name
from patients

--Common Table Expression (CTE): Retrieve patients along with 
--their doctors using a CTE.

with service (patients_name,doctor_name) as
(
select p.Name , d.Name
from patients p join Doctors d
on Primary_Doc_id = d.Id
)
select *
from service

--INSERT: Insert a new doctor into the Doctor table.

insert into Doctors (
Id,Name,
Specialty,years_of_exp,
phone,Email
)
values
(
2015434,'ahmed',
'dentist',5,
01014562134,'ahmed_den@gmail.com'
)

--INSERT Multiple Rows: Insert multiple patients into the Patient table.

insert into patients (
UR_Number,Name,age,address,phone,Email,Medical_card_num)
values
(21354,'mohamed',25,'17 st tahreer',0120545314,'mohamedTah@gmail.com',null),
(254648,'mohsen',30,'9 st dsoay',011054341,'mohosen_almasry@gamil.com',1221354)


--UPDATE: Update the phone number of a doctor.

update Doctors
set phone = 0152345541
where Id=2015434

--UPDATE JOIN: Update the city of patients who have a prescription 
--from a specific doctor.

update patients
set address ='12 st zamalk'
from check_opreation c join patients p
on p.UR_Number=c.patients_id
join Doctors d
on d.Id = c.doctors_id
join prescription pp
on pp.ID=c.prescription_id
where pp.ID=2134 and d.Name='ahmed'

--DELETE: Delete a patient from the Patient table.

delete 
from patients
where patients.UR_Number=21354

--Transaction: Insert a new doctor and a patient, ensuring both 
--operations succeed or fail together.

BEGIN TRANSACTION ;

insert into Doctors (
Id,Name,Specialty,years_of_exp,phone,Email
)
values
(
209834,'ashraf','dentist',5,0110562134,'ahmed_den@gmail.com'
)
insert into patients (
UR_Number,Name,age,address,phone,Email,Medical_card_num)
values
(215423,'mohamod',25,'7 st tahreer',0110545314,'mohamodTah@gmail.com',null)

ROLLBACK;

--View: Create a view that combines patient and doctor 
--information for easy access.

create view Patient_And_Doctor
as 
select p.Name  'patient info' , d.Name 'doctor info'
from patients p join Doctors d
on d.Id = p.Primary_Doc_id

--Index: Create an index on the 'phone' column of the Patient
--table to improve search performance.

create index phone_search
on patients(phone)

--Backup: Perform a backup of the entire database to ensure data safety.

BACKUP DATABASE Prescription_system
TO DISK = 'D:\MOURAD\ps bk.bak'
