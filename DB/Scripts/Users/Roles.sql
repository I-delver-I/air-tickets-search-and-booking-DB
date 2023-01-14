USE air_tickets_search_and_booking;

CREATE ROLE db_user;

GRANT SELECT ON ticket TO db_user;

GRANT SELECT ON plane TO db_user;

GRANT EXECUTE ON OBJECT::dbo.spunbook_ticket TO db_user;

GRANT EXECUTE ON OBJECT::dbo.spbook_ticket TO db_user;

GRANT EXECUTE ON OBJECT::dbo.sptransfer_money_to_account TO db_user;

GRANT EXECUTE ON OBJECT::dbo.spquery_ticket_booking_history TO db_user;

GRANT SELECT ON plane_to_flight TO db_user;


CREATE ROLE db_worker;

GRANT EXECUTE ON OBJECT::dbo.spdelete_user TO db_worker;

GRANT EXECUTE ON OBJECT::dbo.spdelete_ticket TO db_worker;

GRANT EXECUTE ON OBJECT::dbo.spdelete_expired_tickets TO db_worker;

GRANT SELECT ON SCHEMA :: [dbo] TO db_worker;

GRANT ALTER ON SCHEMA :: [dbo] TO db_worker;

GRANT CONTROL ON SCHEMA :: [dbo] TO db_worker;

GRANT CREATE SEQUENCE ON SCHEMA :: [dbo] TO db_worker;

GRANT DELETE ON SCHEMA :: [dbo] TO db_worker;

GRANT EXECUTE ON SCHEMA :: [dbo] TO db_worker;

GRANT INSERT ON SCHEMA :: [dbo] TO db_worker;

GRANT REFERENCES ON SCHEMA :: [dbo] TO db_worker;

GRANT UPDATE ON SCHEMA :: [dbo] TO db_worker;

GRANT VIEW CHANGE TRACKING ON SCHEMA :: [dbo] TO db_worker;

GRANT VIEW DEFINITION ON SCHEMA :: [dbo] TO db_worker;


CREATE ROLE db_administrator;

GRANT SELECT ON SCHEMA :: [dbo] TO db_administrator;

GRANT ALTER ON SCHEMA :: [dbo] TO db_administrator;

GRANT CONTROL ON SCHEMA :: [dbo] TO db_administrator;

GRANT CREATE SEQUENCE ON SCHEMA :: [dbo] TO db_administrator;

GRANT DELETE ON SCHEMA :: [dbo] TO db_administrator;

GRANT EXECUTE ON SCHEMA :: [dbo] TO db_administrator;

GRANT INSERT ON SCHEMA :: [dbo] TO db_administrator;

GRANT REFERENCES ON SCHEMA :: [dbo] TO db_administrator;

GRANT TAKE OWNERSHIP ON SCHEMA :: [dbo] TO db_administrator;

GRANT UPDATE ON SCHEMA :: [dbo] TO db_administrator;

GRANT VIEW CHANGE TRACKING ON SCHEMA :: [dbo] TO db_administrator;

GRANT VIEW DEFINITION ON SCHEMA :: [dbo] TO db_administrator;