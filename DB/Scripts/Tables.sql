USE air_tickets_search_and_booking;

CREATE TABLE person
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	name NVARCHAR(80) NOT NULL,
	surname NVARCHAR(80) NOT NULL,
	birth_date DATE NOT NULL,
	CONSTRAINT CK_person_is_adult
		CHECK (DATEDIFF(YEAR, birth_date, CONVERT(DATE, GETDATE())) >= 18)
);

CREATE TABLE passport
(
	number NVARCHAR(9),
	issuing_country NVARCHAR(100),
	expiration_date DATE NOT NULL,
	nationality NVARCHAR(50) NOT NULL,
	PRIMARY KEY (number, issuing_country),
	CONSTRAINT CK_expiration_date_is_bigger_than_current
		CHECK (expiration_date > CONVERT(DATE, GETDATE()))
);

CREATE TABLE credit_card
(
	number BIGINT PRIMARY KEY,
	creation_date DATE NOT NULL,
	expiration_date DATE NOT NULL,
	CONSTRAINT CK_creation_date_is_not_bigger_than_current
		CHECK (creation_date <= CONVERT(DATE, GETDATE())),
	CONSTRAINT CK_card_has_at_least_one_year_before_expiration
		CHECK (expiration_date >= DATEADD(YEAR, 1, CAST(creation_date AS SMALLDATETIME))),
	CONSTRAINT CK_number_has_bigger_than_seven_digits_and_less_than_twenty
		CHECK (9999999 < number AND number < 10000000000000000000)
);

CREATE TABLE [user]
(
	person_id INT PRIMARY KEY,
	email NVARCHAR(320),
	phone_number BIGINT,
	dollars_count MONEY NOT NULL
		CONSTRAINT DF_money_count DEFAULT 0,
	credit_card_number BIGINT,
	town NVARCHAR(100) NOT NULL,
	country NVARCHAR(100) NOT NULL,
	passport_number NVARCHAR(9),
	passport_issuing_country NVARCHAR(100),
	CONSTRAINT CK_phone_number_length_is_correct
		CHECK (999 < phone_number AND phone_number < 1000000000000),
	CONSTRAINT FK_user_person
		FOREIGN KEY (person_id)
		REFERENCES person(id),
	CONSTRAINT CK_AtLeastOneContact CHECK
	(
		email IS NOT NULL 
		OR
		phone_number IS NOT NULL
	),
	CONSTRAINT FK_user_credit_card
		FOREIGN KEY (credit_card_number)
		REFERENCES credit_card(number)
		ON DELETE SET NULL,
	CONSTRAINT FK_user_passport
		FOREIGN KEY (passport_number, passport_issuing_country)
		REFERENCES passport(number, issuing_country)
		ON DELETE SET NULL
);

CREATE TABLE plane
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	default_seats_count INT NOT NULL
		CONSTRAINT DF_default_seats_count DEFAULT 1,
	vip_seats_count INT NOT NULL
		CONSTRAINT DF_vip_seats_count DEFAULT 0,
	manufacture_date DATE NOT NULL,
	CONSTRAINT CK_manufacture_date_is_less_than_current
		CHECK (manufacture_date <= CONVERT(DATE, GETDATE()))
);

CREATE TABLE flight
(
	[name] NVARCHAR(7) PRIMARY KEY,
	start_place NVARCHAR(150) NOT NULL,
	destination_place NVARCHAR(150) NOT NULL,
	departure_time TIME NOT NULL,
	arriving_time TIME NOT NULL
);

CREATE TABLE plane_to_flight
(
	plane_id INT,
	flight_name NVARCHAR(7),
	PRIMARY KEY (plane_id, flight_name),
	CONSTRAINT FK_plane_to_flight_plane
		FOREIGN KEY (plane_id)
		REFERENCES plane(id),
	CONSTRAINT FK_plane_to_flight_flight
		FOREIGN KEY (flight_name)
		REFERENCES flight([name]),
	CONSTRAINT CK_plane_is_not_outdated
		CHECK (dbo.IsPlaneOutdated(plane_id) = 0)
);

CREATE TABLE ticket_status
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	name NVARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE ticket_class
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	name NVARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE ticket
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	status_id INT
		CONSTRAINT DF_available
		DEFAULT dbo.GetTicketStatusIdByName('Available'),
	ticket_ñlass_id INT,
	price MONEY NOT NULL,
	plane_id INT,
	flight_name NVARCHAR(7),
	flight_date DATETIME
		CONSTRAINT DF_flight_date_in_three_months
		DEFAULT DATEADD(MONTH, 3, GETDATE()),
	CONSTRAINT FK_ticket_ticket_status
		FOREIGN KEY (status_id)
		REFERENCES ticket_status(id),
	CONSTRAINT FK_ticket_ticket_class
		FOREIGN KEY (ticket_ñlass_id)
		REFERENCES ticket_class(id),
	CONSTRAINT FK_ticket_plane_to_flight
		FOREIGN KEY (plane_id, flight_name)
		REFERENCES plane_to_flight(plane_id, flight_name)
		ON DELETE SET NULL,
	CONSTRAINT CK_plane_has_not_attached_flight_on_the_date
		CHECK (dbo.PlaneHasAttachedFlightOnTheDate(plane_id, flight_date) = 1),
	CONSTRAINT CK_new_ticket_can_be_created
		CHECK (dbo.SeatForNewTicketIsAvailable(ticket_ñlass_id, plane_id) = 1)
);

CREATE TABLE ticket_booking
(
	[user_id] INT,
	ticket_id INT UNIQUE,
	[current_date] DATETIME
		CONSTRAINT DF_current_date_is_today
			DEFAULT GETDATE(),
	PRIMARY KEY([user_id], ticket_id),
	CONSTRAINT FK_ticket_booking_user
		FOREIGN KEY ([user_id])
		REFERENCES [user](person_id),
	CONSTRAINT FK_ticket_booking_ticket
		FOREIGN KEY (ticket_id)
		REFERENCES ticket(id),
	CONSTRAINT CK_user_has_enough_money_to_buy_ticket
		CHECK (dbo.UserHasEnoughMoneyToBuyTicket([user_id], ticket_id) = 1)
);