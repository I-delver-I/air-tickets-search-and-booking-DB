USE air_tickets_search_and_booking;

GO  
CREATE VIEW tickets_details_view
AS  
	SELECT DISTINCT t.id, f.[name] AS flight_name, f.destination_place, f.start_place, t.flight_date,
		f.arriving_time, f.departure_time, t.price, tc.[name] AS ticket_class_name
	FROM ticket AS t
	INNER JOIN plane_to_flight AS ptf
		ON t.flight_name = ptf.flight_name
			AND t.plane_id = ptf.plane_id
	INNER JOIN flight AS f
		ON PTF.flight_name = f.[name]
	INNER JOIN ticket_class AS tc
		ON tc.id = t.ticket_ñlass_id;

GO  
CREATE VIEW users_details_view
AS
	SELECT u.person_id, p.[name], p.surname, pa.nationality, cd.number AS credit_card_number,
		u.country, u.town, u.email, u.phone_number
	FROM [user] AS u
	INNER JOIN person AS p
		ON u.person_id = p.id
	INNER JOIN passport AS pa
		ON pa.number = u.passport_number
	INNER JOIN credit_card AS cd
		ON cd.number = u.credit_card_number;

GO  
CREATE VIEW ticket_booking_details_view
AS
	SELECT udv.[name], udv.surname, udv.country, udv.credit_card_number, udv.email, udv.phone_number,
		tdv.start_place, tdv.destination_place, tdv.price, tdv.flight_date, tdv.departure_time
	FROM ticket_booking AS tb
	INNER JOIN dbo.users_details_view AS udv
		ON tb.[user_id] = udv.person_id
	INNER JOIN dbo.tickets_details_view AS tdv
		ON tdv.id = tb.ticket_id;