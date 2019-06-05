--Project Feature Description:

-- Add a review for a cinema. Input includes a user ID, cinema ID, review score, and content of review. 
-- a.	First check whether user ID, cinema ID are valid and review score is from 1 to 5. If not print an error message. 
-- b.	Please also check if the same user has left a review for the same cinema within 30 days. If so print an error message that you cannot review the same place twice within 30 days. Otherwise insert a new review with the review time is current time.


/*
FEATURE 12: Add a Review For a Cinema
*/

set serveroutput on;

create or replace procedure add_review(userid in integer, cid in integer, score in integer, review_text in varchar)
IS
    check_score boolean;
    check_user boolean;
    check_cinema boolean;
    check_review_date boolean;
BEGIN

    --call helper functions to store boolean values into local variables to determine if the criteria for reviews is met
    check_user := is_valid_user(userid);
    check_cinema := is_valid_cinema(cid);
    check_score := is_valid_score(score);
    check_review_date := is_valid_review_date(userid, cid);
    
    if (check_cinema and check_user and check_score) then
        if (check_review_date) then
            --insert
            insert into cinema_reviews values(review_id.nextval, userid, cid, score, review_text, current_timestamp);
        else
            dbms_output.put_line('Sorry,you must wait 30 days to review a movie from this cinema again.');
        end if;
    else
        dbms_output.put_line('Please enter a valid user ID, cinema ID, and a score from 1 to 5.');
    end if;
END;
/



/*
helper function to check if a score is valid for the add_review procedure
input is the score value from the add_review procedure
returns a boolean value
*/
create or replace function is_valid_score(score integer)
RETURN BOOLEAN
AS
    is_valid boolean;
BEGIN
    if (score <= 5) and (score >= 1) then
        is_valid := true;
    else
        is_valid := false;
    end if;
        
    RETURN is_valid;
END;
/

/*
helper function to check if a user id is valid for the add_review procedure
input is the user id given in add_review procedure
returns a boolean value
*/
create or replace function is_valid_user(userid integer)
RETURN BOOLEAN
AS
    is_valid boolean;
    found_count integer;
    cursor c1 is select count(*) from cuser where user_id = userid;
BEGIN
    open c1;
    loop
        fetch c1 into found_count;
        exit when c1%notfound;
    
        if found_count = 1 then
            --user exist
            is_valid := true;
        else
            --user doesnt exist
            is_valid := false;
        end if;
    end loop;
    close c1;
        
    RETURN is_valid;
END;
/

/*
helper function to check if a cinema id is valid from the add_review procedure
input is the cinema id from the add_review procedure
returns a boolean value
*/
create or replace function is_valid_cinema(cid integer)
RETURN BOOLEAN
AS
    is_valid boolean;
    found_count integer;
    cursor c1 is select count(*) from cinema where cinema_id = cid;
BEGIN
    open c1;
    loop
        fetch c1 into found_count;
        exit when c1%notfound;
    
        if found_count = 1 then
            --user exist
            is_valid := true;
        else
            --user doesnt exist
            is_valid := false;
        end if;
    end loop;
    close c1;
        
    RETURN is_valid;
END;
/

/*
helper function to check if a review date is valid
input is user id and cinema id from add_review procedure
returns a boolean value
*/
create or replace function is_valid_review_date(userid integer, cid integer)
RETURN BOOLEAN
AS
    is_valid boolean;
    rev_date timestamp;
    thirty_days_ago timestamp;
    cursor c1 is select review_time from cinema_reviews where cinema_id = cid and user_id = userid;
BEGIN
    is_valid := true;
    thirty_days_ago := current_timestamp - 30;
    open c1;
    loop
        fetch c1 into rev_date;
        exit when c1%notfound;
        if rev_date > thirty_days_ago then
            is_valid := false;
        end if;
    end loop;
    close c1;
        
    RETURN is_valid;
END;
/
