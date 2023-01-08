USE air_tickets_search_and_booking;

-- здобуття інформації про користувача
SELECT p.[name], p.surname, p.birth_date, u.country, u.credit_card_number
FROM [user] AS u
INNER JOIN person AS p
	ON u.person_id = p.id
WHERE u.person_id = 4;