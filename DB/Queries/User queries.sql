USE air_tickets_search_and_booking;

-- пошук наявних польотів для певного призначення на певну дату
SELECT f.start_place, f.destination_place, t.flight_date, ptf.flight_name
FROM flight AS f
INNER JOIN plane_to_flight AS ptf
	ON f.[name] = ptf.flight_name
INNER JOIN ticket AS t
	ON ptf.plane_id = t.plane_id
	AND ptf.flight_name = t.flight_name
WHERE f.destination_place like 'Ha%'
	AND t.flight_date < '2023-01-06';

-- визначення кількості відповідних місць у літаку та його дату виготовлення
SELECT 
	(
		SELECT COUNT(*)
		FROM ticket AS t
		INNER JOIN ticket_status AS ts
			ON ts.id = t.status_id
		WHERE t.plane_id = p.id
			AND ts.[name] = 'Available'
			AND t.status_id = dbo.GetTicketClassIdByName('Default')
	) AS default_tickets_count,
	(
		SELECT COUNT(*)
		FROM ticket AS t
		INNER JOIN ticket_status AS ts
			ON ts.id = t.status_id
		WHERE t.plane_id = p.id
			AND ts.[name] = 'Available'
			AND t.status_id = dbo.GetTicketClassIdByName('VIP')
	) AS vip_tickets_count, p.manufacture_date
FROM plane AS p
WHERE p.id = 3;

-- отримання історії куплених квитків
SELECT t.flight_date, t.price, tb.[current_date] AS booking_date
FROM ticket_booking AS tb
INNER JOIN ticket AS t
	ON tb.ticket_id = t.id
INNER JOIN ticket_status AS ts
	ON ts.id = t.status_id
INNER JOIN [user] AS u
	ON tb.[user_id] = u.person_id
WHERE u.passport_number = '117484885';

-- отримати інформацію про місця на вільний літак
SELECT DISTINCT ptf.flight_name, p.id AS plane_id, p.default_seats_count, p.vip_seats_count
FROM plane AS p
INNER JOIN plane_to_flight AS ptf
	ON ptf.plane_id = p.id
INNER JOIN ticket AS t
	ON t.plane_id = p.id;