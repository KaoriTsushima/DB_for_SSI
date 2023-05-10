# requirement: using any type of the joins create a view that combines multiple tables in a logical way.

use ssi;
# drop view Patient_background;
create view Patient_background
as
select 
p.*, yesno(m.is_diabetes) as is_diabetes, pre.BMI, yesno(m.is_highBloodPressure) as is_highBloodPressure,
yesno(m.is_firstSurgery) as is_firstSurgery, yesno(pre.is_urgent) as is_urgent
from ssi.patient p
left join ssi.medical_history m
on p.patient_id = m.patient_id
left join ssi.pre_surgery pre
on p.patient_id = pre.patient_id;

select * from patient_background
order by BMI desc;

#ADV: create a view that uses at least 3-4 tables
# drop view Patient_basic_information;
create view Patient_basic_information
as
select 
p.*, d.first_name as doctor_name, d.last_name as doctor_surname, 
a.administration_date, s.surgery_part, s.surgery_date,  a.ssi_date, a.discharge_date
from ssi.patient p
left join ssi.administration a
on p.patient_id = a.patient_id
left join ssi.doctor d
on a.doctor_id = d.doctor_id
left join ssi.surgery s
on s.surgery_id = a.surgery_id;

select * from Patient_basic_information 
where age >= 65
order by surgery_part;

# ADV: prepare an example query with group by and having to demonstrate how to extract data from your DB for analysis
select count(pbi.surgery_part) as cases, pbi.surgery_part
from Patient_basic_information pbi
group by surgery_part
having cases >= 5;


# inHospitalTerm is over avarage (55 days)
select pbi.*, timestampdiff(day, ssi_date, discharge_date) as inHospitalTerm from Patient_basic_information pbi
having inHospitalTerm > 55
order by doctor_name;

#ADV: create a view that uses at least 3-4 tables
# create surgery_record view using stored functions
# drop view surgery_record;
create view surgery_record
as
select 
p.*, pre.bmi, s.surgery_part, s. surgery_date, s.surgery_duration, 
yesno(s.did_transfusion) as did_transfusion, 
d.first_name as doctor_name,
doctor_level(d.experience) as doctor_level
from ssi.patient p
left join ssi.pre_surgery pre
on p.patient_id = pre.patient_id
left join ssi.surgery s
on s.surgery_id = pre.surgery_id
left join ssi.administration a
on a.surgery_id = s.surgery_id
left join ssi.doctor d
on d.doctor_id = a.doctor_id;

select * from surgery_record
where surgery_duration > '10:00:00'
order by doctor_name;

# focus on doctors
select d.*, s.surgery_part,s.surgery_duration
from ssi.doctor d
left join ssi.administration a
on d.doctor_id = a.doctor_id
left join ssi.surgery s
on s.surgery_id = a.surgery_id;

# requirement: Prepare an example query with a subquery to demonstrate how to extract data from your DB for analysis 
# search patients who was not urgent for analysis
select p.first_name, p.last_name, p.age
from ssi.patient p
left join ssi.pre_surgery pre
on p.patient_id = pre.patient_id
where pre.patient_id in 
(select pre.patient_id from ssi.pre_surgery
where pre.is_urgent = 0);

# subquery example 2: analyse over 10 hour surgery
select p. *, pre.BMI, s.surgery_part, s.surgery_duration
from ssi.patient p
left join ssi.pre_surgery pre
on p.patient_id = pre.patient_id
left join ssi.surgery s
on s.surgery_id = pre.surgery_id
where s.surgery_duration > '10:00:00';

 
# average surgery duration for each part
SELECT surgery_part, SEC_TO_TIME(AVG(TIME_TO_SEC(`surgery_duration`))) as "Average Time" FROM ssi.surgery
group by surgery_part;

# analyse avarage surgery duration by doctors
SELECT distinct d.doctor_id, d.first_name, d.last_name, SEC_TO_TIME(AVG(TIME_TO_SEC(`surgery_duration`))) as "Average Time" 
FROM ssi.doctor d
left join ssi.administration a
on d.doctor_id = a.doctor_id
left join ssi.surgery s
on s.surgery_id = a.surgery_id
group by doctor_id;
