/*
FEATURE 8: Buy Tickets for a Movie Show
*/

set serveroutput on;

--drop sequence movie_trans_id;
--create sequence movie_trans_id start with 1006;

--select * from movie_transactions;

create or replace procedure buy_ticket(p_uid in integer, p_title in varchar,
p_cid in integer, p_start in timestamp, p_format in varchar,
p_adults in integer, p_kids in integer, p_seniors in integer)
IS
    num_users integer;
    mov_id integer;
    movie_time timestamp;
    num_showtimes integer;
    aud_capacity integer;
    showtime_id integer;
    prev_quantity_sold integer; --number of tickets sold
    tickets_avail integer;
    num_purchased integer; --number of tickets for this order
    
    adult_price number;
    child_disc number; --discount rate
    sen_disc number; --discount rate
    child_price number;
    sen_price number;
    tot_adult number; --total price of all adult tickets
    tot_child number; --total price of all child tickets
    tot_senior number; --total price of all senior tickets
    
    tax_rate number;
    ticket_fee number;
    
    total_ticket_fee number; --total amount of fees charged
    total_cost number;
    total_ticket_price number; --total amount for all tickets
    total_final_cost number; --total amount with tax and fees
    
    cursor c1 is select quantity into prev_quantity_sold from movie_transactions
            where show_id = showtime_id
            and user_id = p_uid;
BEGIN

    --initialize variables
    tax_rate := 0.06;
    ticket_fee := 1.5;
    prev_quantity_sold := 0;
    
    --get the number of users that have the user id from input
    select count(*)into num_users from cuser where user_id = p_uid;
    
    --print error if user id doesnt exist
    if num_users != 1 then
        dbms_output.put_line('Please enter a valid user ID.');
    else
        --get movie id from the input title
        select movie_id into mov_id from movie where title = p_title;
        --dbms_output.put_line('Movie id: ' || mov_id);
        
        --b: find number of showtimes available for movie
        select count(*) into num_showtimes from showtime s
        where s.movie_id = mov_id
        and s.cinema_id = p_cid
        and s.start_time = p_start
        and s.format = p_format;
        
--        dbms_output.put_line('num showtimes: ' || num_showtimes);
        --b:
        if num_showtimes = 0 then
            dbms_output.put_line('Sorry, there are no shows at that time.');
        elsif num_showtimes > 1 then
            dbms_output.put_line('Please provide a more specific movie title...');
        elsif num_showtimes = 1 then
            --dbms_output.put_line('There is a match!');
            
            --get and save showtime id
            select show_id into showtime_id from showtime s
            where s.movie_id = mov_id
            and s.cinema_id = p_cid
            and s.start_time = p_start
            and s.format = p_format;
            
--            dbms_output.put_line('Showtime ID: ' || showtime_id);
            
            --c: get capacity
            select capacity into aud_capacity from auditorium a, showtime s
            where s.show_id = showtime_id
            and s.auditorium_id = a.auditorium_id;
            
--            dbms_output.put_line('capacity: ' || aud_capacity);
            
            --c: get previous amt sold
--            select quantity into prev_quantity_sold from movie_transactions
--            where show_id = showtime_id
--            and user_id = p_uid;
            open c1;
            loop
                fetch c1 into prev_quantity_sold;
                exit when c1%notfound;
                prev_quantity_sold := prev_quantity_sold + prev_quantity_sold;
            end loop;
            close c1;
            
--            dbms_output.put_line('quantity: ' || prev_quantity_sold);
         
            --calculate number of tickets purchased, and number available for purchase
            tickets_avail := aud_capacity - prev_quantity_sold;
            num_purchased := p_adults + p_kids + p_seniors;
            
            --do stuff depending if there is enough capacity to purchase tickets
            if ((aud_capacity - prev_quantity_sold) >= num_purchased) then
            
            --get and store price for regular tickets
            select base_price into adult_price from showtime where show_id = showtime_id;
            
            --get and store child discount amount
            select child_discount into child_disc from company co, cinema cin
            where p_cid = cin.cinema_id
            and cin.company_id = co.company_id;
            
            --get and store senior discount amount
            select senior_discount into sen_disc from company co, cinema cin
            where p_cid = cin.cinema_id
            and cin.company_id = co.company_id;
            
            --calculate ticket prices
            child_price := adult_price - (adult_price * child_disc);
            sen_price := adult_price - (adult_price * sen_disc);
            
            tot_adult := adult_price* p_adults;
            tot_child := child_price* p_kids;
            tot_senior := sen_price* p_seniors;
            total_ticket_fee := num_purchased * ticket_fee;
            total_ticket_price := tot_adult + tot_child + tot_senior + total_ticket_fee;
            total_final_cost := total_ticket_price + (total_ticket_price * tax_rate);
            
             --create transaction
            insert into movie_transactions values(movie_trans_id.nextval, p_uid, showtime_id, current_timestamp,
            num_purchased, 0, total_final_cost);

            --print report of sale
            dbms_output.put_line('Report');
            dbms_output.put_line('');
            dbms_output.put_line('Number of adult tickets: ' || p_adults);
            dbms_output.put_line('Price of adult tickets: $' || adult_price);
            dbms_output.put_line('Total Adult Price: $' ||tot_adult );
            dbms_output.put_line('');
            dbms_output.put_line('Number of children tickets: ' || p_kids);
            dbms_output.put_line('Price of children tickets: $' || child_price);
            dbms_output.put_line('Total Child Price: $' || tot_child);
            dbms_output.put_line('');
            dbms_output.put_line('Number of senior tickets: ' || p_seniors);
            dbms_output.put_line('Price of senior tickets: $' || sen_price);
            dbms_output.put_line('Total Senior Price: $' || tot_senior);
            dbms_output.put_line('');
            dbms_output.put_line('Fees');
            dbms_output.put_line('');
            dbms_output.put_line('Number of tickets: ' || num_purchased);
            dbms_output.put_line('Total Ticket Fees($1.50 each): $' || total_ticket_fee);
            dbms_output.put_line('Total Cost of Tickets, w/o tax: $' || total_ticket_price);
            dbms_output.put_line('');
            dbms_output.put_line('Tax (6%): $' || (total_ticket_price * tax_rate));
            dbms_output.put_line('Total Cost of Tickets: $' || total_final_cost);
            else
                dbms_output.put_line('There are not enough seats left.');
            end if;
            
            
--    here       
        end if;
    end if;

exception
    when no_data_found then
        dbms_output.put_line('Sorry, there are no movies with that title.');
--    when too_many_rows then
--        dbms_output.put_line('Please be more specific in the movie title...end');
        

END;