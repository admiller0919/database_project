--Project Feature Description:

-- Registration: a user needs to provide name, email, address, and password. The procedure should check whether the email 
-- already exists in the users table. If so, please print a message saying the user already exists. Otherwise insert the 
-- user into users table and print the new user ID.  

/*
FEATURE 1: Registration
*/

set serveroutput on;

--drop sequence user_id;
--create sequence user_id start with 6;

select * from cuser;

create or replace procedure register(p_name in varchar, p_email in varchar, p_address in varchar, p_password in varchar)
IS
email_found varchar(20);
found_id integer;
found_count integer;

cursor c1 is select count(*) from cuser where email = p_email;

BEGIN
    open c1;
    loop
        fetch c1 into found_count;
        exit when c1%notfound;
    
        if found_count > 0 then
            dbms_output.put_line('The email address, '|| p_email || ', already exists. Please enter a valid email.');
        else
            insert into cuser values(user_id.nextval, p_name, p_email, p_address, p_password);
            dbms_output.put_line('You have successfully been registered, ' || p_name || '.');
        end if;
    
    end loop;
    close c1;
END;
