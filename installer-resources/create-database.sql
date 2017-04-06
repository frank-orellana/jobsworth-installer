CREATE DATABASE jobsworth CHARACTER SET utf8 COLLATE utf8_unicode_ci;
create user jw@localhost identified by 'jobsworth';
grant all privileges on jobsworth.* to jw@localhost with grant option;
