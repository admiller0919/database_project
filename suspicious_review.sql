--Project Feature Description:

-- ** Identify suspicions reviews. Suspicious reviews are those 1) very short (no more than x characters long where x is input and with extreme scores (1 or 5); or 2) the reviewer has never purchased any tickets for shows at the reviewed cinema. For example, if a reviewer A has left a review for cinema X. But only users B, C, and D have purchased tickets at X (they have transactions with shows at X), then A's review for X is fake. Please print out review id and reason for fake review.

/*
FEATURE 16: Identify Suspicious Reviews
*/

set serveroutput on;
select * from cinema_reviews;

create or replace procedure check_review(p_rid in integer)
IS

    cursor c1 is select count(*) from cinema_reviews r, movie_transactions t, showtime s
    where p_rid = r.review_id
    and r.cinema_id = s.cinema_id
    and s.show_id = t.show_id
    and t.user_id = r.user_id;
    
review varchar(50);
r_score number;
r_length integer;
user_count integer;
num_of_reviews integer; --number of reviews with the given ID

BEGIN
    r_length := 7;
    
    select count(*) into num_of_reviews from cinema_reviews where review_id = p_rid;
    
    if num_of_reviews = 0 then
        dbms_output.put_line('There is no review with the given ID.');
    else
        select text_content into review from cinema_reviews cr where p_rid = cr.review_id;
        select score into r_score from cinema_reviews cr where p_rid = cr.review_id;
        
        
        open c1;
        loop
            fetch c1 into user_count;
            exit when c1%notfound;
        
            if user_count > 0 then
                dbms_output.put_line('The user has seen a movie here.');
            else
                dbms_output.put_line('This review has been flagged because the user has not been to this cinema.');
            end if;
        
        end loop;
        close c1;
        
        if (r_score = 1 OR r_score = 5) AND (length(review) <=  r_length) then
            dbms_output.put_line('This review is flagged as suspicious because it has an extreme score with a short review.');
        else
            dbms_output.put_line('The review meets the criteria and is good.');
        end if;
    end if;
    
    
END;
