USE air_tickets_search_and_booking;

-- інформація про популярність рейсів
SELECT f.[name], COUNT(*) AS sold_tickets_count
FROM ticket_booking AS tb
INNER JOIN ticket AS t
	ON tb.ticket_id = t.id
INNER JOIN flight AS f
	ON f.[name] = t.flight_name
GROUP BY f.[name]
ORDER BY sold_tickets_count;

-- отримання даних про літаки, яким не призначені рейси
SELECT p.manufacture_date, p.default_seats_count, p.vip_seats_count
FROM plane AS p
WHERE p.id NOT IN (
	SELECT ptf.plane_id
	FROM plane_to_flight AS ptf
);

-- отримання даних про кількість куплених vip-квитків на певних рейсах
SELECT t.flight_name, COUNT(*) AS bought_tickets_count
FROM ticket AS t
INNER JOIN plane_to_flight AS ptf
	ON t.flight_name = ptf.flight_name
INNER JOIN ticket_class AS tc
	ON t.ticket_сlass_id = tc.id
INNER JOIN ticket_status AS ts
	ON ts.id = t.status_id
WHERE tc.[name] = 'VIP'
	AND ts.[name] = 'Booked'
GROUP BY t.flight_name
ORDER BY bought_tickets_count DESC;

-- дізнатися кількість громадян відповідних країн, котрі зареєстровані у системі авіакомпанії
SELECT pa.issuing_country, COUNT(*) AS people_count, 
	AVG(DATEDIFF(YEAR, p.birth_date, GETDATE())) AS average_people_age
FROM passport AS pa
INNER JOIN [user] AS u
	ON pa.number = u.passport_number
		AND u.passport_issuing_country = pa.issuing_country
INNER JOIN person AS p
	ON p.id = u.person_id
GROUP BY pa.issuing_country
ORDER BY people_count DESC;

-- отримати дані про цінову політику рейсів
SELECT DISTINCT ptf.flight_name, t.price
FROM ticket AS t
INNER JOIN plane_to_flight AS ptf
	ON t.flight_name = ptf.flight_name
ORDER BY t.price DESC;

-- отримати дані про користувачів, які ніколи не купували vip-квитки
SELECT p.[name], p.surname, u.dollars_count
FROM [user] AS u
INNER JOIN person AS p
	ON u.person_id = p.id
INNER JOIN ticket_booking AS tb
	ON tb.[user_id] = u.person_id
INNER JOIN ticket AS t
	ON t.id = tb.ticket_id
INNER JOIN ticket_class AS tc
	ON t.ticket_сlass_id = tc.id
WHERE tc.[name] = 'Default';

-- дізнатися про аеропорти, куди літаки літають найчастіше
SELECT f.destination_place, (
	SELECT COUNT(*)
	FROM plane_to_flight AS ptf
	WHERE ptf.flight_name = f.[name]
	) AS planes_count
FROM flight AS f
GROUP BY f.destination_place, f.[name]
ORDER BY f.destination_place DESC;

-- дізнатися кількість проданих квитків відносно дат відправлення літаків
SELECT t.flight_date, COUNT(*) AS booked_tickets_count
FROM ticket AS t
INNER JOIN plane_to_flight AS ptf
	ON t.flight_name = ptf.flight_name
		AND t.plane_id = ptf.plane_id
INNER JOIN ticket_status AS ts
	ON ts.id = t.status_id
WHERE ts.[name] = 'Booked'
GROUP BY t.flight_date
ORDER BY t.flight_date DESC