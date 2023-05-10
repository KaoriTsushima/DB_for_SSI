use ssi;
insert into doctor
(doctor_id, experience, first_name, last_name)
values
("D1", 2, "Ringo", "Starr"),
("D2", 5, "George", "Harrison"),
("D3", 7, "John", "Lennon"),
("D4", 10, "David", "Beckham"),
("D5", 15, "Andy", "Murray");

# data of patient was imported from CSV file.
# data of medical_history was imported from CSV file.
# data of pre_surgery was imported from CSV file.
# data of surgery was imported from CSV file.
# data of administration was imported from CSV file.

alter table medical_history
add constraint
foreign key (patient_id)
references patient (patient_id);

alter table pre_surgery
add constraint
foreign key (patient_id)
references patient (patient_id);
alter table pre_surgery
add constraint
foreign key (surgery_id)
references surgery (surgery_id);

alter table surgery
add constraint
foreign key (patient_id)
references patient (patient_id);

alter table administration
add constraint
foreign key (doctor_id)
references doctor (doctor_id);

alter table administration
add constraint
foreign key (patient_id)
references patient (patient_id);

alter table administration
add constraint
foreign key (surgery_id)
references surgery (surgery_id);
