# requirement: create relational DB of your choice with minimum 5 tbales.
# requirement: set primary and foreign key constraints to create relations between tables.

create database SSI;
use SSI;
create table patient (
patient_id varchar(20) not null,
first_name varchar(50) not null,
last_name varchar(50) not null,
gender varchar(20),
age int,
primary key (patient_id)
);

create table medical_history (
patient_id varchar(20) not null,
is_diabetes boolean,
is_highBloodPressure boolean,
is_firstSurgery boolean,
primary key (patient_id)
);

create table pre_surgery (
surgery_id varchar(20) not null,
patient_id varchar(20) not null,
is_urgent boolean,
is_marking boolean,
BMI float,
primary key (surgery_id)
);

create table administration (
administration_id varchar(20) not null,
patient_id varchar(20) not null,
doctor_id varchar(20) not null,
surgery_id varchar(20) not null,
ssi_date date,
administration_date date,
discharge_date date,
primary key (administration_id)
);

create table surgery (
surgery_id varchar(20) not null,
patient_id varchar(20) not null,
surgery_part varchar(50) not null,
surgery_date date,
surgery_duration time,
did_transfusion boolean,
primary key (surgery_id)
);

create table doctor (
doctor_id varchar(20) not null,
experience int,
first_name varchar(50),
last_name varchar(50),
primary key (doctor_id)
);

