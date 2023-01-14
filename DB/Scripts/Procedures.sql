USE air_tickets_search_and_booking;
GO

CREATE PROCEDURE dbo.spdelete_user(@user_id INT)
AS
	SET NOCOUNT ON
		DELETE FROM [user]
		WHERE person_id = @user_id
	GO

CREATE PROCEDURE dbo.spdelete_ticket(@ticket_id INT)
AS
	SET NOCOUNT ON
	IF 
	(
		NOT EXISTS(
			SELECT *
			FROM ticket_booking AS tb
			WHERE tb.ticket_id = @ticket_id
		)
	)
		DELETE FROM ticket
		WHERE id = @ticket_id
GO

CREATE PROCEDURE dbo.spdelete_expired_tickets
AS
	SET NOCOUNT ON
	DELETE FROM ticket
	WHERE status_id = 'Available' 
		AND flight_date < GETDATE();
GO

CREATE PROCEDURE dbo.spunbook_ticket(@user_id INT, @ticket_id INT)
AS
	SET NOCOUNT ON
	DELETE FROM ticket_booking
	WHERE [user_id] = @user_id
		AND ticket_id = @ticket_id;
GO

CREATE PROCEDURE dbo.spbook_ticket(@user_id INT, @ticket_id INT)
AS
	SET NOCOUNT ON
	INSERT INTO ticket_booking([user_id], ticket_id)
	VALUES
		(@user_id, @ticket_id);
GO

CREATE PROCEDURE dbo.sptransfer_money_to_account(@user_id INT, @money_count MONEY)
AS
	SET NOCOUNT ON
	UPDATE [user]
	SET dollars_count = dollars_count + @money_count
	WHERE person_id = @user_id;
GO

CREATE PROCEDURE dbo.spquery_ticket_booking_history(@passport_number NVARCHAR(9))
AS
	SET NOCOUNT ON
		SELECT t.flight_date, t.price, tb.[current_date] AS booking_date
		FROM ticket_booking AS tb
		INNER JOIN ticket AS t
			ON tb.ticket_id = t.id
		INNER JOIN ticket_status AS ts
			ON ts.id = t.status_id
		INNER JOIN [user] AS u
			ON tb.[user_id] = u.person_id
		INNER JOIN passport AS pa
			ON pa.number = u.passport_number
		WHERE pa.number = @passport_number
GO