# requirment: in your database, create a stored function that can be applied to a query in your DB
# create doctor_level function
use ssi;
select *
from ssi.doctor;

DELIMITER //

create function doctor_level (experience int) 
returns varchar(50) deterministic
begin
 declare doctor_level varchar(50);
 if experience >= 10 then
 set doctor_level = 'Senior';
 
 elseif (experience < 10 and experience >= 5) then
 set doctor_level = 'Junior';
 
 elseif experience < 5 then
 set doctor_level = 'Practitioner';
 
 end if;
 return (doctor_level);
 end 
//

DELIMITER ;
 
 # call doctor_level function
select d.*, doctor_level(d.experience) as doctor_level from ssi.doctor d;

# create function of inHospitalTerm
select p.*, a.ssi_date, a.discharge_date, 
timestampdiff(day, ssi_date, discharge_date) as inHospitalAfterSSI
from ssi.patient p
left join ssi.administration a
on p.patient_id = a.patient_id;

DELIMITER //

create function inHospitalTerm (inHospitalAfterSSI int) 
returns varchar(50) deterministic
begin
 declare inHospitalTerm varchar(50);
 if inHospitalAfterSSI > 55.6 then
 set inHospitalTerm = 'Longer than avarage';
 
 elseif inHospitalAfterSSI <= 55.6 then
 set inHospitalTerm = 'Shorter than avarage';
 
 end if;
 return (inHospitalTerm);
 end 
//

DELIMITER ;

# avarage of in hospital term after SSI (result: 55.6 day)
select avg(timestampdiff(day, ssi_date, discharge_date)) as average
from ssi.administration;

# call inHospitalTerm function
select p.*, a.ssi_date, a.discharge_date, 
timestampdiff(day, ssi_date, discharge_date) as inHospitalAfterSSI,
inHospitalTerm(timestampdiff(day, ssi_date, discharge_date)) as inHospitalTerm
from ssi.patient p
left join ssi.administration a
on p.patient_id = a.patient_id
order by inHospitalAfterSSI desc;

# create boolean translate function
use ssi;
DELIMITER //

create function yesno (boolean int) 
returns varchar(5) deterministic
begin
 declare yesno varchar(5);
 if boolean = 1 then
 set  yesno = 'Yes';
 
 elseif boolean = 0 then
 set yesno = 'No';
 
 end if;
 return (yesno);
 end 
//

DELIMITER ;

# use yeso function
select 
m.patient_id, 
yesno(m.is_diabetes) as is_diabetes,
yesno(m.is_highBloodPressure) as is_highBloodPressure,
yesno(m.is_firstSurgery) as is_firstSurgery
from ssi.medical_history m;


# ADV: in your database, create a stored procedure and demonstrate how it runs
use ssi;
# drop procedure AgeGroupOlder;

DELIMITER //

CREATE PROCEDURE AgeGroupOlder()
BEGIN
	select p.*, pre.bmi, s.surgery_part, s.surgery_duration 
    from ssi.patient p
    left join ssi.surgery s
    on p.patient_id = s.patient_id
    left join ssi.pre_surgery pre
    on s.surgery_id = pre.surgery_id
    where p.age >= 65
    order by age desc;
END //

DELIMITER ;

call AgeGroupOlder();

#  create procedure of adult group
DELIMITER //

CREATE PROCEDURE AgeGroupAdult()
BEGIN
	select p.*, pre.bmi, s.surgery_part, s.surgery_duration 
    from ssi.patient p
    left join ssi.surgery s
    on p.patient_id = s.patient_id
    left join ssi.pre_surgery pre
    on s.surgery_id = pre.surgery_id
    where p.age < 65 and p.age >= 18;
END //

DELIMITER ;

call AgeGroupAdult();

# create procedure for inserting new doctors
DELIMITER //

CREATE PROCEDURE 
insert_new_doctor(in doctor_id varchar(20), in experience int , in first_name varchar(50), in last_name varchar(50))
BEGIN
	insert into ssi.doctor 
    (doctor_id, experience, first_name, last_name)
    values
    (doctor_id, experience, first_name, last_name);
END //

DELIMITER ;
