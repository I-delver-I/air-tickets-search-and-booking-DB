USE air_tickets_search_and_booking;
GO

CREATE PROCEDURE dbo.spdelete_expired_tickets
AS
	SET NOCOUNT ON
	DELETE FROM ticket
	WHERE status_id = 'Available' 
		AND flight_date > GETDATE();
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
	IF (
		dbo.UserHasEnoughMoneyToPay(@user_id, 
		(
			SELECT t.price
			FROM ticket AS t
			WHERE t.id = @ticket_id
		)) = 0
	)
		RETURN

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