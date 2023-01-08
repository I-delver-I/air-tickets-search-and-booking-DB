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
		WHERE t.plane_id = p.id
			AND t.status_id = dbo.GetTicketClassIdByName('Default')
	) AS default_tickets_count,
	(
		SELECT COUNT(*)
		FROM ticket AS t
		WHERE t.plane_id = p.id
			AND t.status_id = dbo.GetTicketClassIdByName('VIP')
	) AS vip_tickets_count, p.manufacture_date
FROM plane AS p
WHERE p.id = 3;

-- отримання історії куплених квитків
SELECT p.[name], p.surname, t.flight_date, t.price, 
	tb.[current_date] AS booking_date
FROM ticket_booking AS tb
INNER JOIN ticket AS t
	ON tb.ticket_id = t.id
INNER JOIN ticket_status AS ts
	ON ts.id = t.status_id
INNER JOIN [user] AS u
	ON tb.[user_id] = u.person_id
INNER JOIN person AS p
	ON u.person_id = p.id
WHERE tb.[user_id] = 1;