USE air_tickets_search_and_booking;
GO

CREATE TRIGGER specifying_ticket_status_as_booked
ON ticket_booking
AFTER INSERT
AS
BEGIN
	UPDATE ticket
	SET status_id = dbo.GetTicketStatusIdByName('Booked')
	WHERE id IN (SELECT ins.ticket_id FROM inserted AS ins)
END;
GO

CREATE TRIGGER specifying_ticket_status_as_available
ON ticket_booking
AFTER DELETE
AS
BEGIN
	UPDATE ticket
	SET status_id = dbo.GetTicketStatusIdByName('Available')
	WHERE id IN (SELECT del.ticket_id FROM deleted AS del)
END;
GO

CREATE TRIGGER taking_money_for_booking_ticket
ON ticket_booking
AFTER INSERT
AS
BEGIN
	DECLARE @user_id INT
	DECLARE @ticket_price MONEY

	DECLARE users_payment_cursor CURSOR FOR
	SELECT ins.[user_id], t.price
	FROM inserted AS ins
	INNER JOIN ticket AS t
		ON t.id = ins.ticket_id

	OPEN users_payment_cursor

	FETCH NEXT FROM users_payment_cursor
		INTO @user_id, @ticket_price

	WHILE @@FETCH_STATUS = 0
		BEGIN
			UPDATE [user]
			SET dollars_count = dollars_count - @ticket_price
			WHERE person_id = @user_id

			FETCH NEXT FROM users_payment_cursor
				INTO @user_id, @ticket_price
		END

	CLOSE users_payment_cursor
	DEALLOCATE users_payment_cursor
END;
GO

CREATE TRIGGER returning_money_due_to_unbooking_ticket
ON ticket_booking
AFTER DELETE
AS
BEGIN
	DECLARE @deleted_borrowing_records TABLE
	(
		id INT IDENTITY(1,1) PRIMARY KEY,
		[user_id] INT NOT NULL,
		flight_date DATETIME NOT NULL,
		booking_date DATETIME NOT NULL,
		ticket_price MONEY NOT NULL
	)

	INSERT INTO @deleted_borrowing_records([user_id], flight_date, booking_date, ticket_price)
	SELECT del.[user_id], t.flight_date, del.[current_date], t.price
	FROM ticket AS t
	INNER JOIN deleted AS del
		ON del.ticket_id = t.id

	DECLARE @user_id INT
	DECLARE @flight_date DATETIME
	DECLARE @booking_date DATETIME
	DECLARE @ticket_price MONEY

	DECLARE deleted_borrowing_records_cursor CURSOR FOR
	SELECT dbr.[user_id], dbr.flight_date, dbr.booking_date, dbr.ticket_price
	FROM @deleted_borrowing_records AS dbr

	OPEN deleted_borrowing_records_cursor

	FETCH NEXT FROM deleted_borrowing_records_cursor 
		INTO @user_id, @flight_date, @booking_date, @ticket_price

	WHILE @@FETCH_STATUS = 0
		BEGIN
			UPDATE [user]
			SET dollars_count = dollars_count + 
			(
				CASE
					WHEN 
						DATEDIFF(HOUR, @booking_date, @flight_date) <= 7
					THEN @ticket_price * 0.7
					ELSE @ticket_price
				END
			)
			WHERE person_id = @user_id

			FETCH NEXT FROM deleted_borrowing_records_cursor 
				INTO @user_id, @flight_date, @booking_date, @ticket_price
		END

	CLOSE deleted_borrowing_records_cursor
	DEALLOCATE deleted_borrowing_records_cursor
END;
GO