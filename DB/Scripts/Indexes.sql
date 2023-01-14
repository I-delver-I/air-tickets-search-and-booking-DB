USE air_tickets_search_and_booking;

CREATE INDEX plane_manufacture_date_index ON plane(manufacture_date);

SELECT p.manufacture_date
FROM plane AS p
WHERE p.manufacture_date = '2013-02-05'

CREATE INDEX flight_start_place_index ON flight(start_place);

SELECT f.start_place
FROM flight AS f
WHERE f.start_place = 'Bost Airport'

CREATE INDEX flight_destination_place_index ON flight(destination_place);

SELECT f.destination_place
FROM flight AS f
WHERE f.destination_place = 'Shah Mokhdum Airport'

CREATE INDEX flight_departure_time_index ON flight(departure_time);

SELECT f.departure_time
FROM flight AS f
WHERE f.departure_time = '09:55:44.0000000'

CREATE INDEX flight_arriving_time_index ON flight(arriving_time);

SELECT f.arriving_time
FROM flight AS f
WHERE f.arriving_time = '14:00:07.0000000'

CREATE INDEX plane_default_seats_count_index ON plane(default_seats_count);

SELECT p.default_seats_count
FROM plane AS p
WHERE p.default_seats_count = 47