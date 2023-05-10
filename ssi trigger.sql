# ADV: in your database, create a trigger and demonstrate how it runs
use ssi;
# drop table doctor2;
create table doctor2 (
doctor_id varchar(20) not null,
first_name varchar(50),
last_name varchar(50),
experience int,
position varchar(20),
primary key (doctor_id)
);

DELIMITER //
create trigger insert_DrInfo
before insert
on ssi.doctor2
for each row
begin 

if new.experience >= 10 then
set new.position = "Senior";

elseif (new.experience < 10 and new.experience >= 5) then
 set new.position = 'Junior';

elseif new.experience < 5 then
 set new.position = 'Practitioner';
 
 end if;
 
 end //
 DELIMITER ;
 
 insert into ssi.doctor2
 (doctor_id, first_name, last_name, experience)
 values
 ("D8", "Kaori", "Tsushima", 1);
