USE air_tickets_search_and_booking;

GO
CREATE FUNCTION dbo.GetTicketStatusIdByName(@ticket_status_name NVARCHAR(30))
RETURNS INT
WITH EXECUTE AS CALLER
AS
BEGIN
	RETURN (
		SELECT ts.id 
		FROM ticket_status AS ts 
		WHERE ts.[name] = @ticket_status_name
	)
END;

GO
CREATE FUNCTION dbo.GetTicketClassIdByName(@ticket_class_name NVARCHAR(30))
RETURNS INT
WITH EXECUTE AS CALLER
AS
BEGIN
	RETURN (
		SELECT tc.id 
		FROM ticket_class AS tc
		WHERE tc.[name] = @ticket_class_name
	)
END;

GO
CREATE FUNCTION dbo.IsPlaneOutdated(@plane_id INT)
RETURNS BIT
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @manufacture_date DATE = 
		(
			SELECT p.manufacture_date
			FROM plane AS p
			WHERE @plane_id = p.id
		)

	IF (DATEDIFF(YEAR, @manufacture_date, CONVERT(DATE, GETDATE())) >= 20)
		RETURN 1

	RETURN 0
END;

GO
CREATE FUNCTION dbo.PlaneHasAttachedFlightOnTheDate(@plane_id INT, @flight_date DATETIME)
RETURNS BIT
WITH EXECUTE AS CALLER
AS
BEGIN
	IF 
	(
		(
			SELECT COUNT(*) 
			FROM plane AS p
			INNER JOIN ticket AS t
			ON t.plane_id = p.id
			WHERE p.id = @plane_id
				AND t.flight_date = @flight_date
		) > 0
	)
		RETURN 1

	RETURN 0
END;

GO
CREATE FUNCTION dbo.SeatForNewTicketIsAvailable(@ticket_class_id INT, @plane_id INT)
RETURNS BIT 
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @ticket_class_name NVARCHAR(30) = 
	(
		SELECT tc.[name]
		FROM ticket_class AS tc
		WHERE tc.id = @ticket_class_id
	)
	DECLARE @unbooked_seats_count INT
		
	IF (@ticket_class_name = 'VIP')
		SET @unbooked_seats_count = 
		(
			SELECT p.vip_seats_count
			FROM plane AS p
			WHERE p.id = @plane_id
		) - dbo.GetTicketsCount(@ticket_class_name, @plane_id)
	
	IF (@ticket_class_name = 'Default')
		SET @unbooked_seats_count = 
		(
			SELECT p.default_seats_count
			FROM plane AS p
			WHERE p.id = @plane_id
		) - dbo.GetTicketsCount(@ticket_class_name, @plane_id)

	IF (@unbooked_seats_count + 1 > 0)
		RETURN 1

	RETURN 0
END;

GO
CREATE FUNCTION dbo.GetTicketsCount(@ticket_class_name NVARCHAR(30), @plane_id INT)
RETURNS INT 
WITH EXECUTE AS CALLER
AS
BEGIN
	RETURN (
		SELECT COUNT(*) AS existing_tickets_count
		FROM ticket AS t
		INNER JOIN ticket_class AS tc
		ON t.ticket_ñlass_id = tc.id
		INNER JOIN plane AS p
		ON p.id = t.plane_id
		WHERE p.id = @plane_id 
			AND tc.[name] = @ticket_class_name
	)
END;

GO
CREATE FUNCTION dbo.UserHasEnoughMoneyToPay(@user_id INT, @money_to_pay MONEY)
RETURNS BIT 
WITH EXECUTE AS CALLER
AS
BEGIN
	IF EXISTS (
		SELECT * FROM [user] AS u
		WHERE u.person_id = @user_id 
			AND u.dollars_count >= @money_to_pay
	)
		RETURN 1

	RETURN 0
END;

GO
CREATE FUNCTION dbo.UserHasEnoughMoneyToBuyTicket(@user_id INT, @ticket_id INT)
RETURNS BIT 
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @ticket_price MONEY = (
		SELECT t.price
		FROM ticket AS t
		WHERE t.id = @ticket_id
	)

	RETURN dbo.UserHasEnoughMoneyToPay(@user_id, @ticket_price)
END;