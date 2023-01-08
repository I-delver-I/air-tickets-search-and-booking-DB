USE air_tickets_search_and_booking;
GO

CREATE TRIGGER specifying_ticket_status_as_booked
ON ticket_booking
AFTER INSERT
AS
BEGIN
	UPDATE ticket
	SET status_id = dbo.GetTicketStatusIdByName('Booked')
	WHERE id = (SELECT ins.ticket_id FROM inserted AS ins)
END;
GO

CREATE TRIGGER specifying_ticket_status_as_available
ON ticket_booking
AFTER DELETE
AS
BEGIN
	UPDATE ticket
	SET status_id = dbo.GetTicketStatusIdByName('Available')
	WHERE id = (SELECT del.ticket_id FROM deleted AS del)
END;
GO

CREATE TRIGGER taking_money_for_booking_ticket
ON ticket_booking
AFTER INSERT
AS
BEGIN
	UPDATE [user]
	SET dollars_count = dollars_count - (
		SELECT t.price
		FROM inserted AS ins
		INNER JOIN ticket AS t
		ON ins.ticket_id = t.id
	)
	WHERE person_id = (SELECT ins.[user_id] FROM inserted AS ins)
END;
GO

CREATE TRIGGER returning_money_due_to_unbooking_ticket
ON ticket_booking
AFTER DELETE
AS
BEGIN
	DECLARE @money_to_pay_back MONEY = (
		SELECT t.price
		FROM ticket AS t
		INNER JOIN deleted AS del
		ON t.id = del.ticket_id
	)

	IF (DATEDIFF(HOUR, GETDATE(),
		(
			SELECT t.flight_date
			FROM ticket AS t
			INNER JOIN deleted AS del
			ON del.ticket_id = t.id
		)) <= 7
	)
		SET @money_to_pay_back = @money_to_pay_back * 0.7

	UPDATE [user]
	SET dollars_count = dollars_count + @money_to_pay_back 
	WHERE person_id = (SELECT del.[user_id] FROM deleted AS del)
END;
GO