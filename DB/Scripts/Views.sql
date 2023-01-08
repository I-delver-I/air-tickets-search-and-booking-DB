USE air_tickets_search_and_booking;

GO  
CREATE VIEW users_total_costs
AS  
	SELECT ps.[name], ps.surname,  
	FROM [user] AS u
	INNER JOIN person AS ps
	ON u.person_id = ps.id
	INNER JOIN 