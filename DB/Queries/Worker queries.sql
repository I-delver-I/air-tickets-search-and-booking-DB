USE air_tickets_search_and_booking;

-- здобуття інформації про користувача
SELECT p.[name], p.surname, p.birth_date, u.country, u.credit_card_number
FROM [user] AS u
INNER JOIN person AS p
	ON u.person_id = p.id
WHERE u.person_id = 4;

-- перевірка літаків на прострочені
SELECT p.manufacture_date, (
		SELECT COUNT(*) 
		FROM plane_to_flight AS ptf
		WHERE ptf.plane_id = p.id 
	) AS flights_count, p.default_seats_count, p.vip_seats_count
FROM plane AS p
WHERE dbo.IsPlaneOutdated(p.id) = 1;

-- дізнатися про користувачів, у яких закінчився термін придатності паспорта
SELECT pa.expiration_date, p.[name], p.surname, pa.nationality, pa.issuing_country
FROM person AS p
INNER JOIN [user] AS u
	ON u.person_id = p.id
INNER JOIN passport AS pa
	ON pa.number = u.passport_number
WHERE pa.expiration_date < GETDATE();

-- дізнатися про користувачів, у яких закінчився термін придатності кредитної картки
SELECT p.[name], p.surname, cc.expiration_date, u.email, u.phone_number
FROM [user] AS u
INNER JOIN credit_card AS cc
	ON u.credit_card_number = cc.number
INNER JOIN person As p
	ON u.person_id = p.id
WHERE GETDATE() > cc.expiration_date;